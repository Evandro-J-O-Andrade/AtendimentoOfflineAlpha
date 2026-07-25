import { Router } from 'express'
import { eventController } from '../core/eventos/EventController'

/**
 * Rotas de eventos.
 */
const eventosRouter: Router = Router()

eventosRouter.post('/registrar', eventController.registrar)
eventosRouter.get('/listar/:idSessao', eventController.listar)
eventosRouter.get('/stream/:idSessao', eventController.stream)

export default eventosRouter
