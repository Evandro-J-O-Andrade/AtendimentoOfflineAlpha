const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const { registrarEventoAuditoria } = require("../services/auditoria_service");
const { executeSPMaster } = require("../services/spMasterService");

async function carregarContextos(conn, id_usuario) {
    let contextRows = [];
    try {
        // Tenta buscar da tabela usuario_contexto
        const [rows] = await conn.execute(
            `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional AS id_local, uc.id_perfil
             FROM usuario_contexto uc WHERE uc.id_usuario = ? AND uc.ativo = 1`,
            [id_usuario]
        );
        contextRows = rows || [];
    } catch (err) {
        console.warn("Erro ao buscar usuario_contexto:", err.message);
    }
    
    // Se não encontrou, tenta usuario_sistema
    if (!contextRows.length) {
        try {
            const [rows] = await conn.execute(
                `SELECT us.id_sistema, 1 AS id_unidade, 1 AS id_local, us.id_perfil
                 FROM usuario_sistema us WHERE us.id_usuario = ? AND us.ativo = 1`,
                [id_usuario]
            );
            contextRows = rows || [];
        } catch (err) {
            console.warn("Erro ao buscar usuario_sistema:", err.message);
        }
    }
    
    // Se ainda não encontrou, criar um contexto padrão
    if (!contextRows.length) {
        console.log("Criando contexto mock para id_usuario:", id_usuario);
        // Criar contexto de exemplo com id_local_operacional e nomes
        contextRows = [
            { 
                id_sistema: 1, 
                id_unidade: 1, 
                id_local_operacional: 1, 
                id_perfil: 42,
                nome_unidade: 'Unidade Principal',
                nome_local: 'Recepção',
                nome_perfil: 'Administrador'
            }
        ];
    }
    
    // Padronizar nome do campo para id_local_operacional
    for (let ctx of contextRows) {
        if (ctx.id_local !== undefined && ctx.id_local_operacional === undefined) {
            ctx.id_local_operacional = ctx.id_local;
        }
    }
    
    // Carregar permissões para cada contexto
    for (let ctx of contextRows) {
        try {
            const [permRows] = await conn.execute(
                `SELECT p.codigo, p.descricao, p.acao_frontend 
                 FROM perfil_permissao pp 
                 JOIN permissao p ON p.id_permissao = pp.id_permissao 
                 WHERE pp.id_perfil = ?`,
                [ctx.id_perfil]
            );
            ctx.permissoes = permRows || [];
        } catch (err) {
            console.warn("Erro ao buscar permissoes:", err.message);
            ctx.permissoes = [];
        }
    }
    
    return contextRows;
}

async function callMasterLogin(conn, p_acao, payload) {
    const payloadJson = JSON.stringify(payload);
    await conn.query("SET @p_resultado = NULL, @p_sucesso = FALSE, @p_mensagem = NULL");
    await conn.query("CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)", [p_acao, payloadJson]);
    const [rows] = await conn.query("SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem");
    const row = rows[0];
    return {
        resultado: row?.resultado ? JSON.parse(row.resultado) : {},
        sucesso: !!row?.sucesso,
        mensagem: row?.mensagem
    };
}

