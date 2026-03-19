import api from "../api/api";

/**
 * Serviço de Dispatcher para chamar sp_master_dispatcher
 * 
 *用法:
 * await dispatcherAction({
 *   dominio: 'FILA',
 *   acao: 'CHAMAR',
 *   idReferencia: 123,
 *   payload: { estado_destino: 'EM_ATENDIMENTO' }
 * })
 */
export async function dispatcherAction({ 
  dominio, 
  acao, 
  idReferencia = 0, 
  payload = {},
  uuidTransacao = null 
}) {
  const token = localStorage.getItem("runtime_token");
  if (!token) {
    return { sucesso: false, erro: "NAO_AUTENTICADO" };
  }

  try {
    const response = await api.post(`/runtime/dispatcher`, {
      dominio,
      acao,
      id_referencia: idReferencia,
      payload,
      uuid_transacao: uuidTransacao || crypto.randomUUID()
    }, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });

    return response.data;
  } catch (err) {
    console.error("dispatcherAction error:", err?.message || err);
    return {
      sucesso: false,
      erro: err?.response?.data?.erro || "ERRO_DISPATCHER"
    };
  }
}

/**
 * Wrapper para ações de FILA
 */
export const filaDispatcher = {
  async chamar(idSenha) {
    return dispatcherAction({
      dominio: 'FILA',
      acao: 'CHAMAR',
      idReferencia: idSenha,
      payload: { estado_destino: 'EM_ATENDIMENTO' }
    });
  },

  async encaminhar(idSenha, idLocalDestino) {
    return dispatcherAction({
      dominio: 'FILA',
      acao: 'ENCAMINHAR',
      idReferencia: idSenha,
      payload: { id_local_destino: idLocalDestino }
    });
  },

  async finalizar(idSenha) {
    return dispatcherAction({
      dominio: 'FILA',
      acao: 'FINALIZAR',
      idReferencia: idSenha,
      payload: { estado_destino: 'ATENDIDO' }
    });
  },

  async reativar(idSenha) {
    return dispatcherAction({
      dominio: 'FILA',
      acao: 'REATIVAR',
      idReferencia: idSenha,
      payload: { estado_destino: 'AGUARDANDO' }
    });
  }
};

/**
 * Wrapper para ações ASSISTENCIAIS (Triagem, Médico, etc)
 */
export const assistencialDispatcher = {
  async triagemIniciar(idSenha, sinaisVitais) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'TRIAGEM_INICIAR',
      idReferencia: idSenha,
      payload: { sinais_vitais: sinaisVitais }
    });
  },

  async triagemFinalizar(idSenha, classificacaoRisco) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'TRIAGEM_FINALIZAR',
      idReferencia: idSenha,
      payload: { classificacao_risco: classificacaoRisco, estado_destino: 'AGUARDANDO_MEDICO' }
    });
  },

  async medicoAtender(idAtendimento) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'MEDICO_ATENDER',
      idReferencia: idAtendimento,
      payload: { estado_destino: 'EM_ATENDIMENTO' }
    });
  },

  async medicoPrescrever(idAtendimento, prescricao) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'MEDICO_PRESCREVER',
      idReferencia: idAtendimento,
      payload: { prescricao }
    });
  },

  async medicoEncaminhar(idAtendimento, destino) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'MEDICO_ENCAMINHAR',
      idReferencia: idAtendimento,
      payload: { destino }
    });
  },

  async medicoAlta(idAtendimento) {
    return dispatcherAction({
      dominio: 'ASSISTENCIAL',
      acao: 'MEDICO_ALTA',
      idReferencia: idAtendimento,
      payload: { estado_destino: 'ALTA' }
    });
  }
};

/**
 * Wrapper para ações de FARMÁCIA
 */
export const farmaciaDispatcher = {
  async dispensar(idPrescricao, itens) {
    return dispatcherAction({
      dominio: 'FARMACIA',
      acao: 'DISPENSAR',
      idReferencia: idPrescricao,
      payload: { itens }
    });
  },

  async devolver(idDispensacao) {
    return dispatcherAction({
      dominio: 'FARMACIA',
      acao: 'DEVOLVER',
      idReferencia: idDispensacao,
      payload: {}
    });
  }
};

/**
 * Wrapper para ações de ESTOQUE
 */
export const estoqueDispatcher = {
  async entrada(idProduto, quantidade, notaFiscal) {
    return dispatcherAction({
      dominio: 'ESTOQUE',
      acao: 'ENTRADA',
      idReferencia: idProduto,
      payload: { quantidade, nota_fiscal: notaFiscal }
    });
  },

  async saida(idProduto, quantidade, destino) {
    return dispatcherAction({
      dominio: 'ESTOQUE',
      acao: 'SAIDA',
      idReferencia: idProduto,
      payload: { quantidade, destino }
    });
  },

  async transferencia(idProduto, quantidade, localDestino) {
    return dispatcherAction({
      dominio: 'ESTOQUE',
      acao: 'TRANSFERENCIA',
      idReferencia: idProduto,
      payload: { quantidade, local_destino: localDestino }
    });
  }
};

/**
 * Wrapper para ações de FATURAMENTO
 */
export const faturamentoDispatcher = {
  async gerarProtocolo(idAtendimento) {
    return dispatcherAction({
      dominio: 'FATURAMENTO',
      acao: 'GERAR_PROTOCOLO',
      idReferencia: idAtendimento,
      payload: {}
    });
  },

  async enviarSUS(idAtendimento) {
    return dispatcherAction({
      dominio: 'FATURAMENTO',
      acao: 'ENVIAR_SUS',
      idReferencia: idAtendimento,
      payload: {}
    });
  }
};

export default dispatcherAction;
