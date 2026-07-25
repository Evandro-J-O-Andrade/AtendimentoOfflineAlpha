/**
 * Dashboard - módulo laboratorio
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de laboratório. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module laboratorio
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo laboratorio.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="laboratorio - Início" moduleId="laboratorio" />;
}

/**
 * Dashboard de analytics do módulo laboratorio.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="laboratorio - Analytics" moduleId="laboratorio" />;
}

/**
 * Dashboard de timeline do módulo laboratorio.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="laboratorio - Timeline" moduleId="laboratorio" />;
}