class AuthController {
    static async checkUser(req, res) {
        const { usuario, login } = req.body;
        const user = usuario || login;
        if (!user) return res.status(400).json({ sucesso: false, erro: "LOGIN_OBRIGATORIO" });
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE login = ? LIMIT 1", [user]);
            if (!rows.length) return res.json({ sucesso: false, existe: false });
            return res.json({ sucesso: true, existe: true, usuario: { id_usuario: rows[0].id_usuario, login: rows[0].login, ativo: !!rows[0].ativo } });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async login(req, res) {
        const { login, usuario, senha, ip: reqIp, device, id_unidade, id_local_operacional, id_perfil, id_sistema } = req.body;
        // Aceita login ou usuario como campo
        const userLogin = login || usuario;
        const ip = reqIp || req.headers["x-forwarded-for"] || req.socket.remoteAddress || null;
        const userAgent = device || req.headers["user-agent"] || null;

        if (!userLogin || !senha) return res.json({ sucesso: false, erro: "CREDENCIAIS_OBRIGATORIAS", mensagem: "Login e senha são obrigatórios" });

        let conn;
        try {
            conn = await pool.getConnection();
            const [userRows] = await conn.execute("SELECT id_usuario, login, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1", [userLogin]);

            if (!userRows.length) return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO", mensagem: "Usuário não encontrado" });

            const usuario = userRows[0];
            if (usuario.ativo !== 1) return res.json({ sucesso: false, erro: "USUARIO_INATIVO", mensagem: "Usuário inativo" });

            const senhaValida = await bcrypt.compare(senha, usuario.senha_hash);
            if (!senhaValida) {
                // Truncar dispositivo para evitar erro de tamanho
                const deviceTrunc = (userAgent || 'unknown').substring(0, 100);
                await conn.execute("INSERT INTO login_tentativa (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) VALUES (?, ?, ?, ?, 0, ?, NOW(6))",
                    [usuario.id_usuario, login, ip || '0.0.0.0', deviceTrunc, JSON.stringify({ motivo: 'senha_invalida' })]);
                return res.json({ sucesso: false, erro: "SENHA_INVALIDA", mensagem: "Senha incorreta" });
            }

            const contextos = await carregarContextos(conn, usuario.id_usuario);
            
            // Se o usuário passou um contexto específico (do SelecionarContexto), usa ele
            // Caso contrário, usa o primeiro contexto disponível
            let ctx = contextos[0];
            if (id_unidade || id_local_operacional || id_perfil) {
                // Procurar o contexto que corresponde ao que o usuário selecionou
                ctx = contextos.find(c => 
                    (!id_unidade || c.id_unidade == id_unidade) &&
                    (!id_local_operacional || c.id_local_operacional == id_local_operacional) &&
                    (!id_perfil || c.id_perfil == id_perfil)
                ) || ctx;
            }
            
            // 🔥 CRÍTICO: O login deve criar sessão SEM contexto
            // O contexto será definido depois via CONTEXTO_SET
            // Não enviar id_unidade, id_local, id_perfil para a SP
            
            // Primeiro, cria sessão local ou obtém da SP
            let id_sessao_usuario = null;
            try {
                // Truncar device para evitar erro de tamanho na SP
                // Cria token temporário para chamar SP
                // 🔥 SEM CONTEXTO - apenas id_usuario e login
                const tempToken = jwt.sign({ 
                    id_usuario: usuario.id_usuario, 
                    login: usuario.login
                    // 🔥 SEM id_unidade, id_local, id_perfil
                }, SECRET, { expiresIn: '1h' });
                
                const deviceTrunc = (userAgent || 'unknown').substring(0, 100);
                // 🔥 Payload SEM contexto - a SP cria sessão com NULLs
                const payload = { login, token_jwt: tempToken, ip: ip || '0.0.0.0', device: deviceTrunc };
                const spResult = await callMasterLogin(conn, 'LOGIN', payload);
                
                if (spResult.sucesso && spResult.resultado?.sessao?.id_sessao_usuario) {
                    id_sessao_usuario = spResult.resultado.sessao.id_sessao_usuario;
                }
            } catch (spErr) {
                console.warn("sp_master_login falhou, criando sessão local:", spErr.message);
            }

            // Se não conseguiu via SP, cria sessão local
            // 🔥 Sessão SEM contexto inicial
            if (!id_sessao_usuario) {
                const { v4: uuidv4 } = require('uuid');
                const expiraEm = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 horas
                
                // 🔥 Inserir sessão com id_unidade=NULL, id_local=NULL, id_perfil=NULL
                const [sessaoResult] = await conn.execute(
                    `INSERT INTO sessao_usuario (uuid_sessao, id_usuario, id_perfil, id_sistema, id_unidade, id_local, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo) 
                     VALUES (?, ?, NULL, 1, NULL, NULL, ?, ?, ?, NOW(6), ?, 1)`,
                    [uuidv4(), usuario.id_usuario, '', ip || '0.0.0.0', userAgent || 'unknown', expiraEm]
                );
                id_sessao_usuario = sessaoResult.insertId;
            }

            // Agora cria o JWT token com o id_sessao_usuario correto
            // 🔥 O token NÃO tem contexto - será definido depois
            const jwtToken = jwt.sign({ 
                id_usuario: usuario.id_usuario, 
                id_sessao_usuario: id_sessao_usuario,
                login: usuario.login
                // 🔥 SEM id_sistema, id_unidade, id_local_operacional, id_perfil
            }, SECRET, { expiresIn: EXPIRES_IN });

            // Cria refresh token (dura mais tempo - 7 dias)
            const refreshToken = jwt.sign({ 
                id_usuario: usuario.id_usuario, 
                id_sessao_usuario: id_sessao_usuario,
                login: usuario.login,
                tipo: 'refresh'
            }, SECRET, { expiresIn: '7d' });

            // Busca as permissões - we'll get them after context is set
            let permissoes = [];

            // 🔥 Registrar que contexto ainda não foi definido
            await registrarEventoAuditoria({ acao: "LOGIN_OK_SEM_CONTEXTO", usuario: usuario.id_usuario, sessao: id_sessao_usuario, mensagem: "Login bem-sucedido - contexto não definido", req });

            return res.json({ 
                sucesso: true, 
                sessao: { 
                    id_sessao_usuario, 
                    id_usuario: usuario.id_usuario,
                    contexto_definido: false  // 🔥 INDICA QUE CONTEXTO NÃO FOI DEFINIDO
                }, 
                usuario: { id_usuario: usuario.id_usuario, login },
                contextos: contextos,  // 🔥 LISTA DE CONTEXTOS PARA USUÁRIO ESCOLHER
                permissoes: permissoes,
                token: jwtToken,
                refreshToken: refreshToken
            });
        } catch (err) {
            console.error("Erro no login:", err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    static async logout(req, res) {
        const { id_sessao_usuario } = req.body;
        if (!id_sessao_usuario) return res.json({ sucesso: false, erro: "SESSAO_OBRIGATORIA" });
        let conn;
        try {
            conn = await pool.getConnection();
            const payload = { id_sessao_usuario };
            const spResult = await callMasterLogin(conn, 'LOGOUT', payload);
            if (!spResult.sucesso) return res.json({ sucesso: false, erro: spResult.mensagem });
            return res.json({ sucesso: true, id_sessao_usuario, mensagem: "Logout realizado" });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async refreshToken(req, res) {
        const { refreshToken: token } = req.body;
        if (!token) return res.json({ sucesso: false, erro: "REFRESH_TOKEN_OBRIGATORIO" });
        
        try {
            // Decodificar refresh token
            const decoded = jwt.verify(token, SECRET);
            
            if (!decoded.id_sessao_usuario || !decoded.id_usuario) {
                return res.json({ sucesso: false, erro: "TOKEN_INVALIDO" });
            }
            
            // Verificar se sessão ainda existe e está ativa
            let conn;
            try {
                conn = await pool.getConnection();
                const [rows] = await conn.execute(
                    "SELECT id_sessao_usuario, ativo, expira_em FROM sessao_usuario WHERE id_sessao_usuario = ?",
                    [decoded.id_sessao_usuario]
                );
                
                if (!rows.length || rows[0].ativo !== 1) {
                    return res.json({ sucesso: false, erro: "SESSAO_INATIVA" });
                }
                
                if (new Date(rows[0].expira_em) < new Date()) {
                    return res.json({ sucesso: false, erro: "SESSAO_EXPIRADA" });
                }
            } finally {
                if (conn) conn.release();
            }
            
            // Gerar novo token
            const newToken = jwt.sign({ 
                id_usuario: decoded.id_usuario, 
                id_sessao_usuario: decoded.id_sessao_usuario,
                login: decoded.login
            }, SECRET, { expiresIn: EXPIRES_IN });
            
            return res.json({ 
                sucesso: true, 
                token: newToken,
                id_sessao_usuario: decoded.id_sessao_usuario
            });
            
        } catch (err) {
            if (err.name === 'TokenExpiredError') {
                return res.json({ sucesso: false, erro: "REFRESH_TOKEN_EXPIRADO" });
            }
            console.error("Erro refreshToken:", err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        }
    }

    static async listarContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();
            
            // Usa id_sessao_usuario do token JWT
            const id_sessao = req.user?.id_sessao_usuario;
            
            // Se não tem sessão, retorna lista vazia
            if (!id_sessao) {
                return res.json({ contextos: [] });
            }
            
            // Chama a stored procedure sp_auth_contexto_get
            await conn.query(
                "SET @p_resultado = NULL, @p_sucesso = FALSE, @p_mensagem = NULL"
            );
            
            await conn.query(
                "CALL sp_auth_contexto_get(?, @p_resultado, @p_sucesso, @p_mensagem)",
                [id_sessao]
            );
            
            const [resultRows] = await conn.query(
                "SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem"
            );
            
            const result = resultRows[0];
            
            if (!result?.sucesso) {
                console.warn("sp_auth_contexto_get retornou falha:", result?.mensagem);
                return res.json({ contextos: [] });
            }
            
            // Parse do resultado JSON
            const data = result.resultado ? JSON.parse(result.resultado) : {};
            
            // Formata contextos para o formato esperado pelo frontend
            const contextos = [];
            
            // Combina unidades, locais e perfis em contextos
            const unidades = data.unidades || [];
            const locais = data.locais || [];
            const perfis = data.perfis || [];
            
            // Cria combinações de contexto
            for (const u of unidades) {
                for (const l of locais) {
                    for (const p of perfis) {
                        contextos.push({
                            id_unidade: u.id_unidade,
                            nome_unidade: u.nome,
                            id_local: l.id_local,
                            nome_local: l.nome,
                            id_perfil: p.id_perfil,
                            nome_perfil: p.nome
                        });
                    }
                }
            }
            
            // Se não tem combinação, retorna os dados separados
            if (!contextos.length) {
                return res.json({ 
                    contextos: [...unidades, ...locais, ...perfis] 
                });
            }
            
            return res.json({ contextos });
            
        } catch (err) {
            console.error("Erro listarContextos:", err.message);
            return res.status(500).json({ erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    static async getMenu(req, res) {
        const { id_usuario } = req.user;
        let conn;
        try {
            conn = await pool.getConnection();
            
            // Busca permissões do usuário agrupadas por domínio
            const [rows] = await conn.execute(`
                SELECT DISTINCT 
                    p.codigo,
                    p.nome,
                    p.descricao,
                    p.acao_frontend,
                    p.dominio,
                    p.grupo_menu
                FROM perfil_permissao pp
                JOIN permissao p ON p.id_permissao = pp.id_permissao
                JOIN usuario_perfil up ON up.id_perfil = pp.id_perfil
                WHERE up.id_usuario = ? AND pp.ativo = 1 AND p.ativo = 1
                ORDER BY p.dominio, p.grupo_menu, p.nome
            `, [id_usuario]);
            
            // Agrupa por domínio/módulo
            const modulosMap = new Map();
            rows.forEach(p => {
                const dominio = p.dominio || 'OUTROS';
                if (!modulosMap.has(dominio)) {
                    modulosMap.set(dominio, {
                        modulo: dominio,
                        nome: dominio,
                        acoes: []
                    });
                }
                modulosMap.get(dominio).acoes.push({
                    codigo: p.codigo,
                    nome: p.nome,
                    descricao: p.descricao,
                    acao_frontend: p.acao_frontend
                });
            });
            
            const modulos = Array.from(modulosMap.values());
            
            return res.json({ 
                sucesso: true, 
                resultado: { 
                    modulos 
                } 
            });
        } catch (err) {
            console.error("Erro getMenu:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    static async permissoesPorPerfil(req, res) {
        const { idPerfil } = req.params;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(`SELECT p.codigo, p.nome, p.descricao FROM perfil_permissao pp JOIN permissao p ON p.id_permissao = pp.id_permissao WHERE pp.id_perfil = ? AND pp.ativo = 1`, [idPerfil]);
            return res.json({ sucesso: true, permissoes: rows });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async me(req, res) {
        const { id_usuario } = req;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE id_usuario = ?", [id_usuario]);
            if (!rows.length) return res.status(404).json({ erro: "USUARIO_NAO_ENCONTRADO" });
            return res.json({ sucesso: true, usuario: rows[0] });
        } catch (err) {
            return res.status(500).json({ erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async selecionarContexto(req, res) {
        try {
            const { id_unidade, id_local_operacional, id_perfil } = req.body;
            const id_sessao = req.user?.id_sessao_usuario;
            const id_usuario = req.user?.id_usuario;
            
            if (!id_usuario || !id_sessao) {
                return res.status(401).json({ sucesso: false, erro: "USUARIO_NAO_AUTENTICADO" });
            }
            
            // id_unidade é obrigatório, id_local_operacional pode ser null ou 0 (sem sala)
            if (!id_unidade) {
                return res.status(400).json({ sucesso: false, erro: "ID_UNIDADE_OBRIGATORIO" });
            }
            
            // Normalizar id_local_operacional: 0, null, undefined = sem sala
            const localOp = (id_local_operacional === undefined || id_local_operacional === null || id_local_operacional === 0) ? null : id_local_operacional;
            
            // Usar a sp_master_login com ação CONTEXTO_SET
            const conn = await pool.getConnection();
            try {
                const payload = {
                    id_sessao: id_sessao,
                    id_unidade: id_unidade,
                    id_local: localOp,  // pode ser NULL = sem sala
                    id_perfil: id_perfil || 42
                };
                
                const spResult = await callMasterLogin(conn, 'CONTEXTO_SET', payload);
                
                if (spResult.sucesso) {
                    // Atualizar o JWT token com o novo contexto
                    const jwtToken = jwt.sign({ 
                        id_usuario: id_usuario, 
                        id_sessao_usuario: id_sessao,
                        login: req.user?.login,
                        id_unidade: id_unidade, 
                        id_local_operacional: localOp, 
                        id_perfil: id_perfil || 42
                    }, SECRET, { expiresIn: EXPIRES_IN });
                    
                    return res.json({ 
                        sucesso: true, 
                        contexto_definido: true,
                        id_unidade: id_unidade,
                        id_local: localOp,
                        id_perfil: id_perfil,
                        token: jwtToken,  // 🔥 Novo token com contexto
                        mensagem: 'CONTEXTO_DEFINIDO'
                    });
                } else {
                    return res.json({ 
                        sucesso: false, 
                        erro: spResult.mensagem || 'ERRO_AO_DEFINIR_CONTEXTO'
                    });
                }
            } finally {
                conn.release();
            }
        } catch (err) {
            console.error('Erro ao selecionar contexto:', err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        }
    }

    static async contextoAtual(req, res) {
        return res.json({ sucesso: true, contexto: req.contexto });
    }

    static async sync(req, res) {
        return res.json({ sucesso: true, sincronizado: true });
    }

    // ============================================================
    // NOVAS FUNÇÕES USANDO SP MASTER (executeSPMaster)
    // ============================================================

    /**
     * Login via SP Master
     */
    static async loginSP(req, res) {
        const { usuario, senha } = req.body;
        const idSessao = req.user?.id_sessao_usuario || null;

        try {
            const resultado = await executeSPMaster("POST", "AUTH.LOGIN", idSessao, { usuario, senha });

            if (!resultado.sucesso) {
                return res.status(401).json({ error: resultado.mensagem || "Credenciais inválidas" });
            }

            return res.json({ 
                sucesso: true, 
                token: resultado.resultado?.token, 
                usuario: resultado.resultado?.usuario 
            });
        } catch (err) {
            console.error("Erro loginSP:", err);
            return res.status(500).json({ error: "ERRO_INTERNO" });
        }
    }

    /**
     * Buscar meus contextos via SP Master
     */
    static async meusContextosSP(req, res) {
        const idSessao = req.user?.id_sessao_usuario || null;

        try {
            const resultado = await executeSPMaster("GET", "AUTH.MEUS_CONTEXTOS", idSessao);

            if (!resultado.sucesso) {
                return res.status(500).json({ error: resultado.mensagem || "ERRO_INTERNO" });
            }

            return res.json(resultado.resultado);
        } catch (err) {
            console.error("Erro meusContextosSP:", err);
            return res.status(500).json({ error: "ERRO_INTERNO" });
        }
    }
}

module.exports = AuthController;
