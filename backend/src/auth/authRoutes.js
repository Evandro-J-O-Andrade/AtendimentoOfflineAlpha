const express = require("express");
const AuthController = require("./authController");
const authMiddleware = require("./authMiddleware");
const { runtimeContextMiddleware } = require("./runtimeContextMiddleware");

const router = express.Router();

// ============================
// ROTAS PÚBLICAS
// ============================

// Login padrão
router.post("/login", AuthController.login);

// Listar contextos disponíveis (para tela de seleção)
router.get("/contextos", AuthController.listarContextos);

// ============================
// ROTAS AUTENTICADAS
// ============================

// Usuário atual
router.get("/me", authMiddleware, AuthController.me);

// Meus contextos disponíveis
router.get("/meus-contextos", authMiddleware, AuthController.meusContextos);

// Selecionar contexto (quando há múltiplas escolhas)
router.post("/selecionar-contexto", authMiddleware, AuthController.selecionarContexto);

// Logout
router.post("/logout", authMiddleware, AuthController.logout);

// Contexto atual (com runtime completo)
router.get("/contexto-atual", authMiddleware, runtimeContextMiddleware, AuthController.contextoAtual);

// Runtime para sincronização (offline/online)
router.get("/runtime", authMiddleware, runtimeContextMiddleware, AuthController.contextoAtual);

// Sync - sincronização automática de runtime
router.post("/sync", authMiddleware, AuthController.sync);

module.exports = router;
