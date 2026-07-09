import type { WidgetContract } from '@atendimentooffline/contracts'

export function resolveWidgets(widgets: WidgetContract[]): WidgetContract[] {
  return [...widgets].sort((a, b) => (a.order ?? 0) - (b.order ?? 0))
}
