import { Router } from 'express'
import { Router as ExpressRouter } from 'express'
import { integrationService } from '../core/integracoes/IntegrationService'

const integracaoRouter: ExpressRouter = Router()

integracaoRouter.post('/n8n/webhook/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)
  const { webhook_id, payload } = req.body ?? {}

  if (!webhook_id) {
    return res.status(400).json({ sucesso: false, mensagem: 'WEBHOOK_ID_OBRIGATORIO' })
  }

  try {
    const resultado = await integrationService.n8nWebhook(idSessao, String(webhook_id), payload ?? {})
    return res.json(resultado)
  } catch (error) {
    console.error('INTEGRACAO_N8N_ERROR', error)
    return res.status(500).json({ sucesso: false, mensagem: 'ERRO_INTERNO' })
  }
})

integracaoRouter.post('/webhook/:origem', async (req, res) => {
  const origem = req.params.origem

  try {
    const resultado = await integrationService.webhookReceber(origem, req.body ?? {})
    return res.json(resultado)
  } catch (error) {
    console.error('INTEGRACAO_WEBHOOK_ERROR', error)
    return res.status(500).json({ sucesso: false, mensagem: 'ERRO_INTERNO' })
  }
})

integracaoRouter.get('/status/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const status = await integrationService.status(idSessao)
    return res.json(status)
  } catch (error) {
    console.error('INTEGRACAO_STATUS_ERROR', error)
    return res.status(500).json({ sucesso: false, mensagem: 'ERRO_INTERNO' })
  }
})

export default integracaoRouter
