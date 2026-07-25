import type { DispatcherResponse } from '../contracts/DispatcherSchemas'

export type WorkflowAction =
  | { type: 'NAVIGATE'; route: string }
  | { type: 'SHOW_DIALOG'; dialog: { title: string; message: string } }
  | { type: 'REDIRECT_LOGIN' }
  | { type: 'REFRESH_SESSION' }
  | { type: 'UPDATE_STATE'; state: Record<string, unknown> }
  | { type: 'NONE' }

export interface WorkflowEngine {
  interpret(response: DispatcherResponse): WorkflowAction
}

export class DefaultWorkflowEngine implements WorkflowEngine {
  interpret(response: DispatcherResponse): WorkflowAction {
    if (!response.sucesso) {
      if (response.mensagem?.includes('SESSAO')) {
        return { type: 'REFRESH_SESSION' }
      }
      if (response.mensagem?.includes('PERMISSAO')) {
        return { type: 'NAVIGATE', route: '/unauthorized' }
      }
      return {
        type: 'SHOW_DIALOG',
        dialog: {
          title: 'Erro',
          message: response.mensagem ?? 'Erro desconhecido'
        }
      }
    }

    const state = response.resultado as Record<string, unknown> | undefined

    if (state?.redirect) {
      return { type: 'NAVIGATE', route: String(state.redirect) }
    }

    if (state?.session_expired) {
      return { type: 'REDIRECT_LOGIN' }
    }

    return { type: 'UPDATE_STATE', state: state ?? {} }
  }
}
