// ========================================================
// Context Service - API calls for unit/location context
// ========================================================
import api from './api';

export const contextService = {
  /**
   * Get all active units (unidades)
   * GET /api/context/unidades
   */
  async getUnidades() {
    try {
      const response = await api.get('/context/unidades');
      return { success: true, unidades: response.data.unidades || response.data || [] };
    } catch (error) {
      console.error('Error fetching unidades:', error);
      return {
        success: false,
        message: error.response?.data?.message || error.message || 'Erro ao carregar unidades',
      };
    }
  },

  /**
   * Get operating locations for a specific unit
   * GET /api/context/locais/:id_unidade
   */
  async getLocaisPorUnidade(id_unidade) {
    try {
      const response = await api.get(`/context/locais/${id_unidade}`);
      return { success: true, locais: response.data.locais || response.data || [] };
    } catch (error) {
      console.error('Error fetching locais:', error);
      return {
        success: false,
        message: error.response?.data?.message || error.message || 'Erro ao carregar locais',
      };
    }
  },

  /**
   * Select a unit and location context
   * POST /api/context/selecionar
   */
  async selecionarContexto(id_unidade, id_local_operacional) {
    try {
      const response = await api.post('/context/selecionar', {
        id_unidade,
        id_local_operacional,
      });

      if (!response.data.success) {
        throw new Error(response.data.message || 'Erro ao selecionar contexto');
      }

      return { success: true, contexto: response.data.contexto };
    } catch (error) {
      console.error('Error selecting contexto:', error);
      return {
        success: false,
        message: error.response?.data?.message || error.message || 'Erro ao selecionar contexto',
      };
    }
  },
};
