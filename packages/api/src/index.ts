export interface ApiClientConfig {
  baseUrl: string
  getToken?: () => string | null
}

export class ApiClient {
  constructor(private readonly config: ApiClientConfig) {}

  private async request<T>(method: 'GET' | 'POST' | 'PUT' | 'DELETE', path: string, body?: unknown): Promise<T> {
    const res = await fetch(`${this.config.baseUrl}${path}`, {
      method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: body ? JSON.stringify(body) : undefined
    })
    if (!res.ok) {
      throw new Error(`API ${method} ${path} falhou: ${res.status}`)
    }
    return (await res.json()) as T
  }

  async get<T>(path: string): Promise<T> {
    return this.request<T>('GET', path)
  }

  async post<T>(path: string, body: unknown): Promise<T> {
    return this.request<T>('POST', path, body)
  }

  async put<T>(path: string, body: unknown): Promise<T> {
    return this.request<T>('PUT', path, body)
  }

  async delete<T>(path: string): Promise<T> {
    return this.request<T>('DELETE', path)
  }
}

export function createApiClient(config: ApiClientConfig): ApiClient {
  return new ApiClient(config)
}

export { createAuthApi } from './auth'
export type { AuthApi, ContextResponse } from './auth'
export { createPortalApi } from './portal'
export type { PortalApi } from './portal'
