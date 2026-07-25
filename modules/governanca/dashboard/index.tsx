/**
 * Dashboard - módulo governanca
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de governança. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module governanca
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo governanca.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="governanca - Início" moduleId="governanca" />;
}

/**
 * Dashboard de analytics do módulo governanca.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="governanca - Analytics" moduleId="governanca" />;
}

/**
 * Dashboard de timeline do módulo governanca.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="governanca - Timeline" moduleId="governanca" />;
}
