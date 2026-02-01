/**
 * useFFAs — Hook para Gerenciar FFAs por Local de Atendimento
 * Oferece ações específicas: abrir, mover, finalizar, priorizar FFAs
 */

import { useContext, useCallback } from 'react';
import AtendimentoContextoV2 from '../context/AtendimentoContextoV2';
import atendimentoService from '../services/atendimento.service';

export function useFFAs() {
  const contexto = useContext(AtendimentoContextoV2);
  if (!contexto) throw new Error('useFFAs deve estar dentro de AtendimentoProviderV2');

  const { estado, carregarFFAs, adicionarFFA, atualizarFFA, selecionarFFA, moverFFAParaLocal, finalizarFFA, mudarPrioridadeFFA } = contexto;

  // Abrir nova FFA (recepção)
  const abrirFFA = useCallback(async (dados) => {
    try {
      contexto.setLoading(true);
      const resultado = await atendimentoService.abrirRecepcao(dados);
      if (resultado.ok) {
        adicionarFFA({
          id: resultado.data.id_atendimento,
          id_atendimento: resultado.data.id_atendimento,
          id_paciente: dados.id_paciente || null,
          numero_senha: resultado.data.id_senha,
          status: 'ABERTO',
          layout: 'RECEPCAO',
          classificacao_cor: 'VERDE',
          criado_em: new Date().toISOString(),
          tempo_limite: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString(),
        });
        contexto.adicionarNotificacao({ tipo: 'sucesso', mensagem: 'FFA aberta com sucesso' });
      }
    } catch (erro) {
      contexto.setErro(`Erro ao abrir FFA: ${erro.message}`);
    } finally {
      contexto.setLoading(false);
    }
  }, [contexto, adicionarFFA]);

  // Mover FFA para novo local (triagem, consultório, etc)
  const moverFFAPara = useCallback(async (id_ffa, novoLocal, novoStatus) => {
    try {
      contexto.setLoading(true);
      const resultado = await atendimentoService.mudarLocal({ id_atendimento: id_ffa, id_local: novoLocal });
      if (resultado.ok) {
        moverFFAParaLocal({ id_ffa, novo_local: novoLocal, novo_status: novoStatus });
        contexto.adicionarNotificacao({ tipo: 'sucesso', mensagem: `FFA movida para ${novoLocal}` });
      }
    } catch (erro) {
      contexto.setErro(`Erro ao mover FFA: ${erro.message}`);
    } finally {
      contexto.setLoading(false);
    }
  }, [contexto, moverFFAParaLocal]);

  // Finalizar FFA (alta, transferência, óbito)
  const finalizarFFAPor = useCallback(async (id_ffa, desfecho, observacao = '') => {
    try {
      contexto.setLoading(true);
      const resultado = await atendimentoService.finalizarAtendimento({
        id_atendimento: id_ffa,
        id_usuario: contexto.estado.usuario.id_usuario,
        desfecho,
        observacao,
      });
      if (resultado.ok) {
        finalizarFFA(id_ffa);
        contexto.adicionarNotificacao({ tipo: 'sucesso', mensagem: `FFA finalizada: ${desfecho}` });
      }
    } catch (erro) {
      contexto.setErro(`Erro ao finalizar FFA: ${erro.message}`);
    } finally {
      contexto.setLoading(false);
    }
  }, [contexto, finalizarFFA]);

  // Mudar prioridade (Manchester)
  const mudarPriori = useCallback((id_ffa, novaCor) => {
    const cores = { VERMELHO: 0, LARANJA: 10, AMARELO: 60, VERDE: 120, AZUL: 240 };
    const minutos = cores[novaCor] || 120;
    const tempo_limite = new Date(Date.now() + minutos * 60 * 1000).toISOString();
    
    mudarPrioridadeFFA({ id_ffa, nova_cor: novaCor, tempo_limite });
    contexto.adicionarNotificacao({ tipo: 'info', mensagem: `Prioridade alterada para ${novaCor}` });
  }, [contexto, mudarPrioridadeFFA]);

  // Buscar FFAs de um local específico
  const ffasDoLocal = estado.ffas.por_local[contexto.estado.usuario.local_atual] || [];
  const ffasOrdenadas = estado.ffas.por_prioridade;

  return {
    ffas: estado.ffas.ativas,
    ffasDoLocal,
    ffasOrdenadas,
    ffaSelecionada: estado.ffas.selecionada,
    abrirFFA,
    moverFFAPara,
    finalizarFFAPor,
    mudarPriori,
    selecionarFFA,
    carregarFFAs,
  };
}
