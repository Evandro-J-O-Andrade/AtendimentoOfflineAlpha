import { useContext, useCallback, useMemo } from 'react';
import AtendimentoContext from '../context/AtendimentoContext.jsx';
import { api } from './api.js';

/**
 * Hook: useAtendimento
 * Acesso ao contexto com todas as ações
 */
export const useAtendimento = () => {
  const contexto = useContext(AtendimentoContext);

  if (!contexto) {
    throw new Error('useAtendimento deve ser usado dentro de AtendimentoProvider');
  }

  return contexto;
};

/**
 * Hook: useFFA
 * Gerencia FFA (Ficha de Fila Assistencial)
 */
export const useFFA = () => {
  const {
    ffa,
    definirFFA,
    alterarStatusFFA,
    alterarPrioridadeFFA,
    finalizarFFA,
    registrarEvento,
    definirCarregando,
    definirErro,
  } = useAtendimento();

  const iniciar = useCallback(
    async (idPaciente, idEspecialidade) => {
      definirCarregando(true);
      try {
        const resposta = await api.post('/atendimento/abrir', {
          id_pessoa: idPaciente,
          id_especialidade: idEspecialidade,
        });

        definirFFA(resposta.data);

        registrarEvento({
          entidade: 'FFA',
          id_entidade: resposta.data.id,
          acao: 'CRIACAO',
          detalhes: `Novo atendimento para paciente ${idPaciente}`,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      } finally {
        definirCarregando(false);
      }
    },
    [definirFFA, registrarEvento, definirCarregando, definirErro]
  );

  const alterarStatus = useCallback(
    async (novoStatus, substatus = null) => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA ativa');

        const resposta = await api.post(`/atendimento/${ffa.id}/status`, {
          status: novoStatus,
          substatus,
        });

        alterarStatusFFA(novoStatus, substatus);

        registrarEvento({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'ALTERAR_STATUS',
          antes: ffa.status,
          depois: novoStatus,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [ffa, alterarStatusFFA, registrarEvento, definirErro]
  );

  const alterarPrioridade = useCallback(
    async (prioridade) => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA ativa');

        const resposta = await api.post(`/atendimento/${ffa.id}/prioridade`, {
          prioridade,
        });

        alterarPrioridadeFFA(prioridade);

        registrarEvento({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'ALTERAR_PRIORIDADE',
          antes: ffa.prioridade,
          depois: prioridade,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [ffa, alterarPrioridadeFFA, registrarEvento, definirErro]
  );

  const finalizar = useCallback(
    async (motivo = 'ALTA') => {
      try {
        if (!ffa) throw new Error('Nenhuma FFA ativa');

        const resposta = await api.post(`/atendimento/${ffa.id}/finalizar`, {
          motivo,
        });

        finalizarFFA();

        registrarEvento({
          entidade: 'FFA',
          id_entidade: ffa.id,
          acao: 'FINALIZACAO',
          detalhes: `Atendimento finalizado: ${motivo}`,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [ffa, finalizarFFA, registrarEvento, definirErro]
  );

  return {
    ffa: useMemo(() => ffa, [ffa]),
    iniciar,
    alterarStatus,
    alterarPrioridade,
    finalizar,
  };
};

/**
 * Hook: useFila
 * Gerencia fila operacional
 */
export const useFila = () => {
  const {
    filaOperacional,
    adicionarFila,
    chamarFila,
    iniciarFila,
    finalizarFila,
    removerFila,
    registrarEvento,
    definirCarregando,
    definirErro,
  } = useAtendimento();

  const chamar = useCallback(
    async (idFila, idUsuario) => {
      definirCarregando(true);
      try {
        const resposta = await api.post(`/fila/${idFila}/chamar`, {
          id_usuario: idUsuario,
        });

        chamarFila(idFila, idUsuario);

        registrarEvento({
          entidade: 'FILA',
          id_entidade: idFila,
          acao: 'CHAMADA',
          detalhes: `Chamada por usuário ${idUsuario}`,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      } finally {
        definirCarregando(false);
      }
    },
    [chamarFila, registrarEvento, definirCarregando, definirErro]
  );

  const iniciar = useCallback(
    async (idFila, idUsuario) => {
      try {
        const resposta = await api.post(`/fila/${idFila}/iniciar`, {
          id_usuario: idUsuario,
        });

        iniciarFila(idFila, idUsuario);

        registrarEvento({
          entidade: 'FILA',
          id_entidade: idFila,
          acao: 'INICIO',
          detalhes: `Iniciado por usuário ${idUsuario}`,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [iniciarFila, registrarEvento, definirErro]
  );

  const finalizar = useCallback(
    async (idFila, idUsuario) => {
      try {
        const resposta = await api.post(`/fila/${idFila}/finalizar`, {
          id_usuario: idUsuario,
        });

        finalizarFila(idFila, idUsuario);

        registrarEvento({
          entidade: 'FILA',
          id_entidade: idFila,
          acao: 'FINALIZACAO',
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [finalizarFila, registrarEvento, definirErro]
  );

  const naoCompareceu = useCallback(
    async (idFila, idUsuario, motivo = '') => {
      try {
        const resposta = await api.post(`/fila/${idFila}/nao-compareceu`, {
          id_usuario: idUsuario,
          motivo,
        });

        removerFila(idFila);

        registrarEvento({
          entidade: 'FILA',
          id_entidade: idFila,
          acao: 'NAO_COMPARECIMENTO',
          detalhes: motivo,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [removerFila, registrarEvento, definirErro]
  );

  return {
    fila: useMemo(() => filaOperacional, [filaOperacional]),
    chamar,
    iniciar,
    finalizar,
    naoCompareceu,
  };
};

/**
 * Hook: useOrdem
 * Gerencia ordens assistenciais
 */
export const useOrdem = () => {
  const {
    ordensAssistenciais,
    adicionarOrdem,
    atualizarOrdem,
    concluirOrdem,
    registrarEvento,
    definirCarregando,
    definirErro,
  } = useAtendimento();

  const criar = useCallback(
    async (idFFA, tipo, payload) => {
      definirCarregando(true);
      try {
        const resposta = await api.post('/ordem/criar', {
          id_ffa: idFFA,
          tipo,
          payload,
        });

        adicionarOrdem({
          id: resposta.data.id,
          id_ffa: idFFA,
          tipo,
          payload,
          status: 'ATIVA',
        });

        registrarEvento({
          entidade: 'ORDEM',
          id_entidade: resposta.data.id,
          acao: 'CRIACAO',
          detalhes: `Ordem ${tipo} criada`,
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      } finally {
        definirCarregando(false);
      }
    },
    [adicionarOrdem, registrarEvento, definirCarregando, definirErro]
  );

  const atualizar = useCallback(
    async (idOrdem, dados) => {
      try {
        const resposta = await api.put(`/ordem/${idOrdem}`, dados);

        atualizarOrdem(idOrdem, dados);

        registrarEvento({
          entidade: 'ORDEM',
          id_entidade: idOrdem,
          acao: 'ATUALIZACAO',
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [atualizarOrdem, registrarEvento, definirErro]
  );

  const concluir = useCallback(
    async (idOrdem) => {
      try {
        const resposta = await api.post(`/ordem/${idOrdem}/concluir`);

        concluirOrdem(idOrdem);

        registrarEvento({
          entidade: 'ORDEM',
          id_entidade: idOrdem,
          acao: 'CONCLUSAO',
        });

        return resposta.data;
      } catch (err) {
        definirErro(err.message);
        throw err;
      }
    },
    [concluirOrdem, registrarEvento, definirErro]
  );

  return {
    ordens: useMemo(() => ordensAssistenciais, [ordensAssistenciais]),
    criar,
    atualizar,
    concluir,
  };
};

/**
 * Hook: useAuditoria
 * Acesso ao histórico de auditoria
 */
export const useAuditoria = () => {
  const { obterHistoricoFFA, obterEventos, eventos } = useAtendimento();

  return {
    eventos: useMemo(() => eventos, [eventos]),
    obterHistoricoFFA,
    obterEventos,
  };
};

export default {
  useAtendimento,
  useFFA,
  useFila,
  useOrdem,
  useAuditoria,
};
