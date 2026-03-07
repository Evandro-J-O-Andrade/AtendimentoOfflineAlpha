const AuthService = require("./authService");
const LoginContextService = require("./loginContextService");
const pool = require("../config/database");

class AuthController {

    static async login(req, res) {
        try {

            const {
                login,
                senha,
                id_cidade,
                id_unidade,
                id_sistema,
                id_local_operacional,
                id_dispositivo,
                token_dispositivo,
                usar_novo_contexto // Flag para usar o novo serviço
            } = req.body;

            if (!login || !senha) {
                return res.status(400).json({
                    error: "LOGIN_E_SENHA_OBRIGATORIOS"
                });
            }

            // Usar o novo LoginContextService se solicitado
            if (usar_novo_contexto) {
                const payload = {
                    login,
                    senha,
                    id_unidade,
                    id_local_operacional,
                    id_dispositivo,
                    token_dispositivo,
                    ip_acesso: req.ip || null,
                    user_agent: req.get("user-agent") || null
                };

                const result = await LoginContextService.login(payload);

                if (!result) {
                    return res.status(401).json({
                        error: "CREDENCIAIS_INVALIDAS"
                    });
                }

                if (result.error) {
                    const statusCode = result.error === "DISPOSITIVO_INVALIDO" ? 403 : 401;
                    return res.status(statusCode).json({
                        error: result.error
                    });
                }

                // Se há múltiplas escolhas de contexto, retornar para o frontend
                if (result.choices) {
                    return res.status(200).json({
                        choices: result.choices,
                        message: "SELECIONE_CONTEXTO"
                    });
                }

                return res.json(result);
            }

            // Comportamento padrão - usar AuthService original
            const payload = { login, senha };
            if (id_cidade) payload.id_cidade = id_cidade;
            if (id_unidade) payload.id_unidade = id_unidade;
            if (id_sistema) payload.id_sistema = id_sistema;
            if (id_local_operacional) payload.id_local_operacional = id_local_operacional;
            payload.ip_acesso = req.ip || null;
            payload.user_agent = req.get("user-agent") || null;
            const result = await AuthService.login(payload);

            if (!result) {
                return res.status(401).json({
                    error: "CREDENCIAIS_INVALIDAS"
                });
            }

            if (result.error) {
                return res.status(403).json({
                    error: result.error
                });
            }

            return res.json(result);

        } catch (err) {
            console.error("Login error:", err);
            console.error("Error message:", err.message);
            console.error("Error stack:", err.stack);

            // Mensagens de erro amigáveis para o usuário
            let errorCode = "ERRO_INTERNO";
            let errorMessage = "Erro interno no servidor";
            
            // Verifica se é erro da procedure SQL (SIGNAL SQLSTATE)
            const errMsg = err.message || "";
            
            // Erros conhecidos da procedure sp_auth_login
            if (errMsg.includes("USUARIO_NAO_ENCONTRADO")) {
                errorCode = "USUARIO_NAO_ENCONTRADO";
                errorMessage = "Usuário não encontrado";
            } else if (errMsg.includes("USUARIO_BLOQUEADO")) {
                errorCode = "USUARIO_BLOQUEADO";
                errorMessage = "Usuário bloqueado temporariamente";
            } else if (errMsg.includes("SEM_CONTEXTO")) {
                errorCode = "SEM_CONTEXTO";
                errorMessage = "Usuário sem contexto operacional definido";
            } else if (errMsg.includes("senha_incorreta") || errMsg.includes("SENHA_INCORRETA")) {
                errorCode = "SENHA_INCORRETA";
                errorMessage = "Senha incorreta";
            } else if (errMsg.includes("ERRO_AO_CRIAR_SESSAO") || errMsg.includes("sessao")) {
                errorCode = "ERRO_SESSAO";
                errorMessage = "Erro ao criar sessão de usuário";
            } else if (errMsg.includes("usuario") || errMsg.includes("USUARIO")) {
                // Erros genéricos relacionados ao usuário
                errorCode = "ERRO_USUARIO";
                errorMessage = "Erro relacionado ao usuário";
            } else {
                // Para erros desconhecidos, inclui detalhe em ambiente de dev
                const isDev = process.env.NODE_ENV !== 'production';
                errorCode = "ERRO_INTERNO";
                errorMessage = isDev ? `Erro: ${errMsg}` : "Erro ao processar login";
            }

            return res.status(500).json({ 
                error: errorCode,
                mensagem: errorMessage,
                // Em dev, incluir detalhes do erro para debug
                ...(process.env.NODE_ENV !== 'production' && { debug: errMsg })
            });
        }
    }

    static async me(req, res) {
        return res.json({
            user: req.user
        });
    }

    /**
     * Retorna os nomes dos contextos para exibir na tela de seleção
     */
    static async listarContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();

