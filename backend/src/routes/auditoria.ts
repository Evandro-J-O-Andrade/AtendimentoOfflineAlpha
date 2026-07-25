import { Router } from 'express'
import { auditController } from '../core/auditoria/AuditController'

const auditoriaRouter: Router = Router()

auditoriaRouter.post('/registrar/:idSessao', async (req, res) => {
  return auditController.registrar(req, res)
})

auditoriaRouter.get('/consultar/:idSessao', async (req, res) => {
  return auditController.consultar(req, res)
})

auditoriaRouter.get('/exportar/:idSessao', async (req, res) => {
  return auditController.exportar(req, res)
})

export default auditoriaRouter
