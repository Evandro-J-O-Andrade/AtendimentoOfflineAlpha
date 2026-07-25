/**
 * Core Index
 *
 * @module core
 *
 * @see {@link DispatcherClient}
 * @see {@link SessionStore}
 * @see {@link HttpClient}
 * @see {@link WorkflowEngine}
 * @see {@link UiStateManager}
 * @see {@link EventClient}
 */

export { ApiDispatcherClient } from './api/DispatcherClient'
export type { DispatcherClient } from './api/DispatcherClient'

export { SessionStore } from './session/SessionStore'
export type { SessionState, SessionAction } from './session/SessionStore'

export { FetchHttpClient, type HttpClient, type HttpMethod, type HttpResponse } from './infrastructure/HttpClient'

export { DefaultWorkflowEngine, type WorkflowEngine, type WorkflowAction } from './engine/WorkflowEngine'
export { DefaultUiStateManager, type UiStateManager, type UiState, type UiStateStatus } from './engine/UiStateManager'
export { DefaultEventClient, type EventClient, type LocalEvent } from './engine/EventClient'
export type { DispatcherRequest, DispatcherResponse } from './contracts/DispatcherSchemas'
