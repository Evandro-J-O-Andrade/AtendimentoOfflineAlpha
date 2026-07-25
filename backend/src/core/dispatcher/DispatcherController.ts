import { Router, type Request, type Response } from 'express'
import { dispatcherService } from '../dispatcher/DispatcherService'

export interface DispatcherRequest {
  modulo: string
  acao: string
  payload: Record<string, unknown>
  id_sessao: number
}

export interface DispatcherResponse {
  sucesso: boolean
  resultado?: unknown
  mensagem?: string
}

const dispatcherRouter: Router = Router()

dispatcherRouter.post('/', async (req: Request<unknown, unknown, DispatcherRequest>, res: Response) => {
  const { modulo, acao, payload, id_sessao, uuid_transacao } = req.body ?? {}

  if (!modulo || !acao || id_sessao === undefined) {
    return res.status(400).json({ sucesso: false, mensagem: 'PARAMETROS_INVALIDOS: modulo, acao e id_sessao sao obrigatorios' })
  }

  const response = await dispatcherService.dispatch({
    modulo: String(modulo),
    acao: String(acao),
    payload: payload ?? {},
    id_sessao: Number(id_sessao),
    uuid_transacao: uuid_transacao ? String(uuid_transacao) : undefined
  })

  return res.json(response)
})

export default dispatcherRouter
