// ========================================================
// Auth Routes
// ========================================================
import express from 'express';
import { login, logout, refreshToken, getMe } from '../controllers/auth.controller.js';
import { authMiddleware } from '../middleware/auth.js';

const router = express.Router();

/**
 * POST /api/auth/login
 * Login com email e senha
 * Body: { email, senha }
 */
router.post('/login', login);

/**
 * POST /api/auth/logout
 * Logout do usuário (requer autenticação)
 */
router.post('/logout', authMiddleware, logout);

/**
 * POST /api/auth/refresh
 * Renovar access token usando refresh token
 * Body: { refreshToken }
 */
router.post('/refresh', refreshToken);

/**
 * GET /api/auth/me
 * Obter dados do usuário logado (requer autenticação)
 */
router.get('/me', authMiddleware, getMe);

export default router;
