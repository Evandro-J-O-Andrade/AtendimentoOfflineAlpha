/**
 * Dashboard - módulo enfermagem
 *
 * Exporta os componentes de dashboard principal, analytics e timeline
 * para o módulo de enfermagem. Utiliza o componente genérico
 * ModuleDashboard para renderização.
 *
 * @module enfermagem
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

/**
 * Dashboard inicial / home do módulo enfermagem.
 * @returns Componente React com dashboard inicial.
 */
export function HomeDashboard() {
  return <ModuleDashboard title="enfermagem - Início" moduleId="enfermagem" />;
}

/**
 * Dashboard de analytics do módulo enfermagem.
 * @returns Componente React com dashboard de analytics.
 */
export function AnalyticsDashboard() {
  return <ModuleDashboard title="enfermagem - Analytics" moduleId="enfermagem" />;
}

/**
 * Dashboard de timeline do módulo enfermagem.
 * @returns Componente React com dashboard de timeline.
 */
export function TimelineDashboard() {
  return <ModuleDashboard title="enfermagem - Timeline" moduleId="enfermagem" />;
}
