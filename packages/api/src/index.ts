export interface ApiClientConfig {
  baseUrl: string
  getToken?: () => string | null
}

export class ApiClient {
  constructor(private readonly config: ApiClientConfig) {}

  private async request<T>(method: 'GET' | 'POST' | 'PUT' | 'DELETE', path: string, body?: unknown, headers?: Record<string, string>): Promise<T> {
    const res = await fetch(`${this.config.baseUrl}${path}`, {
      method,
      headers: {
        'Content-Type': 'application/json',
        ...(this.config.getToken ? { Authorization: `Bearer ${this.config.getToken()}` } : {}),
        ...headers
      },
      body: body ? JSON.stringify(body) : undefined
    })
    if (!res.ok) {
      throw new Error(`API ${method} ${path} falhou: ${res.status}`)
    }
    return (await res.json()) as T
  }

  async get<T>(path: string, headers?: Record<string, string>): Promise<T> {
    return this.request<T>('GET', path, undefined, headers)
  }

  async post<T>(path: string, body: unknown, headers?: Record<string, string>): Promise<T> {
    return this.request<T>('POST', path, body, headers)
  }

  async put<T>(path: string, body: unknown, headers?: Record<string, string>): Promise<T> {
    return this.request<T>('PUT', path, body, headers)
  }

  async delete<T>(path: string, headers?: Record<string, string>): Promise<T> {
    return this.request<T>('DELETE', path, undefined, headers)
  }
}

export function createApiClient(config: ApiClientConfig): ApiClient {
  return new ApiClient(config)
}

export { createAuthApi } from './auth'
export type { AuthApi, ContextResponse } from './auth'
export { createPortalApi } from './portal'
export type { PortalApi } from './portal'
export { createTotemApi } from './totem/TotemApi'
export type { TotemApi } from './totem/TotemApi'
