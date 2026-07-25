import { Router } from 'express'
import { contextController } from '../core/contexto/ContextController'

const contextoRouter: Router = Router()

contextoRouter.get('/unidades/:idSessao', async (req, res) => {
  await contextController.unidades(req, res)
})

contextoRouter.get('/locais/:idSessao', async (req, res) => {
  await contextController.locais(req, res)
})

contextoRouter.get('/perfis/:idSessao', async (req, res) => {
  await contextController.perfis(req, res)
})

contextoRouter.get('/salas/:idSessao', async (req, res) => {
  await contextController.salas(req, res)
})

export default contextoRouter
