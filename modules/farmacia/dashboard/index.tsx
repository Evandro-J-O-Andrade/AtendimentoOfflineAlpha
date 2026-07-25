/**
 * Dashboard - módulo farmacia
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de farmácia. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module farmacia
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo farmacia.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="farmacia - Início" moduleId="farmacia" />;
}

/**
 * Dashboard de analytics do módulo farmacia.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="farmacia - Analytics" moduleId="farmacia" />;
}

/**
 * Dashboard de timeline do módulo farmacia.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="farmacia - Timeline" moduleId="farmacia" />;
}
