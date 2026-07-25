import { getDatabasePool } from '@backend/database/mysql/connection'

/**
 * Service responsável pela gestão de eventos do sistema.
 */
export class EventService {
  private connection = getDatabasePool()

  /**
   * Registra um novo evento no sistema.
   * @param idSessao - Identificador da sessão.
   * @param modulo - Nome do módulo onde o evento ocorreu.
   * @param acao - Ação executada.
   * @param payload - Dados adicionais do evento.
   * @param origem - Origem do evento (default: 'API').
   * @returns Resultado da operação com sucesso e mensagem.
   */
  async registrar(idSessao: number, modulo: string, acao: string, payload: any, origem = 'API') {
    const conn = await this.connection
    await conn.query('SET @resultado = NULL, @sucesso = NULL, @mensagem = NULL')
    await conn.query(
      'CALL sp_evento_registrar(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)',
      [idSessao, modulo, acao, JSON.stringify(payload), origem]
    )
    const [outRows] = await conn.query(
      'SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem'
    )
    return (outRows as any[])[0]
  }

  /**
   * Lista eventos com filtros opcionais.
   * @param idSessao - Identificador da sessão.
   * @param filtros - Filtros opcionais para a listagem.
   * @param filtros.modulo - Módulo para filtrar.
   * @param filtros.acao - Ação para filtrar.
   * @param filtros.id_entidade - ID da entidade para filtrar.
   * @param filtros.data_inicio - Data inicial do filtro (formato string).
   * @param filtros.data_fim - Data final do filtro (formato string).
   * @returns Lista de eventos.
   */
  async listar(
    idSessao: number,
    filtros?: {
      modulo?: string
      acao?: string
      id_entidade?: number
      data_inicio?: string
      data_fim?: string
    }
  ) {
    const conn = await this.connection
    await conn.query('SET @resultado = NULL, @sucesso = NULL, @mensagem = NULL')
    await conn.query(
      'CALL sp_evento_listar(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)',
      [
        idSessao,
        filtros?.modulo ?? null,
        filtros?.acao ?? null,
        filtros?.id_entidade ?? null,
        filtros?.data_inicio ?? null,
        filtros?.data_fim ?? null
      ]
    )
    const [outRows] = await conn.query(
      'SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem'
    )
    const out = (outRows as any[])[0]
    if (!out || !out.sucesso) {
      return []
    }
    const raw = out.resultado
    return typeof raw === 'string' ? JSON.parse(raw) : raw
  }

  /**
   * Obtém eventos recentes via stream.
   * @param idSessao - Identificador da sessão.
   * @param ultimoEventoUuid - UUID do último evento conhecido (para paginação).
   * @returns Lista de eventos recentes.
   */
  async stream(idSessao: number, ultimoEventoUuid?: string) {
    const conn = await this.connection
    const [rows] = await conn.query('CALL sp_evento_stream(?, ?)', [idSessao, ultimoEventoUuid ?? null])
    const raw = (rows as any[])[0]
    const eventos = typeof raw === 'string' ? JSON.parse(raw) : raw
    return Array.isArray(eventos) ? eventos : []
  }
}

export const eventService = new EventService()
