/**
 * FinanceiroDashboard
 *
 * Dashboard principal do módulo financeiro. Renderiza um ModuleDashboard
 * com título e descrição específicos do domínio financeiro.
 *
 * @module financeiro
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

export default function FINANCE Dashboard() {
  return (
    <ModuleDashboard
      title="FINANCE Dashboard"
      description="Dashboard do módulo FINANCE"
      moduleId="finance"
    />
  );
}
