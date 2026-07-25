import { Router } from 'express'
import { integrationService } from './IntegrationService'

const integracaoRouter: Router = Router()

integracaoRouter.post('/n8n/webhook/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)
  const { webhook_id, payload } = req.body ?? {}

  if (!webhook_id) {
    return res.status(400).json({ sucesso: false, mensagem: 'WEBHOOK_ID_OBRIGATORIO' })
  }

  try {
    const response = await integrationService.n8nWebhook(idSessao, webhook_id, payload ?? {})
    const status = response.sucesso ? 200 : 502
    return res.status(status).json(response)
  } catch (error) {
    return res.status(500).json({ sucesso: false, mensagem: 'ERRO_INTERNO' })
  }
})

integracaoRouter.post('/webhook/:origem', async (req, res) => {
  const origem = String(req.params.origem)
  const payload = req.body ?? {}

  try {
    const response = await integrationService.webhookReceber(origem, payload)
    return res.status(response.sucesso ? 200 : 400).json(response)
  } catch (error) {
    return res.status(500).json({ sucesso: false, mensagem: 'ERRO_INTERNO' })
  }
})

integracaoRouter.get('/status/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const status = await integrationService.status(idSessao)
    return res.json({ integracoes: status })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

export default integracaoRouter
