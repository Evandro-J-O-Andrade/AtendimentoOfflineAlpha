const jwt = require("jsonwebtoken");

const SECRET = process.env.JWT_SECRET || "runtime_secret_dev";

class AuthService {

    static async login(username, password) {

        // TODO: substituir por consulta real ao banco
        if (username !== "admin" || password !== "admin") {
            throw new Error("Credenciais inválidas");
        }

        const token = jwt.sign(
            {
                user: username,
                role: "OPERATOR_RUNTIME"
            },
            SECRET,
            { expiresIn: "8h" }
        );

        return { token };
    }

}

module.exports = AuthService;