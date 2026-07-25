import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  WorkflowDefinition,
  WorkflowInstance,
  WorkflowRuntimeState,
  WorkflowRuntimeMethods
} from './contracts/WorkflowContracts'

/**
 * Runtime de Workflow do Kernel Enterprise (MD-KERNEL-011).
 *
 * @fileoverview Implementação canônica do WorkflowRuntime.
 */
export class WorkflowRuntime implements WorkflowRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient
  private definitions: WorkflowDefinition[] = []

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async listDefinitions(modulo?: string): Promise<WorkflowDefinition[]> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'WORKFLOW.LIST_DEFINITIONS',
      payload: { modulo },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return this.definitions.filter((d) => !modulo || d.modulo === modulo)
    }

    this.definitions = response.resultado as WorkflowDefinition[]
    return [...this.definitions]
  }

  async start(definitionId: string, payload: Record<string, unknown>): Promise<WorkflowInstance> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'WORKFLOW.START',
      payload: { definitionId, payload },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_INICIAR_WORKFLOW')
    }

    const instance = response.resultado as WorkflowInstance
    this.events?.track({ modulo: 'KERNEL', acao: 'WORKFLOW_STARTED', payload: { definitionId, instance } })
    return instance
  }

  async executeStep(instanceId: string, passoId: string, payload: Record<string, unknown>): Promise<WorkflowInstance> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'WORKFLOW.EXECUTE_STEP',
      payload: { instanceId, passoId, payload },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_EXECUTAR_PASSO_WORKFLOW')
    }

    const instance = response.resultado as WorkflowInstance
    this.events?.track({ modulo: 'KERNEL', acao: 'WORKFLOW_STEP_EXECUTED', payload: { instanceId, passoId, instance } })
    return instance
  }

  async cancel(instanceId: string): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'WORKFLOW.CANCEL',
      payload: { instanceId },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_CANCELAR_WORKFLOW')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'WORKFLOW_CANCELLED', payload: { instanceId } })
  }

  compose(_session: unknown): WorkflowRuntimeState {
    return {
      definitions: [...this.definitions],
      instances: [],
      loading: false,
      error: null
    }
  }
}
