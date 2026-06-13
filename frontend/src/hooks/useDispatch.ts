import { useState, useCallback } from 'react';
import api from '../services/api';

interface DispatchResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
}

interface ApiResponse {
  ok: boolean;
  data: any;
  error?: string;
}

/**
 * Hook useDispatch
 * Centraliza a execução de comandos (ações de escrita) na plataforma New Wave Enterprise.
 * Conecta-se ao endpoint POST /api/runtime/dispatch que invoca a sp_master_dispatcher.
 */
export const useDispatch = () => {
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  const dispatch = useCallback(async <T = any>(
    acao: string, 
    payload: Record<string, any> = {}
  ): Promise<DispatchResponse<T>> => {
    setLoading(true);
    setError(null);

    try {
      // Envia a ação e o payload para o Gateway de Runtime
      const response = await api.post<ApiResponse>('/runtime/dispatch', {
        acao,
        payload
      });

      // O padrão de resposta do backend é { ok: boolean, data: any, error?: string }
      if (response.data && response.data.ok) {
        return {
          success: true,
          data: response.data.data
        };
      } else {
        const errorMsg = response.data?.error ?? 'Erro na execução do comando.';
        setError(errorMsg);
        return { success: false, error: errorMsg };
      }
    } catch (err: any) {
      // Captura erros de rede ou erros 400/500 lançados pelo SIGNAL SQLSTATE '45000'
      const apiError = err.response?.data?.error ?? err.message ?? 'Falha na comunicação com o servidor.';
      setError(apiError);
      return { success: false, error: apiError };
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    dispatch,
    loading,
    error
  };
};