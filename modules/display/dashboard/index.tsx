/**
 * Dashboard - módulo display
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de display. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module display
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo display.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="display - Início" moduleId="display" />;
}

/**
 * Dashboard de analytics do módulo display.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="display - Analytics" moduleId="display" />;
}

/**
 * Dashboard de timeline do módulo display.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="display - Timeline" moduleId="display" />;
}
