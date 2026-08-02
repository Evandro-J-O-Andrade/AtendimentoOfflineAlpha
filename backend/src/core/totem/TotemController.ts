import { Router, type Request, type Response } from 'express'
import { totemService } from './TotemService'
import type { TotemSenhaRequest } from './TotemService'

const totemRouter: Router = Router()

totemRouter.get('/opcoes', async (req: Request, res: Response) => {
  try {
    const idSessao = Number(req.headers['x-session-id'] ?? req.query.id_sessao ?? 0)
    const id_unidade = Number(req.query.id_unidade ?? 0)
    const id_local_operacional = Number(req.query.id_local_operacional ?? 0)

    if (!idSessao || !id_unidade || !id_local_operacional) {
      return res.status(400).json({ sucesso: false, mensagem: 'PARAMETROS_INVALIDOS: id_sessao, id_unidade e id_local_operacional sao obrigatorios' })
    }

    const opcoes = await totemService.listarOpcoes(idSessao, id_unidade, id_local_operacional)
    return res.json({ sucesso: true, data: opcoes })
  } catch (error: any) {
    return res.status(500).json({ sucesso: false, mensagem: error?.message ?? 'ERRO_INTERNO' })
  }
})

totemRouter.get('/plantao-medico', async (req: Request, res: Response) => {
  try {
    const idSessao = Number(req.headers['x-session-id'] ?? req.query.id_sessao ?? 0)
    const id_unidade = Number(req.query.id_unidade ?? 0)
    const data = req.query.data as string | undefined

    if (!idSessao || !id_unidade) {
      return res.status(400).json({ sucesso: false, mensagem: 'PARAMETROS_INVALIDOS: id_sessao e id_unidade sao obrigatorios' })
    }

    const plantao = await totemService.buscarPlantaoMedico(idSessao, id_unidade, data)
    return res.json({ sucesso: true, data: plantao })
  } catch (error: any) {
    return res.status(500).json({ sucesso: false, mensagem: error?.message ?? 'ERRO_INTERNO' })
  }
})

totemRouter.post('/gerar-senha', async (req: Request<unknown, unknown, TotemSenhaRequest>, res: Response) => {
  try {
    const idSessao = Number(req.headers['x-session-id'] ?? 0)
    const payload = req.body

    if (!idSessao || !payload.id_opcao || !payload.id_unidade || !payload.id_local_operacional) {
      return res.status(400).json({ sucesso: false, mensagem: 'PARAMETROS_INVALIDOS: id_sessao, id_opcao, id_unidade e id_local_operacional sao obrigatorios' })
    }

    const senha = await totemService.gerarSenha(idSessao, payload)
    return res.json({ sucesso: true, data: senha })
  } catch (error: any) {
    const mensagem = String(error?.message ?? 'ERRO_INTERNO')
    const status = mensagem.includes('PERMISSION_DENIED') ? 403 : mensagem.includes('SESSAO') || mensagem.includes('INVALIDA') ? 401 : 400
    return res.status(status).json({ sucesso: false, mensagem })
  }
})

export default totemRouter
