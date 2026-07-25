/**
 * Dashboard - módulo runtime
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo runtime. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module runtime
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo runtime.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="runtime - Início" moduleId="runtime" />;
}

/**
 * Dashboard de analytics do módulo runtime.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="runtime - Analytics" moduleId="runtime" />;
}

/**
 * Dashboard de timeline do módulo runtime.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="runtime - Timeline" moduleId="runtime" />;
}
