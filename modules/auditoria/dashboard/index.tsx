/**
 * Dashboard - módulo auditoria
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de auditoria. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module auditoria
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo auditoria.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="auditoria - Início" moduleId="auditoria" />;
}

/**
 * Dashboard de analytics do módulo auditoria.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="auditoria - Analytics" moduleId="auditoria" />;
}

/**
 * Dashboard de timeline do módulo auditoria.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="auditoria - Timeline" moduleId="auditoria" />;
}
