const AuthService = require("./authService");

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

            const payload = { login, senha, id_cidade, id_unidade, id_sistema, id_local_operacional };
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
            // always log the full error so you can inspect it in the backend console
            console.error("Login error:", err);
            console.error("Error message:", err.message);
            console.error("Error stack:", err.stack);

            // if the service threw with a known message, mirror it
            if (err.message) {
                // some messages are from mysql procedure (e.g. USUARIO_INATIVO)
                // we return them along with a 500 code so the front-end can display them
                return res.status(500).json({ error: err.message });
            }

            // fallback generic message
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

}

module.exports = AuthController;