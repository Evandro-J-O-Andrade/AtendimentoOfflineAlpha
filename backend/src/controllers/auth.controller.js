// ========================================================
// Auth Controller - Lógica de Autenticação
// ========================================================
import bcryptjs from 'bcryptjs';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from '../config/jwt.js';
import { executeQuery, callProcedure } from '../config/mysql.js';
import { v4 as uuidv4 } from 'uuid';

/**
 * POST /api/auth/login
 * Body: { email, senha }
 * Retorna: { success, accessToken, refreshToken, usuario }
 */
export async function login(req, res, next) {
  try {
    const { email, senha } = req.body;

    // Validação
    if (!email || !senha) {
      return res.status(400).json({
        success: false,
        error: 'Email e senha são obrigatórios'
      });
    }

    // Busca usuário
    const usuarios = await executeQuery(
      'SELECT id_usuario, nome, email, senha_hash, id_perfil, ativo FROM usuario WHERE email = ? AND ativo = 1',
      [email]
    );

    if (usuarios.length === 0) {
      return res.status(401).json({
        success: false,
        error: 'Email ou senha inválidos'
      });
    }

    const usuario = usuarios[0];

    // Verifica senha
    const senhaValida = await bcryptjs.compare(senha, usuario.senha_hash);
    if (!senhaValida) {
      return res.status(401).json({
        success: false,
        error: 'Email ou senha inválidos'
      });
    }

    // Busca perfil
    const perfis = await executeQuery(
      'SELECT nome FROM perfil WHERE id_perfil = ?',
      [usuario.id_perfil]
    );
    const perfilNome = perfis[0]?.nome || 'usuario';

    // Cria sessão via procedure
    const sessionUUID = uuidv4();
    try {
      await callProcedure('sp_sessao_abrir', [
        usuario.id_usuario,
        null, // id_sistema (opcional)
        null, // id_unidade (opcional)
        null, // id_local_operacional (opcional)
        usuario.id_perfil,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'unknown'
      ]);
    } catch (err) {
      console.warn('Aviso: Procedure sp_sessao_abrir não disponível, continuando...');
      // Continua mesmo se procedure falhar (para debug)
    }

    // Gera tokens JWT
    const payload = {
      id_usuario: usuario.id_usuario,
      email: usuario.email,
      nome: usuario.nome,
      perfil: perfilNome,
      id_perfil: usuario.id_perfil,
      session_uuid: sessionUUID,
      iat: Math.floor(Date.now() / 1000)
    };

    const accessToken = generateAccessToken(payload);
    const refreshToken = generateRefreshToken(payload);

    // Retorna resposta
    return res.json({
      success: true,
      accessToken,
      refreshToken,
      usuario: {
        id_usuario: usuario.id_usuario,
        nome: usuario.nome,
        email: usuario.email,
        perfil: perfilNome,
        id_perfil: usuario.id_perfil
      }
    });
  } catch (error) {
    console.error('Erro ao fazer login:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao processar login'
    });
  }
}

/**
 * POST /api/auth/logout
 * Fecha a sessão do usuário
 */
export async function logout(req, res, next) {
  try {
    const usuarioId = req.user?.id_usuario;
    if (!usuarioId) {
      return res.status(400).json({
        success: false,
        error: 'Usuário não identificado'
      });
    }

    // Fecha sessão via procedure (se existir)
    try {
      await callProcedure('sp_sessao_fechar', [usuarioId]);
    } catch (err) {
      console.warn('Procedure sp_sessao_fechar não disponível');
    }

    return res.json({
      success: true,
      message: 'Logout realizado com sucesso'
    });
  } catch (error) {
    console.error('Erro ao fazer logout:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao processar logout'
    });
  }
}

/**
 * POST /api/auth/refresh
 * Body: { refreshToken }
 * Retorna novo accessToken
 */
export async function refreshToken(req, res, next) {
  try {
    const { refreshToken: token } = req.body;

    if (!token) {
      return res.status(400).json({
        success: false,
        error: 'Refresh token é obrigatório'
      });
    }

    // Verifica refresh token
    const decoded = verifyRefreshToken(token);

    // Gera novo access token
    const payload = {
      id_usuario: decoded.id_usuario,
      email: decoded.email,
      nome: decoded.nome,
      perfil: decoded.perfil,
      id_perfil: decoded.id_perfil,
      session_uuid: decoded.session_uuid,
      iat: Math.floor(Date.now() / 1000)
    };

    const newAccessToken = generateAccessToken(payload);

    return res.json({
      success: true,
      accessToken: newAccessToken
    });
  } catch (error) {
    console.error('Erro ao fazer refresh de token:', error);
    return res.status(401).json({
      success: false,
      error: 'Refresh token inválido ou expirado'
    });
  }
}

/**
 * GET /api/auth/me
 * Retorna dados do usuário logado (requer autenticação)
 */
export async function getMe(req, res, next) {
  try {
    const usuario = req.user?.id_usuario;
    
    if (!usuario) {
      return res.status(401).json({
        success: false,
        error: 'Usuário não autenticado'
      });
    }

    // Busca dados atualizados do usuário
    const usuarios = await executeQuery(
      'SELECT id_usuario, nome, email, id_perfil, ativo FROM usuario WHERE id_usuario = ?',
      [usuario]
    );

    if (usuarios.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Usuário não encontrado'
      });
    }

    const user = usuarios[0];

    // Busca perfil
    const perfis = await executeQuery(
      'SELECT nome FROM perfil WHERE id_perfil = ?',
      [user.id_perfil]
    );

    return res.json({
      success: true,
      usuario: {
        id_usuario: user.id_usuario,
        nome: user.nome,
        email: user.email,
        perfil: perfis[0]?.nome || 'usuario',
        id_perfil: user.id_perfil,
        ativo: user.ativo === 1
      }
    });
  } catch (error) {
    console.error('Erro ao buscar dados do usuário:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar dados do usuário'
    });
  }
}
