import type { Request, Response } from 'express'
import { eventService } from './EventService'

/**
 * Controller responsável pelo gerenciamento de eventos.
 */
export class EventController {
  /**
   * Registra um novo evento.
   * @param req - Requisição HTTP.
   * @param res - Resposta HTTP.
   */
  async registrar(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao ?? req.body.idSessao ?? 0)
      const { modulo, acao, payload, origem } = req.body ?? {}

      if (!idSessao || !modulo || !acao) {
        return res.status(400).json({ message: 'PARAMETROS_OBRIGATORIOS' })
      }

      const resultado = await eventService.registrar(idSessao, modulo, acao, payload, origem)
      return res.json(resultado)
    } catch (error) {
      console.error('EVENTO_REGISTRAR_ERROR', error)
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  /**
   * Lista eventos com filtros opcionais.
   * @param req - Requisição HTTP.
   * @param res - Resposta HTTP.
   */
  async listar(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const { modulo, acao, id_entidade, data_inicio, data_fim } = req.query

      const filtros: any = {}
      if (modulo) filtros.modulo = String(modulo)
      if (acao) filtros.acao = String(acao)
      if (id_entidade) filtros.id_entidade = Number(id_entidade)
      if (data_inicio) filtros.data_inicio = String(data_inicio)
      if (data_fim) filtros.data_fim = String(data_fim)

      const eventos = await eventService.listar(
        idSessao,
        Object.keys(filtros).length > 0 ? filtros : undefined
      )

      return res.json({ eventos })
    } catch (error) {
      console.error('EVENTO_LISTAR_ERROR', error)
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  /**
   * Obtém eventos recentes via stream.
   * @param req - Requisição HTTP.
   * @param res - Resposta HTTP.
   */
  async stream(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const ultimoEventoUuid = req.query.ultimo_evento_uuid ? String(req.query.ultimo_evento_uuid) : undefined

      const eventos = await eventService.stream(idSessao, ultimoEventoUuid)
      return res.json({ eventos })
    } catch (error) {
      console.error('EVENTO_STREAM_ERROR', error)
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }
}

export const eventController = new EventController()
