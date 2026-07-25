/**
 * Dashboard - módulo recepcao
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de recepção. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module recepcao
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo recepcao.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="recepcao - Início" moduleId="recepcao" />;
}

/**
 * Dashboard de analytics do módulo recepcao.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="recepcao - Analytics" moduleId="recepcao" />;
}

/**
 * Dashboard de timeline do módulo recepcao.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="recepcao - Timeline" moduleId="recepcao" />;
}
