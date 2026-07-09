export interface PermissionContract {
  codigo: string
  nome: string
  dominio?: string
  grupo_menu?: string
  icone?: string
  ordem_menu?: number
  visivel_menu?: boolean
  metadata?: Record<string, unknown>
}
