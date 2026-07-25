import { Request, Response } from 'express'
import { contextService } from './ContextService'

export class ContextController {
  /**
   * Retorna unidades disponiveis para a sessao.
   */
  async unidades(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao ?? req.body?.idSessao)

      if (!idSessao) {
        return res.status(400).json({ message: 'ID_SESSAO_OBRIGATORIO' })
      }

      const resultado = await contextService.unidades(idSessao)

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  /**
   * Retorna locais disponiveis para a sessao e unidade.
   */
  async locais(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const idUnidade = Number(req.query.id_unidade ?? req.body?.id_unidade)

      const resultado = await contextService.locais(idSessao, idUnidade)

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  /**
   * Retorna perfis disponiveis para a sessao e unidade.
   */
  async perfis(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const idUnidade = Number(req.query.id_unidade ?? req.body?.id_unidade)

      const resultado = await contextService.perfis(idSessao, idUnidade)

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }

  /**
   * Retorna salas disponiveis para a sessao.
   */
  async salas(req: Request, res: Response) {
    try {
      const idSessao = Number(req.params.idSessao)
      const idUnidadeRaw = req.query.id_unidade ?? req.body?.id_unidade
      const idUnidade = idUnidadeRaw ? Number(idUnidadeRaw) : undefined

      const resultado = await contextService.salas(idSessao, idUnidade)

      if (!resultado.sucesso) {
        return res.status(400).json({ message: resultado.mensagem })
      }

      return res.json(resultado)
    } catch (error) {
      return res.status(500).json({ message: 'ERRO_INTERNO' })
    }
  }
}

export const contextController = new ContextController()
