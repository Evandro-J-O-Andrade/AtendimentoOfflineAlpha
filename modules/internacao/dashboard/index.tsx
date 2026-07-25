/**
 * Dashboard - módulo internacao
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de internação. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module internacao
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo internacao.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="internacao - Início" moduleId="internacao" />;
}

/**
 * Dashboard de analytics do módulo internacao.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="internacao - Analytics" moduleId="internacao" />;
}

/**
 * Dashboard de timeline do módulo internacao.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="internacao - Timeline" moduleId="internacao" />;
}
