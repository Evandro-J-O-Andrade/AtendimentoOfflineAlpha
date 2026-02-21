// ========================================================
// JWT Authentication Middleware
// ========================================================
import { verifyAccessToken, extractTokenFromHeader } from '../config/jwt.js';

/**
 * Middleware para validar JWT
 * Coloca usuario e sessao no req.user
 */
export function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    const token = extractTokenFromHeader(authHeader);

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Token de autenticação não fornecido',
        code: 'NO_TOKEN'
      });
    }

    const decoded = verifyAccessToken(token);
    req.user = decoded; // { id_usuario, id_sessao_usuario, nome, perfil, ... }
    req.token = token;
    next();
  } catch (error) {
    // Token expirado
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Token expirado',
        code: 'TOKEN_EXPIRED'
      });
    }
    // Token inválido
    return res.status(403).json({
      success: false,
      error: 'Token inválido ou malformado',
      code: 'INVALID_TOKEN'
    });
  }
}

/**
 * Middleware para verificar perfil de usuário
 * Uso: requireRole(['admin', 'medico'])
 */
export function requireRole(allowedRoles = []) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'Usuário não autenticado'
      });
    }

    const userRole = req.user.perfil; // ou id_perfil
    if (!allowedRoles.includes(userRole)) {
      return res.status(403).json({
        success: false,
        error: `Acesso negado. Apenas ${allowedRoles.join(',')} podem acessar`
      });
    }

    next();
  };
}

/**
 * Middleware para tratar erros globalmente
 */
export function errorMiddleware(err, req, res, next) {
  console.error('Erro não tratado:', {
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  });

  // Erros MySQL
  if (err.code && err.sqlState) {
    return res.status(400).json({
      success: false,
      error: 'Erro ao processar requisição no banco',
      code: err.code,
      message: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  // Erro genérico
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    error: err.message || 'Erro interno do servidor',
    code: err.code || 'INTERNAL_ERROR'
  });
}
