/**
 * Dashboard - módulo ffa
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo FFA. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module ffa
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo ffa.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="ffa - Início" moduleId="ffa" />;
}

/**
 * Dashboard de analytics do módulo ffa.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="ffa - Analytics" moduleId="ffa" />;
}

/**
 * Dashboard de timeline do módulo ffa.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="ffa - Timeline" moduleId="ffa" />;
}
