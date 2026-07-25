/**
 * Dashboard - módulo medico
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo médico. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module medico
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo medico.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="medico - Início" moduleId="medico" />;
}

/**
 * Dashboard de analytics do módulo medico.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="medico - Analytics" moduleId="medico" />;
}

/**
 * Dashboard de timeline do módulo medico.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="medico - Timeline" moduleId="medico" />;
}
