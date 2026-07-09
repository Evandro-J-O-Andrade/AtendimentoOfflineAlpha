import { Router } from 'express'
import { portalService } from '../core/portal/PortalService'

const portalRouter: Router = Router()

portalRouter.get('/runtime/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const runtime = await portalService.runtime(idSessao)
    return res.json(runtime)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/permissions/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const permissions = await portalService.permissions(idSessao)
    return res.json({ permissions })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/navigation/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const navigation = await portalService.navigation(idSessao)
    return res.json(navigation)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/applications/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const applications = await portalService.applications(idSessao)
    return res.json({ applications })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/branding', async (req, res) => {
  try {
    const branding = await portalService.branding()
    return res.json(branding)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/dashboard/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const dashboard = await portalService.dashboard(idSessao)
    return res.json(dashboard)
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/widgets/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const widgets = await portalService.widgets(idSessao)
    return res.json({ widgets })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

portalRouter.get('/notifications/:idSessao', async (req, res) => {
  const idSessao = Number(req.params.idSessao)

  try {
    const notifications = await portalService.notifications(idSessao)
    return res.json({ notifications })
  } catch (error) {
    return res.status(500).json({ message: 'ERRO_INTERNO' })
  }
})

export default portalRouter
