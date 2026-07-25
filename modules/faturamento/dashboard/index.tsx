/**
 * Dashboard - módulo faturamento
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de faturamento. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module faturamento
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo faturamento.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="faturamento - Início" moduleId="faturamento" />;
}

/**
 * Dashboard de analytics do módulo faturamento.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="faturamento - Analytics" moduleId="faturamento" />;
}

/**
 * Dashboard de timeline do módulo faturamento.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="faturamento - Timeline" moduleId="faturamento" />;
}
