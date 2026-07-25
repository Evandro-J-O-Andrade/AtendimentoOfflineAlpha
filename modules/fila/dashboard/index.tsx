/**
 * Dashboard - módulo fila
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de fila. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module fila
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo fila.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="fila - Início" moduleId="fila" />;
}

/**
 * Dashboard de analytics do módulo fila.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="fila - Analytics" moduleId="fila" />;
}

/**
 * Dashboard de timeline do módulo fila.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="fila - Timeline" moduleId="fila" />;
}
