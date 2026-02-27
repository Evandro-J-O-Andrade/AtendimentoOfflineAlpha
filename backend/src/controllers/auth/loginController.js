const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

/*
=====================================
Login Runtime Assistencial
=====================================
*/

module.exports = async (req, res) => {

    try {

        const { usuario, senha } = req.body;

        const db = req.app.locals.db;

        const [rows] = await db.execute(
            "SELECT * FROM usuario WHERE login = ? AND ativo = 1",
            [usuario]
        );

        if (!rows.length) {
            return res.status(401).json({
                erro: "Credenciais inválidas"
            });
        }

        const user = rows[0];

        const senhaOk = await bcrypt.compare(senha, user.senha_hash);

        if (!senhaOk) {
            return res.status(401).json({
                erro: "Credenciais inválidas"
            });
        }

        const token = jwt.sign(
            {
                id_usuario: user.id_usuario,
                id_sistema: user.id_sistema,
                perfil: user.id_perfil
            },
            process.env.JWT_SECRET || "runtime_assistencial_chave",
            { expiresIn: "8h" }
        );

        return res.json({
            sucesso: true,
            token
        });

    } catch (error) {
        return res.status(500).json({
            erro: "Erro interno no login"
        });
    }
};