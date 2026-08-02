import { Router } from 'express'
import totemRouter from '../core/totem/TotemController.js'

const totemRoutes: Router = Router()

totemRoutes.use('/', totemRouter)

export default totemRoutes
