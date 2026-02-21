// ========================================================
// Context Routes - Gerenciamento de Contexto (Unidade/Local)
// ========================================================
import { Router } from 'express';
import { authMiddleware } from '../middleware/auth.js';
import {
  listarUnidades,
  listarLocaisPorUnidade,
  selecionarContexto
} from '../controllers/context.controller.js';

const router = Router();

// Rotas protegidas por autenticação
router.get('/unidades', authMiddleware, listarUnidades);
router.get('/locais/:id_unidade', authMiddleware, listarLocaisPorUnidade);
router.post('/selecionar', authMiddleware, selecionarContexto);

export default router;
