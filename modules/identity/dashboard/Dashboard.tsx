/**
 * IdentityDashboard
 *
 * Dashboard principal do módulo identity. Renderiza um ModuleDashboard
 * com título e descrição específicos do domínio de identidade.
 *
 * @module identity
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

export default function CORE Dashboard() {
  return (
    <ModuleDashboard
      title="CORE Dashboard"
      description="Dashboard do módulo CORE"
      moduleId="core"
    />
  );
}
