/**
 * Dashboard - módulo financeiro
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo financeiro. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module financeiro
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo financeiro.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="financeiro - Início" moduleId="financeiro" />;
}

/**
 * Dashboard de analytics do módulo financeiro.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="financeiro - Analytics" moduleId="financeiro" />;
}

/**
 * Dashboard de timeline do módulo financeiro.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="financeiro - Timeline" moduleId="financeiro" />;
}
