/**
 * Dashboard - módulo estoque
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de estoque. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module estoque
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo estoque.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="estoque - Início" moduleId="estoque" />;
}

/**
 * Dashboard de analytics do módulo estoque.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="estoque - Analytics" moduleId="estoque" />;
}

/**
 * Dashboard de timeline do módulo estoque.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="estoque - Timeline" moduleId="estoque" />;
}
