const express = require("express");
const AuthController = require("./authController");
const authMiddleware = require("./authMiddleware");

const router = express.Router();

// Rotas públicas
router.post("/login", AuthController.login);
router.get("/contextos", AuthController.listarContextos);

// Rotas autenticadas
router.get("/me", authMiddleware, AuthController.me);
router.get("/meus-contextos", authMiddleware, AuthController.meusContextos);

module.exports = router;
