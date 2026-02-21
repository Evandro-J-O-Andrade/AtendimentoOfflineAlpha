// ========================================================
// Entry Point - Pronto Atendimento Backend
// ========================================================
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { authMiddleware, errorMiddleware } from './middleware/auth.js';
import authRoutes from './routes/auth.routes.js';
import contextRoutes from './routes/context.routes.js';
import farmaciaRoutes from './routes/farmacia.routes.js';
import estoqueRoutes from './routes/estoque.routes.js';

// Inicializar variáveis de ambiente
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ========================================================
// MIDDLEWARES GLOBAIS
// ========================================================

// CORS
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  credentials: process.env.CORS_CREDENTIALS !== 'false',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Body parser
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// Request logging simples
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
  });
  next();
});

// ========================================================
// ROTAS PÚBLICAS (sem autenticação)
// ========================================================
app.use('/api/auth', authRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ========================================================
// ROTAS PROTEGIDAS (com autenticação JWT)
// ========================================================
app.use('/api/context', authMiddleware, contextRoutes);
app.use('/api/farmacia', authMiddleware, farmaciaRoutes);
app.use('/api/estoque', authMiddleware, estoqueRoutes);

// Rota 404
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Rota não encontrada',
    path: req.path
  });
});

// ========================================================
// MIDDLEWARE DE ERRO (deve ser último)
// ========================================================
app.use(errorMiddleware);

// ========================================================
// INICIAR SERVIDOR
// ========================================================
app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════┐
║     🏥 PRONTO ATENDIMENTO - Backend                    ║
║     Servidor rodando em http://localhost:${PORT}       ║
║     Ambiente: ${process.env.NODE_ENV || 'development'}              ║
╚════════════════════════════════════════════════════════┘
  `);
});

// ========================================================
// TRATAMENTO DE ERROS NÃO CAPTURADOS
// ========================================================
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  process.exit(1);
});

export default app;
