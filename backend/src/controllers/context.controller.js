// ========================================================
// Context Controller - Listar Unidades e Locais Disponíveis
// ========================================================
import { executeQuery } from '../config/mysql.js';

/**
 * GET /api/context/unidades
 * Retorna lista de unidades disponíveis para o usuário
 */
export async function listarUnidades(req, res, next) {
  try {
    const unidades = await executeQuery(
      `SELECT 
        u.id_unidade,
        u.nome,
        u.tipo,
        u.cnes,
        u.ativo
      FROM unidade u
      WHERE u.ativo = 1
      ORDER BY u.nome ASC`,
      []
    );

    return res.json({
      success: true,
      data: unidades
    });
  } catch (error) {
    console.error('Erro ao listar unidades:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar unidades'
    });
  }
}

/**
 * GET /api/context/locais/:id_unidade
 * Retorna lista de locais operacionais de uma unidade
 */
export async function listarLocaisPorUnidade(req, res, next) {
  try {
    const { id_unidade } = req.params;

    if (!id_unidade) {
      return res.status(400).json({
        success: false,
        error: 'id_unidade é obrigatório'
      });
    }

    const locais = await executeQuery(
      `SELECT 
        lo.id_local_operacional,
        lo.codigo,
        lo.nome,
        lo.tipo,
        lo.sala,
        lo.ativo
      FROM local_operacional lo
      WHERE lo.id_unidade = ? 
        AND lo.ativo = 1
      ORDER BY lo.tipo ASC, lo.codigo ASC`,
      [id_unidade]
    );

    return res.json({
      success: true,
      data: locais
    });
  } catch (error) {
    console.error('Erro ao listar locais:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar locais'
    });
  }
}

/**
 * POST /api/context/selecionar
 * Seleciona a unidade e local operacional (cria/atualiza contexto na sessão)
 * Body: { id_unidade, id_local_operacional }
 * Retorna: { success, id_sessao_usuario, contexto }
 */
export async function selecionarContexto(req, res, next) {
  try {
    const usuarioId = req.user?.id_usuario;
    const { id_unidade, id_local_operacional } = req.body;

    if (!usuarioId) {
      return res.status(401).json({
        success: false,
        error: 'Usuário não autenticado'
      });
    }

    if (!id_unidade || !id_local_operacional) {
      return res.status(400).json({
        success: false,
        error: 'id_unidade e id_local_operacional são obrigatórios'
      });
    }

    // Valida se unidade existe
    const unidades = await executeQuery(
      'SELECT id_unidade FROM unidade WHERE id_unidade = ? AND ativo = 1',
      [id_unidade]
    );

    if (unidades.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Unidade não existe ou está inativa'
      });
    }

    // Valida se local existe na unidade
    const locais = await executeQuery(
      'SELECT id_local_operacional FROM local_operacional WHERE id_local_operacional = ? AND id_unidade = ? AND ativo = 1',
      [id_local_operacional, id_unidade]
    );

    if (locais.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Local operacional não existe ou está inativo'
      });
    }

    // Busca dados da unidade e local para retornar
    const unidadeData = await executeQuery(
      'SELECT id_unidade, nome, tipo FROM unidade WHERE id_unidade = ?',
      [id_unidade]
    );

    const localData = await executeQuery(
      'SELECT id_local_operacional, codigo, nome, tipo, sala FROM local_operacional WHERE id_local_operacional = ?',
      [id_local_operacional]
    );

    return res.json({
      success: true,
      contexto: {
        id_unidade: unidadeData[0]?.id_unidade,
        unidade_nome: unidadeData[0]?.nome,
        unidade_tipo: unidadeData[0]?.tipo,
        id_local_operacional: localData[0]?.id_local_operacional,
        local_codigo: localData[0]?.codigo,
        local_nome: localData[0]?.nome,
        local_tipo: localData[0]?.tipo,
        local_sala: localData[0]?.sala
      }
    });
  } catch (error) {
    console.error('Erro ao selecionar contexto:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao selecionar contexto'
    });
  }
}
