const jwt = require("jsonwebtoken");

const SECRET = process.env.JWT_SECRET || "runtime_secret_dev";

class SessionGuard {

    static validarToken(token) {
        try {
            return jwt.verify(token, SECRET);
        } catch {
            return null;
        }
    }

}

module.exports = SessionGuard;