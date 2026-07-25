/**
 * Dashboard - módulo iam
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo IAM. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module iam
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo iam.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="iam - Início" moduleId="iam" />;
}

/**
 * Dashboard de analytics do módulo iam.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="iam - Analytics" moduleId="iam" />;
}

/**
 * Dashboard de timeline do módulo iam.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="iam - Timeline" moduleId="iam" />;
}
