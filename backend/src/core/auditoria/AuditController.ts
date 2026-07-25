import { Request, Response } from 'express'
import { auditService, AuditFiltro } from './AuditService'

export class AuditController {
  async registrar(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const { acao, entidade, id_entidade, dados_anterior, dados_novo } = req.body

      if (!acao || !entidade || id_entidade === undefined || id_entidade === null) {
        return res.status(400).json({ message: 'ACao, ID_ENTIDADE e entidade sao obrigatorios' })
      }

      const resultado = await auditService.registrar(idSessao, {
        acao,
        entidade,
        id_entidade: Number(id_entidade),
        dados_anterior,
        dados_novo
      })

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  async consultar(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)

      const filtros: AuditFiltro = {
        entidade: req.query.entidade ? String(req.query.entidade) : undefined,
        id_entidade: req.query.id_entidade ? Number(req.query.id_entidade) : undefined,
        acao: req.query.acao ? String(req.query.acao) : undefined,
        data_inicio: req.query.data_inicio ? String(req.query.data_inicio) : undefined,
        data_fim: req.query.data_fim ? String(req.query.data_fim) : undefined
      }

      const resultado = await auditService.consultar(idSessao, filtros)

      if (!resultado.sucesso) {
        return res.status(404).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  async exportar(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const formato = String(req.query.formato ?? 'json').toLowerCase()

      if (!['json', 'csv'].includes(formato)) {
        return res.status(400).json({ message: 'Formato invalido. Use json ou csv.' })
      }

      const filtros: AuditFiltro = {
        entidade: req.query.entidade ? String(req.query.entidade) : undefined,
        id_entidade: req.query.id_entidade ? Number(req.query.id_entidade) : undefined,
        data_inicio: req.query.data_inicio ? String(req.query.data_inicio) : undefined,
        data_fim: req.query.data_fim ? String(req.query.data_fim) : undefined
      }

      const resultado = await auditService.exportar(idSessao, formato as 'json' | 'csv', filtros)

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }
}

export const auditController = new AuditController()
