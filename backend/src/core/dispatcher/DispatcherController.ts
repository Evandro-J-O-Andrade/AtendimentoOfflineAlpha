import { Router, type Request, type Response } from 'express'
import { dispatcherService } from '../dispatcher/DispatcherService'
import type { DispatcherResponse, RuntimeContext } from '../dispatcher/DispatcherService'

const dispatcherRouter: Router = Router()

dispatcherRouter.post('/', async (req: Request, res: Response) => {
  const { capability, payload, context, uuid_transacao } = req.body ?? {}

  if (!capability) {
    return res.status(400).json({
      sucesso: false,
      mensagem: 'PARAMETROS_INVALIDOS: capability e context.id_sessao sao obrigatorios'
    })
  }

  const idSessao = (context?.id_sessao as number) ?? Number(req.headers['x-session-id']) ?? 0

  if (!idSessao) {
    return res.status(400).json({
      sucesso: false,
      mensagem: 'PARAMETROS_INVALIDOS: capability e context.id_sessao sao obrigatorios'
    })
  }

  const response = await dispatcherService.dispatch({
    capability: String(capability),
    payload: payload ?? {},
    context: {
      id_sessao: idSessao,
      id_usuario: Number(context?.id_usuario ?? 0),
      id_entidade: Number(context?.id_entidade ?? 0),
      id_unidade: Number(context?.id_unidade ?? 0),
      id_perfil: Number(context?.id_perfil ?? 0),
      id_local: Number(context?.id_local ?? 0),
    },
    uuid_transacao: uuid_transacao ? String(uuid_transacao) : undefined,
  })

  return res.json(response)
})

export default dispatcherRouter
