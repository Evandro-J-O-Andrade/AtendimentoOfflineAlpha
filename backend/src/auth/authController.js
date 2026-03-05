const AuthService = require("./authService");
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
                id_local_operacional
            } = req.body;

            if (!login || !senha) {
                return res.status(400).json({
                    error: "LOGIN_E_SENHA_OBRIGATORIOS"
                });
            }

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

            if (err.message) {
                return res.status(500).json({ error: err.message });
            }

            return res.status(500).json({
                error: process.env.NODE_ENV === 'development' ? err.toString() : "ERRO_INTERNO"
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

}

module.exports = AuthController;
