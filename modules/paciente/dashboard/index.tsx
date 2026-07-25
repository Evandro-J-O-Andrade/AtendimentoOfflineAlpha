/**
 * Dashboard - módulo paciente
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de paciente. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module paciente
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo paciente.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="paciente - Início" moduleId="paciente" />;
}

/**
 * Dashboard de analytics do módulo paciente.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="paciente - Analytics" moduleId="paciente" />;
}

/**
 * Dashboard de timeline do módulo paciente.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="paciente - Timeline" moduleId="paciente" />;
}
