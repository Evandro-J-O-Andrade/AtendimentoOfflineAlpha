/**
 * Dashboard - módulo notificacao
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de notificação. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module notificacao
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo notificacao.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="notificacao - Início" moduleId="notificacao" />;
}

/**
 * Dashboard de analytics do módulo notificacao.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="notificacao - Analytics" moduleId="notificacao" />;
}

/**
 * Dashboard de timeline do módulo notificacao.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="notificacao - Timeline" moduleId="notificacao" />;
}
