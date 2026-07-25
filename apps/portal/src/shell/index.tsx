/**
 * Shell Barrel
 *
 * Re-exportações públicas do módulo shell do Portal.
 * Inclui EnterpriseShell, PortalRuntimeProvider, hooks e tipos.
 */
export { EnterpriseShell } from './EnterpriseShell'
export {
  PortalRuntimeProvider,
  usePortalRuntime,
  DEFAULT_RUNTIME
} from './PortalRuntime'
export type { PortalRuntimeContract } from '@atendimentooffline/contracts'
