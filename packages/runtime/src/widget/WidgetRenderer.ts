import type { WidgetContract } from '@atendimentooffline/contracts'
import { resolveWidgets } from './WidgetResolver'

/**
 * Filtra widgets cuja permissão exigida não está presente no conjunto concedido.
 * Widgets sem `requiredPermission` sempre passam.
 */
export function filterWidgetsByPermission(
  widgets: WidgetContract[],
  permissions: string[]
): WidgetContract[] {
  const granted = new Set(permissions)
  return widgets.filter((w) => !w.requiredPermission || granted.has(w.requiredPermission))
}

/**
 * Resolução de widgets para o runtime: filtra por permissão e ordena por `order`.
 * Parte do pipeline Portal Runtime → Permission Engine → WidgetRenderer.
 */
export function renderWidgets(
  widgets: WidgetContract[],
  permissions: string[]
): WidgetContract[] {
  return resolveWidgets(filterWidgetsByPermission(widgets, permissions))
}
