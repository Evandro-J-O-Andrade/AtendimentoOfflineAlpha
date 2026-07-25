/**
 * Dashboard - módulo kernel
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo kernel. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module kernel
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo kernel.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="kernel - Início" moduleId="kernel" />;
}

/**
 * Dashboard de analytics do módulo kernel.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="kernel - Analytics" moduleId="kernel" />;
}

/**
 * Dashboard de timeline do módulo kernel.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="kernel - Timeline" moduleId="kernel" />;
}
