/**
 * @fileoverview Ponto de entrada canônico do pacote Kernel Enterprise.
 * @module index
 * @description Exporta runtimes, contratos e infraestrutura do Kernel.
 */

// Contracts
export * from './runtimes/identity/contracts/IdentityContracts'
export * from './runtimes/tenant/contracts/TenantContracts'
export * from './runtimes/session/contracts/SessionContracts'
export * from './runtimes/context/contracts/ContextContracts'
export * from './runtimes/authorization/contracts/AuthorizationContracts'
export * from './runtimes/discovery/contracts/DiscoveryContracts'
export * from './runtimes/registry/contracts/RegistryContracts'
export * from './runtimes/capability/contracts/CapabilityContracts'
export * from './runtimes/navigation/contracts/NavigationContracts'
export * from './runtimes/workflow/contracts/WorkflowContracts'
export * from './runtimes/event/contracts/EventContracts'

// Runtimes
export * from './runtimes/identity/IdentityRuntime'
export * from './runtimes/tenant/TenantRuntime'
export * from './runtimes/session/SessionRuntime'
export * from './runtimes/context/ContextRuntime'
export * from './runtimes/authorization/AuthorizationRuntime'
export * from './runtimes/discovery/DiscoveryRuntime'
export * from './runtimes/registry/RegistryRuntime'
export * from './runtimes/capability/CapabilityRuntime'
export * from './runtimes/navigation/NavigationRuntime'
export * from './runtimes/workflow/WorkflowRuntime'
export * from './runtimes/event/EventRuntime'

// Libs / Infra
export * from './lib/DispatcherContracts'
export * from './lib/DispatcherClientAdapter'
export * from './lib/LocalEventBus'
