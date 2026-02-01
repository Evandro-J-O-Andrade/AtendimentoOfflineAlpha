/**
 * useAlertasFFAs — Hook para Gerenciar Alertas por Prioridade
 * Monitora Manchester classificação e tempo limite para exibir alertas
 */

import { useContext, useCallback, useMemo } from 'react';
import AtendimentoContextoV2 from '../context/AtendimentoContextoV2';

export function useAlertasFFAs() {
  const contexto = useContext(AtendimentoContextoV2);
  if (!contexto) throw new Error('useAlertasFFAs deve estar dentro de AtendimentoProviderV2');

  const { estado, adicionarAlerta, removerAlerta } = contexto;

  // Níveis de prioridade Manchester
  const PRIORIDADES = {
    VERMELHO: { label: 'Emergência', cor: '#dc3545', icone: '🔴', urgencia: 'Imediato' },
    LARANJA: { label: 'Muito Urgente', cor: '#ff8c00', icone: '🟠', urgencia: '10 min' },
    AMARELO: { label: 'Urgente', cor: '#ffc107', icone: '🟡', urgencia: '1 hora' },
    VERDE: { label: 'Pouco Urgente', cor: '#28a745', icone: '🟢', urgencia: '2 horas' },
    AZUL: { label: 'Não Urgente', cor: '#17a2b8', icone: '🔵', urgencia: '4 horas' },
  };

  // Calcula tempo restante até tempo_limite
  const calcularTempoRestante = useCallback((ffa) => {
    if (!ffa.tempo_limite) return null;
    const agora = new Date();
    const limite = new Date(ffa.tempo_limite);
    const minutos = Math.floor((limite - agora) / 60000);
    return minutos >= 0 ? minutos : 0;
  }, []);

  // FFAs que precisam de atenção urgente (tempo restante < 5 minutos)
  const ffasUrgentes = useMemo(() => {
    return estado.ffas.ativas.filter((ffa) => {
      const minutos = calcularTempoRestante(ffa);
      return minutos !== null && minutos <= 5 && minutos > 0;
    });
  }, [estado.ffas.ativas, calcularTempoRestante]);

  // FFAs com tempo expirado
  const ffasExpiradas = useMemo(() => {
    return estado.ffas.ativas.filter((ffa) => {
      const minutos = calcularTempoRestante(ffa);
      return minutos === 0;
    });
  }, [estado.ffas.ativas, calcularTempoRestante]);

  // FFAs por nível de prioridade
  const ffasPorPrioridade = useMemo(() => {
    return Object.keys(PRIORIDADES).reduce((acc, prioridade) => {
      acc[prioridade] = estado.ffas.ativas.filter((ffa) => ffa.classificacao_manchester === prioridade);
      return acc;
    }, {});
  }, [estado.ffas.ativas]);

  // Contar FFAs por prioridade
  const countPorPrioridade = useMemo(() => {
    return Object.keys(ffasPorPrioridade).reduce((acc, prioridade) => {
      acc[prioridade] = ffasPorPrioridade[prioridade].length;
      return acc;
    }, {});
  }, [ffasPorPrioridade]);

  // Adicionar alerta (entra automático quando urgente)
  const notificarUrgentes = useCallback(() => {
    ffasUrgentes.forEach((ffa) => {
      const minutos = calcularTempoRestante(ffa);
      adicionarAlerta({
        nivel: 'critico',
        ffa_id: ffa.id,
        mensagem: `Paciente ${ffa.id_paciente} expirado em ${minutos} minutos (${ffa.classificacao_manchester})`,
        timestamp: new Date(),
      });
    });
  }, [ffasUrgentes, calcularTempoRestante, adicionarAlerta]);

  // Notificar expiradas
  const notificarExpiradas = useCallback(() => {
    ffasExpiradas.forEach((ffa) => {
      adicionarAlerta({
        nivel: 'critico_maximo',
        ffa_id: ffa.id,
        mensagem: `⚠️ PRAZO EXPIRADO: Paciente ${ffa.id_paciente} (${ffa.classificacao_manchester})`,
        timestamp: new Date(),
      });
    });
  }, [ffasExpiradas, adicionarAlerta]);

  return {
    PRIORIDADES,
    ffasUrgentes,
    ffasExpiradas,
    ffasPorPrioridade,
    countPorPrioridade,
    alertas: estado.alertas,
    adicionarAlerta,
    removerAlerta,
    notificarUrgentes,
    notificarExpiradas,
    calcularTempoRestante,
  };
}
