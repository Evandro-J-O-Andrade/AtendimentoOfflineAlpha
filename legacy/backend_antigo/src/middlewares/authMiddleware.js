const jwt = require("jsonwebtoken");
const { SECRET } = require("../config/jwt");

const verifyToken = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader) return res.status(401).json({ error: "TOKEN_NAO_FORNECIDO" });

  const token = authHeader.split(" ")[1];
  try {
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded; // adiciona id_usuario, id_sessao, contexto etc.
    next();
  } catch (err) {
    res.status(401).json({ error: "TOKEN_INVALIDO" });
  }
};

module.exports = { verifyToken };