            // Buscar sistemas
            const [sistemas] = await conn.query(
                "SELECT id_sistema, nome, sigla FROM sistema WHERE ativo = 1"
            );
            const sistemasMap = {};
            sistemas.forEach(s => {
                sistemasMap[s.id_sistema] = s.sigla || s.nome;
            });

            // Buscar unidades
            const [unidades] = await conn.query(
                "SELECT id_unidade, nome FROM unidade WHERE ativo = 1"
            );
            const unidadesMap = {};
            unidades.forEach(u => {
                unidadesMap[u.id_unidade] = u.nome;
            });

            // Buscar locais operacionais
            const [locais] = await conn.query(
                "SELECT id_local_operacional, nome, tipo FROM local_operacional WHERE ativo = 1"
            );
            const locaisMap = {};
            locais.forEach(l => {
                locaisMap[l.id_local_operacional] = l.nome;
            });

            // Buscar perfis
            const [perfis] = await conn.query(
                "SELECT id_perfil, nome FROM perfil WHERE ativo = 1"
            );
            const perfisMap = {};
            perfis.forEach(p => {
                perfisMap[p.id_perfil] = p.nome;
            });

            return res.json({
                sistemas: sistemasMap,
                unidades: unidadesMap,
                locais: locaisMap,
                perfis: perfisMap
            });

        } catch (err) {
            console.error("Erro ao listar contextos:", err);
            return res.status(500).json({
                error: "ERRO_AO_LISTAR_CONTEXTOS"
            });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Lista os contextos disponíveis para o usuário logado
     */
    static async meusContextos(req, res) {
        let conn;
        try {
            conn = await pool.getConnection();
            const id_usuario = req.user.id_usuario;

            const [contextos] = await conn.query(
                `SELECT 
                    uc.id_unidade,
                    uc.id_sistema,
                    uc.id_local_operacional,
                    uc.id_perfil,
                    s.nome as sistema_nome,
                    s.sigla as sistema_sigla,
                    u.nome as unidade_nome,
                    lo.nome as local_nome,
                    lo.tipo as local_tipo,
                    p.nome as perfil_nome
                FROM usuario_contexto uc
                LEFT JOIN sistema s ON s.id_sistema = uc.id_sistema
                LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                LEFT JOIN perfil p ON p.id_perfil = uc.id_perfil
                WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                [id_usuario]
            );

            return res.json({ contextos });

        } catch (err) {
            console.error("Erro ao buscar contextos:", err);
            return res.status(500).json({
                error: "ERRO_AO_BUSCAR_CONTEXTOS"
            });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Seleciona um contexto específico (quando há múltiplas escolhas)
     */
    static async selecionarContexto(req, res) {
        try {
            const {
                id_unidade,
                id_local_operacional,
                id_perfil
            } = req.body;

            if (!id_unidade || !id_local_operacional || !id_perfil) {
                return res.status(400).json({
                    error: "CONTEXTO_INCOMPLETO"
                });
            }

            const payload = {
                id_usuario: req.user.id_usuario,
                id_sessao_usuario: req.user.id_sessao_usuario,
                id_unidade,
                id_local_operacional,
                id_perfil
            };

            const result = await LoginContextService.selecionarContexto(payload);

            if (result.error) {
                return res.status(400).json({ error: result.error });
            }

            return res.json(result);

        } catch (err) {
            console.error("Erro ao selecionar contexto:", err);
            return res.status(500).json({
                error: "ERRO_AO_SELECIONAR_CONTEXTO"
            });
        }
    }

    /**
     * Logout - encerra a sessão atual
     */
    static async logout(req, res) {
        try {
            const id_sessao_usuario = req.user.id_sessao_usuario;
            
            const result = await LoginContextService.logout(id_sessao_usuario);
            
            return res.json(result);

        } catch (err) {
            console.error("Erro ao fazer logout:", err);
            return res.status(500).json({
                error: "ERRO_AO_FAZER_LOGOUT"
            });
        }
    }

    /**
     * Retorna o contexto atual do usuário
     */
    static async contextoAtual(req, res) {
        try {
            // O middleware já carregou o contexto em req.runtime
            if (!req.runtime) {
                return res.status(401).json({ error: "SEM_AUTENTICACAO" });
            }

            return res.json({
                usuario: req.runtime.usuario,
                sessao: req.runtime.sessao,
                contexto: {
                    unidade: req.runtime.contexto.unidade,
                    local: req.runtime.contexto.local,
                    dispositivo: req.runtime.contexto.dispositivo
                },
                perfil: req.runtime.perfil
            });

        } catch (err) {
            console.error("Erro ao buscar contexto atual:", err);
            return res.status(500).json({
                error: "ERRO_AO_BUSCAR_CONTEXTO"
            });
        }
    }

}

module.exports = AuthController;
