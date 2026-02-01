/**
 * useLocaisAtendimento — Hook para Gerenciar Filas por Local
 * Acesso a FFAs agrupadas por local (RECEPCAO, TRIAGEM, CONSULTORIO, EXAME, MEDICACAO, etc)
 */

import { useContext, useCallback } from 'react';
import AtendimentoContextoV2 from '../context/AtendimentoContextoV2';

export function useLocaisAtendimento() {
  const contexto = useContext(AtendimentoContextoV2);
  if (!contexto) throw new Error('useLocaisAtendimento deve estar dentro de AtendimentoProviderV2');

  const { estado, setLocalUsuario, atualizarFilaLocal } = contexto;

  // Locais disponíveis
  const LOCAIS = {
    RECEPCAO: 'Recepção',
    TRIAGEM: 'Triagem',
    CONSULTORIO: 'Consultório',
    EXAME: 'Exame (Lab/RX)',
    MEDICACAO: 'Medicação',
    INTERNACAO: 'Internação',
    SAMU: 'SAMU',
    FARMACIA: 'Farmácia',
    TI: 'TI/GLPI',
    GLPI: 'GLPI Helpdesk',
    MANUTENCAO: 'Manutenção',
  };

  // Mudar local do usuário
  const irParaLocal = useCallback((local) => {
    if (LOCAIS[local]) {
      setLocalUsuario(local);
      contexto.adicionarNotificacao({ tipo: 'info', mensagem: `Mudou para ${LOCAIS[local]}` });
    }
  }, [contexto, setLocalUsuario]);

  // Fila do local atual
  const filaLocalAtual = estado.filas[estado.usuario.local_atual] || [];

  // Fila de qualquer local
  const filaLocal = useCallback((local) => {
    return estado.filas[local] || [];
  }, [estado.filas]);

  // Total de pacientes em espera por local
  const totaisPorLocal = Object.keys(LOCAIS).reduce((acc, local) => {
    acc[local] = estado.filas[local]?.length || 0;
    return acc;
  }, {});

  // Total geral
  const totalEmEspera = Object.values(totaisPorLocal).reduce((a, b) => a + b, 0);

  return {
    LOCAIS,
    localAtual: estado.usuario.local_atual,
    irParaLocal,
    filaLocalAtual,
    filaLocal,
    totaisPorLocal,
    totalEmEspera,
    atualizarFilaLocal,
  };
}
