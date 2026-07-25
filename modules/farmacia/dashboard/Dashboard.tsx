/**
 * FarmaciaDashboard
 *
 * Dashboard principal do módulo farmácia. Renderiza um ModuleDashboard
 * com título e descrição específicos do domínio farmácia.
 *
 * @module farmacia
 */

import { ModuleDashboard } from '@/core/components/ModuleDashboard';

export default function FARMACY Dashboard() {
  return (
    <ModuleDashboard
      title="FARMACY Dashboard"
      description="Dashboard do módulo FARMACY"
      moduleId="farmacy"
    />
  );
}
