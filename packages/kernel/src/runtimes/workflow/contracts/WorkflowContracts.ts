/**
 * @fileoverview Contratos canônicos do WorkflowRuntime.
 * @module kernel.runtimes.workflow.contracts
 * @description Define tipos e interfaces do domínio Workflow (MD-KERNEL-011).
 */

export interface WorkflowStep {
  id: string
  nome: string
  modulo: string
  acao: string
  dependencies: string[]
  next?: string
}

export interface WorkflowDefinition {
  id: string
  nome: string
  modulo: string
  passos: WorkflowStep[]
  initialState: Record<string, unknown>
}

export interface WorkflowInstance {
  id: string
  definitionId: string
  currentStep: string
  state: Record<string, unknown>
  history: Array<{ passo: string; timestamp: number; resultado: unknown }>
  status: 'RUNNING' | 'COMPLETED' | 'FAILED' | 'CANCELLED'
}

export type WorkflowEventType =
  | 'WORKFLOW_STARTED'
  | 'WORKFLOW_STEP_EXECUTED'
  | 'WORKFLOW_COMPLETED'
  | 'WORKFLOW_FAILED'
  | 'WORKFLOW_CANCELLED'

export interface WorkflowRuntimeState {
  definitions: WorkflowDefinition[]
  instances: WorkflowInstance[]
  loading: boolean
  error?: string | null
}

export interface WorkflowRuntimeMethods {
  listDefinitions(modulo?: string): Promise<WorkflowDefinition[]>
  start(definitionId: string, payload: Record<string, unknown>): Promise<WorkflowInstance>
  executeStep(instanceId: string, passoId: string, payload: Record<string, unknown>): Promise<WorkflowInstance>
  cancel(instanceId: string): Promise<void>
  compose(session: unknown): WorkflowRuntimeState
}
