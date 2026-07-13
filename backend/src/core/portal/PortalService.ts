import { getDatabasePool } from '@backend/database/mysql/connection'
import { permissionService } from '../permissions/PermissionService'

export class PortalService {
  private connection = getDatabasePool()

  async navigation(idSessao: number) {
    const conn = await this.connection

    await conn.query('CALL sp_auth_menu_get(?, @resultado, @sucesso, @mensagem)', [idSessao])
    const [outRows] = await conn.query(
      'SELECT @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem'
    )

    const out = (outRows as any[])[0]
    if (!out || !out.sucesso) {
      return []
    }

    const raw = out.resultado
    const resultado = typeof raw === 'string' ? JSON.parse(raw) : raw
    const modulos = resultado?.modulos ?? []

    return (modulos as any[]).map((modulo: any) => ({
      id: String(modulo.modulo),
      label: String(modulo.nome),
      items: (modulo.acoes ?? []).map((acao: any) => ({
        id: String(acao.codigo),
        label: String(acao.nome),
        route: `/${modulo.modulo}/${String(acao.codigo).toLowerCase()}`,
        permission: String(acao.codigo)
      }))
    }))
  }

  async applications(idSessao: number) {
    const navigation = await this.navigation(idSessao)

    return navigation.map((nav) => ({
      id: nav.id,
      code: nav.id,
      name: nav.label,
      icon: undefined,
      route: `/${nav.id}`,
      category: 'Enterprise',
      enabled: true,
      permission: nav.items[0]?.permission
    }))
  }

  async branding() {
    return {
      name: 'Enterprise Portal',
      logo: undefined,
      primaryColor: undefined,
      theme: 'light'
    }
  }

  async dashboard(idSessao: number) {
    return {
      id: 'dashboard-default',
      title: 'Dashboard',
      layout: 'grid',
      widgets: []
    }
  }

  async widgets(idSessao: number) {
    return []
  }

  async notifications(idSessao: number) {
    return []
  }

  async permissions(idSessao: number) {
    return permissionService.evaluate(idSessao)
  }

  async runtime(idSessao: number) {
    const [navigation, applications, branding, dashboard, widgets, notifications, permissions] = await Promise.all([
      this.navigation(idSessao),
      this.applications(idSessao),
      this.branding(),
      this.dashboard(idSessao),
      this.widgets(idSessao),
      this.notifications(idSessao),
      this.permissions(idSessao)
    ])

    return {
      user: null,
      tenant: null,
      context: null,
      navigation,
      applications,
      branding,
      dashboard,
      widgets,
      notifications,
      management: { enabled: false, containers: [] },
      permissions
    }
  }
}

export const portalService = new PortalService()
