const jwt = require("jsonwebtoken");

const SECRET = process.env.JWT_SECRET || "runtime_secret_dev";

function authMiddleware(req, res, next) {

    try {

        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(401).json({ error: "NO_TOKEN" });
        }

        const token = authHeader.split(" ")[1];

        req.session_runtime = jwt.verify(token, SECRET);

        next();

    } catch {
        return res.status(401).json({ error: "INVALID_TOKEN" });
    }
}

module.exports = authMiddleware;