export type WidgetKind =
  | 'metric'
  | 'chart'
  | 'table'
  | 'calendar'
  | 'list'
  | 'notice'
  | 'queue'
  | 'clock'
  | 'generic'

export const WIDGET_TAXONOMY: readonly WidgetKind[] = [
  'metric',
  'chart',
  'table',
  'calendar',
  'list',
  'notice',
  'queue',
  'clock',
  'generic'
]

export function isWidgetKind(value: string): value is WidgetKind {
  return (WIDGET_TAXONOMY as readonly string[]).includes(value)
}

export interface WidgetContract {
  id: string
  type: string
  title: string
  config?: Record<string, unknown>
  order?: number
  /** Código de permissão exigido para renderizar (filtrado no runtime). */
  requiredPermission?: string
  /** Contexto (ex.: id_unidade/id_local) exigido para renderizar. */
  requiredContext?: string
}
