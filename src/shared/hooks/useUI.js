/**
 * useUI — Hook para Gerenciar Estado de UI (Modais, Notificações, Loading)
 */

import { useContext, useCallback } from 'react';
import AtendimentoContextoV2 from '@/context/AtendimentoContextoV2.jsx';

export function useUI() {
  const contexto = useContext(AtendimentoContextoV2);
  if (!contexto) throw new Error('useUI deve estar dentro de AtendimentoProviderV2');

  const { estado, setLoading, setErro, setModal, adicionarNotificacao } = contexto;

  // Abrir modal genérico
  const abrirModal = useCallback(
    (titulo, conteudo, opcoes = {}) => {
      setModal({
        aberto: true,
        titulo,
        conteudo,
        tipo: opcoes.tipo || 'info', // 'info', 'aviso', 'erro', 'sucesso'
        botoes: opcoes.botoes || [
          { texto: 'Cancelar', acao: () => fecharModal() },
          { texto: 'OK', acao: () => fecharModal(), primario: true },
        ],
      });
    },
    [setModal],
  );

  // Fechar modal
  const fecharModal = useCallback(() => {
    setModal({ aberto: false });
  }, [setModal]);

  // Notificar sucesso
  const notificarSucesso = useCallback(
    (mensagem, duracao = 3000) => {
      adicionarNotificacao({
        tipo: 'sucesso',
        mensagem,
        duracao,
      });
    },
    [adicionarNotificacao],
  );

  // Notificar erro
  const notificarErro = useCallback(
    (mensagem, duracao = 5000) => {
      adicionarNotificacao({
        tipo: 'erro',
        mensagem,
        duracao,
      });
      setErro(mensagem);
    },
    [adicionarNotificacao, setErro],
  );

  // Notificar info
  const notificarInfo = useCallback(
    (mensagem, duracao = 3000) => {
      adicionarNotificacao({
        tipo: 'info',
        mensagem,
        duracao,
      });
    },
    [adicionarNotificacao],
  );

  // Loading
  const iniciarLoading = useCallback(
    (mensagem = 'Carregando...') => {
      setLoading(true);
      notificarInfo(mensagem);
    },
    [setLoading, notificarInfo],
  );

  const finalizarLoading = useCallback(() => {
    setLoading(false);
  }, [setLoading]);

  // Confirmar ação
  const confirmar = useCallback(
    (mensagem, onConfirmar, onCancelar = null) => {
      abrirModal('Confirmação', mensagem, {
        tipo: 'aviso',
        botoes: [
          { texto: 'Cancelar', acao: () => { fecharModal(); if (onCancelar) onCancelar(); } },
          { texto: 'Confirmar', acao: () => { fecharModal(); onConfirmar(); }, primario: true },
        ],
      });
    },
    [abrirModal, fecharModal],
  );

  return {
    loading: estado.ui.loading,
    erro: estado.ui.erro,
    modal: estado.ui.modal,
    notificacoes: estado.ui.notificacoes,
    abrirModal,
    fecharModal,
    notificarSucesso,
    notificarErro,
    notificarInfo,
    iniciarLoading,
    finalizarLoading,
    confirmar,
  };
}
