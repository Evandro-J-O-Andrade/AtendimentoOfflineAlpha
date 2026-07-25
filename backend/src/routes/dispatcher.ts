import { Router } from 'express'
import dispatcherRouter from '../core/dispatcher/DispatcherController.js'

const dispatcherRoutes: Router = Router()

dispatcherRoutes.use('/', dispatcherRouter)

export default dispatcherRoutes
