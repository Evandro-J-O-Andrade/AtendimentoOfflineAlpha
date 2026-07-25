/**
 * Dashboard - módulo triagem
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de triagem. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module triagem
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo triagem.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="triagem - Início" moduleId="triagem" />;
}

/**
 * Dashboard de analytics do módulo triagem.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="triagem - Analytics" moduleId="triagem" />;
}

/**
 * Dashboard de timeline do módulo triagem.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="triagem - Timeline" moduleId="triagem" />;
}
