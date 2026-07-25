/**
 * Dashboard - módulo atendimento
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de atendimento. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module atendimento
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo atendimento.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="atendimento - Início" moduleId="atendimento" />;
}

/**
 * Dashboard de analytics do módulo atendimento.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="atendimento - Analytics" moduleId="atendimento" />;
}

/**
 * Dashboard de timeline do módulo atendimento.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="atendimento - Timeline" moduleId="atendimento" />;
}
