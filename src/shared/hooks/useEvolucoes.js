/**
 * useEvolucoes — Hook para Gerenciar Evoluções de Enfermagem/Médica
 * Histórico de evolução de pacientes (internação e FFA)
 */

import { useContext, useCallback } from 'react';
import AtendimentoContextoV2 from '../context/AtendimentoContextoV2';

export function useEvolucoes() {
  const contexto = useContext(AtendimentoContextoV2);
  if (!contexto) throw new Error('useEvolucoes deve estar dentro de AtendimentoProviderV2');

  const { estado, carregarEvolucoes, adicionarEvolucao } = contexto;

  // Adicionar evolução para internação ou FFA
  const registrarEvolucao = useCallback((dados) => {
    const evolucao = {
      id_evolucao: Date.now(),
      id_internacao: dados.id_internacao || null,
      id_ffa: dados.id_ffa || null,
      tipo: dados.tipo || 'EVOLUCAO_ENFERMAGEM', // EVOLUCAO_ENFERMAGEM, EVOLUCAO_MEDICA, ANOTACAO
      descricao: dados.descricao,
      id_usuario: contexto.estado.usuario.id_usuario,
      nome_usuario: contexto.estado.usuario.nome,
      data_hora: new Date().toISOString(),
      sinais_vitais: dados.sinais_vitais || null,
      observacoes: dados.observacoes || null,
    };
    
    adicionarEvolucao(evolucao);
    contexto.adicionarNotificacao({ tipo: 'sucesso', mensagem: 'Evolução registrada' });
    
    return evolucao;
  }, [contexto, adicionarEvolucao]);

  // Buscar evolução de internação específica
  const evolucoesInternacao = useCallback((id_internacao) => {
    return estado.evolucoes.por_internacao[id_internacao] || [];
  }, [estado.evolucoes.por_internacao]);

  // Buscar evolução de FFA específica
  const evolucoesFFa = useCallback((id_ffa) => {
    return estado.evolucoes.por_ffa[id_ffa] || [];
  }, [estado.evolucoes.por_ffa]);

  return {
    todasEvolucoes: estado.evolucoes,
    registrarEvolucao,
    evolucoesInternacao,
    evolucoesFFa,
    carregarEvolucoes,
  };
}
