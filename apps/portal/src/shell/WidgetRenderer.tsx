import React from 'react'
import type { WidgetContract } from '@atendimentooffline/contracts'

/**
 * Widget Component Type
 *
 * Tipo de componente React para renderização de widgets.
 */
export type WidgetComponent = React.FC<{ widget: WidgetContract }>

const cardStyle: React.CSSProperties = {
  border: '1px solid #e2e8f0',
  borderRadius: 8,
  padding: 16,
  minWidth: 200,
  background: '#fff'
}

const titleStyle: React.CSSProperties = {
  fontWeight: 600,
  marginBottom: 8
}

function MetricWidget({ widget }: { widget: WidgetContract }) {
  const value = (widget.config?.value as number | string) ?? '—'
  return (
    <div style={cardStyle}>
      <div style={titleStyle}>{widget.title}</div>
      <div style={{ fontSize: 28, fontWeight: 700 }}>{value}</div>
    </div>
  )
}

function QueueWidget({ widget }: { widget: WidgetContract }) {
  const items = (widget.config?.items as string[]) ?? []
  return (
    <div style={cardStyle}>
      <div style={titleStyle}>{widget.title}</div>
      <ol>
        {items.map((it, i) => (
          <li key={i}>{it}</li>
        ))}
      </ol>
    </div>
  )
}

function NoticeWidget({ widget }: { widget: WidgetContract }) {
  const text = (widget.config?.text as string) ?? (widget.config?.descricao as string) ?? ''
  return (
    <div style={{ ...cardStyle, borderLeft: '4px solid #2563eb' }}>
      <div style={titleStyle}>{widget.title}</div>
      <div style={{ fontSize: 13 }}>{text}</div>
    </div>
  )
}

function ClockWidget({ widget }: { widget: WidgetContract }) {
  return (
    <div style={cardStyle}>
      <div style={titleStyle}>{widget.title}</div>
      <div style={{ fontSize: 24 }}>{new Date().toLocaleTimeString()}</div>
    </div>
  )
}

function GenericWidget({ widget }: { widget: WidgetContract }) {
  return (
    <div style={cardStyle}>
      <div style={titleStyle}>{widget.title}</div>
      <div style={{ fontSize: 12, opacity: 0.7 }}>{widget.type}</div>
    </div>
  )
}

/**
 * WidgetRegistry: mapeia widget.type → componente visual.
 *
 * O Renderer não conhece banco nem regra de negócio — apenas WidgetContract.
 * Para suportar um novo tipo (ex.: kanban, timeline, heatmap, gauge), basta
 * registrar o componente; não é necessário alterar o WidgetRenderer.
 */
/**
 * Widget Registry
 *
 * Registro de renderizadores de widget por tipo.
 * Mapeia widget.type → componente visual.
 * Para suportar novo tipo, basta registrar componente; não é necessário
 * alterar o WidgetRenderer.
 *
 * @example
 * widgetRegistry.register('kanban', KanbanWidget)
 */
export class WidgetRegistry {
  private readonly renderers = new Map<string, WidgetComponent>()

  register(kind: string, component: WidgetComponent): WidgetRegistry {
    this.renderers.set(kind, component)
    return this
  }

  has(kind: string): boolean {
    return this.renderers.has(kind)
  }

  resolve(kind: string): WidgetComponent {
    return this.renderers.get(kind) ?? GenericWidget
  }
}

export const widgetRegistry = new WidgetRegistry()
  .register('metric', MetricWidget)
  .register('queue', QueueWidget)
  .register('notice', NoticeWidget)
  .register('clock', ClockWidget)
  .register('chart', GenericWidget)
  .register('table', GenericWidget)
  .register('calendar', GenericWidget)
  .register('list', GenericWidget)
  .register('generic', GenericWidget)

/** WidgetRenderer: resolve o componente visual a partir do contrato (GAP-1 resolvido). */
/**
 * Widget Renderer
 *
 * Resolve o componente visual a partir do contrato WidgetContract.
 * Encapsula lógica de dispatch por tipo de widget.
 *
 * @param props.widget - Contrato do widget a ser renderizado.
 * @returns Componente visual correspondente ao tipo do widget.
 *
 * @see {@link WidgetRegistry}
 * @see {@link WidgetContract}
 */
export function WidgetRenderer({ widget }: { widget: WidgetContract }) {
  const Renderer = widgetRegistry.resolve(widget.type)
  return <Renderer widget={widget} />
}
