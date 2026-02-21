// ========================================================
// Auth Context - Estado Global de Autenticação + Contexto
// ========================================================
import { createContext, useReducer, useEffect } from 'react';
import api from '../services/api';

export const AuthContext = createContext();

// ========================================================
// Initial State
// ========================================================
const initialState = {
  usuario: null,
  isAuthenticated: false,
  loading: true,
  error: null,
  accessToken: null,
  refreshToken: null,
  
  // Contexto de unidade/local
  idUnidade: null,
  idLocalOperacional: null,
  unidadeNome: null,
  unidadeTipo: null,
  localNome: null,
  localCodigo: null,
  localTipo: null,
  localSala: null,
  idSessionUsuario: null,
  
  // Para o fluxo de seleção de contexto
  selecionandoContexto: false
};

// ========================================================
// Reducer
// ========================================================
const authReducer = (state, action) => {
  switch (action.type) {
    case 'SET_LOADING':
      return { ...state, loading: action.payload };

    case 'SET_USER':
      return {
        ...state,
        usuario: action.payload.usuario,
        accessToken: action.payload.accessToken,
        refreshToken: action.payload.refreshToken,
        isAuthenticated: true,
        error: null,
        loading: false,
        selecionandoContexto: true // Após login, vai selecionar contexto
      };

    case 'SET_ERROR':
      return {
        ...state,
        error: action.payload,
        loading: false
      };

    case 'SET_CONTEXTO':
      return {
        ...state,
        idUnidade: action.payload.id_unidade,
        idLocalOperacional: action.payload.id_local_operacional,
        unidadeNome: action.payload.unidade_nome,
        unidadeTipo: action.payload.unidade_tipo,
        localNome: action.payload.local_nome,
        localCodigo: action.payload.local_codigo,
        localTipo: action.payload.local_tipo,
        localSala: action.payload.local_sala,
        selecionandoContexto: false,
        error: null
      };

    case 'LOGOUT':
      return {
        ...initialState,
        loading: false
      };

    case 'RESTORE_SESSION':
      return {
        ...state,
        usuario: action.payload.usuario,
        accessToken: action.payload.accessToken,
        refreshToken: action.payload.refreshToken,
        isAuthenticated: !!action.payload.usuario,
        idUnidade: action.payload.idUnidade,
        idLocalOperacional: action.payload.idLocalOperacional,
        unidadeNome: action.payload.unidadeNome,
        unidadeTipo: action.payload.unidadeTipo,
        localNome: action.payload.localNome,
        localCodigo: action.payload.localCodigo,
        localTipo: action.payload.localTipo,
        localSala: action.payload.localSala,
        loading: false
      };

    default:
      return state;
  }
};

// ========================================================
// Auth Provider Component
// ========================================================
export const AuthProvider = ({ children }) => {
  const [state, dispatch] = useReducer(authReducer, initialState);

  // Restaura sessão ao carregar componente
  useEffect(() => {
    const usuario = localStorage.getItem('usuario');
    const accessToken = localStorage.getItem('accessToken');
    const refreshToken = localStorage.getItem('refreshToken');
    const contexto = localStorage.getItem('contexto');

    if (usuario && accessToken && refreshToken) {
      try {
        const parsedUser = JSON.parse(usuario);
        const parsedContexto = contexto ? JSON.parse(contexto) : {};
        
        dispatch({
          type: 'RESTORE_SESSION',
          payload: {
            usuario: parsedUser,
            accessToken,
            refreshToken,
            idUnidade: parsedContexto.idUnidade,
            idLocalOperacional: parsedContexto.idLocalOperacional,
            unidadeNome: parsedContexto.unidadeNome,
            unidadeTipo: parsedContexto.unidadeTipo,
            localNome: parsedContexto.localNome,
            localCodigo: parsedContexto.localCodigo,
            localTipo: parsedContexto.localTipo,
            localSala: parsedContexto.localSala
          }
        });
      } catch (err) {
        console.error('Erro ao restaurar sessão:', err);
        localStorage.removeItem('usuario');
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('contexto');
        dispatch({ type: 'SET_LOADING', payload: false });
      }
    } else {
      dispatch({ type: 'SET_LOADING', payload: false });
    }
  }, []);

  // Login
  const login = async (email, senha) => {
    dispatch({ type: 'SET_LOADING', payload: true });
    try {
      const response = await api.post('/auth/login', { email, senha });
      const { accessToken, refreshToken, usuario } = response.data;

      // Salva no localStorage
      localStorage.setItem('accessToken', accessToken);
      localStorage.setItem('refreshToken', refreshToken);
      localStorage.setItem('usuario', JSON.stringify(usuario));

      // Atualiza estado
      dispatch({
        type: 'SET_USER',
        payload: { usuario, accessToken, refreshToken }
      });

      return usuario;
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao fazer login';
      dispatch({ type: 'SET_ERROR', payload: errorMsg });
      throw error;
    }
  };

  // Logout
  const logout = async () => {
    try {
      // Tenta notificar backend
      await api.post('/auth/logout');
    } catch (error) {
      console.warn('Erro ao fazer logout no backend:', error);
    } finally {
      // Limpa localStorage
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
      localStorage.removeItem('usuario');

      // Atualiza estado
      dispatch({ type: 'LOGOUT' });
    }
  };

  // Refresh Token
  const refreshAccessToken = async () => {
    try {
      const refreshToken = localStorage.getItem('refreshToken');
      if (!refreshToken) throw new Error('Sem refresh token');

      const response = await api.post('/auth/refresh', { refreshToken });
      const { accessToken } = response.data;

      localStorage.setItem('accessToken', accessToken);
      dispatch({ type: 'SET_USER', payload: { ...state, accessToken } });

      return accessToken;
    } catch (error) {
      console.error('Erro ao renovar token:', error);
      logout();
      throw error;
    }
  };

  // Selecionar Contexto (Unidade + Local Operacional)
  const selecionarContexto = async (id_unidade, id_local_operacional) => {
    try {
      const response = await api.post('/context/selecionar', {
        id_unidade,
        id_local_operacional
      });

      const { contexto } = response.data;

      // Salva no localStorage
      localStorage.setItem('contexto', JSON.stringify({
        idUnidade: contexto.id_unidade,
        idLocalOperacional: contexto.id_local_operacional,
        unidadeNome: contexto.unidade_nome,
        unidadeTipo: contexto.unidade_tipo,
        localNome: contexto.local_nome,
        localCodigo: contexto.local_codigo,
        localTipo: contexto.local_tipo,
        localSala: contexto.local_sala
      }));

      // Atualiza estado
      dispatch({
        type: 'SET_CONTEXTO',
        payload: contexto
      });

      return contexto;
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao selecionar contexto';
      dispatch({ type: 'SET_ERROR', payload: errorMsg });
      throw error;
    }
  };

  const value = {
    ...state,
    login,
    logout,
    refreshAccessToken,
    selecionarContexto
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
