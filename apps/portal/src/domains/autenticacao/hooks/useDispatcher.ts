import { useState, useCallback, useEffect } from 'react'
import type { DispatcherRequest, DispatcherResponse } from '../../../core/contracts/DispatcherSchemas'
import { ApiDispatcherClient } from '../../../core/api/DispatcherClient'

export interface UseDispatcherOptions {
  onSuccess?: (response: DispatcherResponse) => void
  onError?: (error: Error) => void
}

export function useDispatcher(options: UseDispatcherOptions = {}) {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [lastResponse, setLastResponse] = useState<DispatcherResponse | null>(null)

  useEffect(() => {
    const client = new ApiDispatcherClient(import.meta.env.VITE_API_URL ?? 'http://localhost:3001')
    return () => {
      // cleanup if needed
    }
  }, [])

  const dispatch = useCallback(async (request: DispatcherRequest): Promise<DispatcherResponse> => {
    setLoading(true)
    setError(null)

    try {
      const client = new ApiDispatcherClient(import.meta.env.VITE_API_URL ?? 'http://localhost:3001')
      const response = await client.send(request)
      setLastResponse(response)
      options.onSuccess?.(response)
      return response
    } catch (err) {
      const message = err instanceof Error ? err.message : 'ERRO_DESCONHECIDO'
      setError(message)
      options.onError?.(new Error(message))
      throw err
    } finally {
      setLoading(false)
    }
  }, [options])

  return { dispatch, loading, error, lastResponse }
}
