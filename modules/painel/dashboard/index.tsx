/**
 * Dashboard - módulo painel
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo painel. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module painel
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo painel.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="painel - Início" moduleId="painel" />;
}

/**
 * Dashboard de analytics do módulo painel.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="painel - Analytics" moduleId="painel" />;
}

/**
 * Dashboard de timeline do módulo painel.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="painel - Timeline" moduleId="painel" />;
}
