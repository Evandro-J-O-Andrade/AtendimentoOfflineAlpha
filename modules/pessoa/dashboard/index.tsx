/**
 * Dashboard - módulo pessoa
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de pessoa. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module pessoa
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo pessoa.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="pessoa - Início" moduleId="pessoa" />;
}

/**
 * Dashboard de analytics do módulo pessoa.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="pessoa - Analytics" moduleId="pessoa" />;
}

/**
 * Dashboard de timeline do módulo pessoa.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="pessoa - Timeline" moduleId="pessoa" />;
}
