export interface HttpResponse<T> {
  data: T
  status: number
  headers: Headers
}

export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'

export interface HttpClient {
  request<T>(config: {
    method: HttpMethod
    url: string
    headers?: Record<string, string>
    body?: unknown
    timeout?: number
  }): Promise<HttpResponse<T>>
}

export class FetchHttpClient implements HttpClient {
  constructor(private baseUrl: string) {}

  async request<T>(config: {
    method: HttpMethod
    url: string
    headers?: Record<string, string>
    body?: unknown
    timeout?: number
  }): Promise<HttpResponse<T>> {
    const controller = new AbortController()
    const timeoutId = config.timeout
      ? setTimeout(() => controller.abort(), config.timeout)
      : undefined

    try {
      const response = await fetch(`${this.baseUrl}${config.url}`, {
        method: config.method,
        headers: {
          'Content-Type': 'application/json',
          ...config.headers
        },
        body: config.body ? JSON.stringify(config.body) : undefined,
        signal: controller.signal
      })

      if (timeoutId) {
        clearTimeout(timeoutId)
      }

      const data = (await response.json()) as T

      return {
        data,
        status: response.status,
        headers: response.headers
      }
    } catch (error) {
      if (timeoutId) {
        clearTimeout(timeoutId)
      }
      throw error
    }
  }
}
