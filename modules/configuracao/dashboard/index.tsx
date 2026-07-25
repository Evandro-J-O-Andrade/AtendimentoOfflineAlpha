/**
 * Dashboard - módulo configuracao
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de configuração. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module configuracao
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo configuracao.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="configuracao - Início" moduleId="configuracao" />;
}

/**
 * Dashboard de analytics do módulo configuracao.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="configuracao - Analytics" moduleId="configuracao" />;
}

/**
 * Dashboard de timeline do módulo configuracao.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="configuracao - Timeline" moduleId="configuracao" />;
}
