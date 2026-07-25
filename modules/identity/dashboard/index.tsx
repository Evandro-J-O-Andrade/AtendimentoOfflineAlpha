/**
 * Dashboard - módulo identity
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de identidade. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module identity
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo identity.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="identity - Início" moduleId="identity" />;
}

/**
 * Dashboard de analytics do módulo identity.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="identity - Analytics" moduleId="identity" />;
}

/**
 * Dashboard de timeline do módulo identity.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="identity - Timeline" moduleId="identity" />;
}
