const express = require("express");
const AuthController = require("./authController");
const authMiddleware = require("./authMiddleware");
const { runtimeContextMiddleware } = require("./runtimeContextMiddleware");

const router = express.Router();

// ============================
// ROTAS PÚBLICAS
// ============================

// Checar existência de usuário
router.post("/checkUser", AuthController.checkUser);

// Login padrão
router.post("/login", AuthController.login);

// Refresh token
router.post("/refresh", AuthController.refreshToken);

// ============================
// ROTAS AUTENTICADAS
// ============================

// Listar contextos disponíveis (para tela de seleção)
router.get("/contextos", authMiddleware, AuthController.listarContextos);

// ============================
// ROTAS AUTENTICADAS
// ============================

// Menu do usuário (baseado em permissões)
router.get("/menu", authMiddleware, AuthController.getMenu);

// Permissões por perfil
router.get("/permissoes/:idPerfil", authMiddleware, AuthController.permissoesPorPerfil);

// Usuário atual
router.get("/me", authMiddleware, AuthController.me);

// Meus contextos disponíveis (via SP Master)
router.get("/meus-contextos", authMiddleware, AuthController.meusContextosSP);

// Selecionar contexto (quando há múltiplas escolhas)
router.post("/selecionar-contexto", authMiddleware, AuthController.selecionarContexto);

// Refresh token
router.post("/refresh", AuthController.refreshToken);

// Logout
router.post("/logout", authMiddleware, AuthController.logout);

// Contexto atual (com runtime completo)
router.get("/contexto-atual", authMiddleware, runtimeContextMiddleware, AuthController.contextoAtual);

// Runtime para sincronização (offline/online)
router.get("/runtime", authMiddleware, runtimeContextMiddleware, AuthController.contextoAtual);

// Sync - sincronização automática de runtime
router.post("/sync", authMiddleware, AuthController.sync);

module.exports = router;
