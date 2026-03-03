const jwt = require("jsonwebtoken");
const { SECRET } = require("../config/jwt");

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