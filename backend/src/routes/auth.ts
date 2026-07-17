import { Router } from 'express'
import { authService } from '../core/auth/AuthService'
import type { AuthLoginResponse, AuthSessionResponse, AuthContextResponse } from '../shared/types/auth'

const authRouter: Router = Router()

authRouter.post('/login', async (req, res) => {
  const { username, password, ip, device } = req.body ?? {}

  if (!username || !password) {
    return res.status(400).json({ authenticated: false, state: 'ERROR', message: 'LOGIN_OBRIGATORIO' })
  }

  try {
    const response: AuthLoginResponse = await authService.authenticate(
      username,
      password,
      ip ?? '',
      device ?? ''
    )
    const status = response.authenticated ? 200 : 401
    return res.status(status).json(response)
  } catch (error) {
    console.error('LOGIN_ERROR', error)
    return res.status(500).json({ authenticated: false, state: 'ERROR', message: 'ERRO_INTERNO' })
  }
})

authRouter.get('/session/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const session = await authService.session(idSessao)
    if (!session) {
      return res.status(404).json({ message: 'SESSAO_NAO_ENCONTRADA' })
    }
    return res.json(session)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

authRouter.post('/logout', async (req, res) => {
  return res.status(204).send()
})

authRouter.post('/refresh', async (req, res) => {
  return res.status(501).json({ message: 'NOT_IMPLEMENTED' })
})

authRouter.get('/context/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const context = await authService.context(idSessao)
    return res.json(context)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

authRouter.post('/context/select', async (req, res) => {
  const { id_sessao, id_unidade, id_perfil, id_local } = req.body ?? {}

  if (!id_sessao || !id_unidade || !id_perfil) {
    return res.status(400).json({ message: 'PARAMETROS_INVALIDOS' })
  }

  try {
    const session = await authService.selectContext(id_sessao, id_unidade, id_perfil, id_local ?? 0)
    return res.json({ success: true, session })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

export default authRouter
