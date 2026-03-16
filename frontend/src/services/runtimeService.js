/**
 * Runtime Service
 * Gateway de comunicação entre o frontend e o backend Node
 * Executa stored procedures através do dispatcher
 */

const API_BASE = "/api/runtime";

/**
 * Executa uma ação no backend
 * @param {string} acao - Nome da ação (ex: "TRIAGEM_CLASSIFICAR", "SENHA_CHAMAR")
 * @param {object} payload - Dados necessários para a ação
 * @param {string} contexto - Contexto operacional (opcional)
 * @returns {Promise<object>} Resultado da ação
 */
export async function executarAcao(acao, payload = {}, contexto = null) {
  const token = localStorage.getItem("token_his");
  
  if (!token) {
    return {
      sucesso: false,
      mensagem: "Usuário não autenticado"
    };
  }

  try {
    const response = await fetch(`${API_BASE}/dispatch`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        acao,
        contexto,
        payload
      })
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error(`Erro ao executar ação ${acao}:`, error);
    return {
      sucesso: false,
      mensagem: "Erro de comunicação com o servidor",
      erro: error.message
    };
  }
}

/**
 * Executa múltiplas ações em uma única transação
 * @param {Array} acoes - Array de objetos {acao, payload, contexto}
 * @returns {Promise<object>} Resultado consolidado
 */
export async function executarBatch(acoes) {
  const token = localStorage.getItem("token_his");
  
  if (!token) {
    return {
      sucesso: false,
      mensagem: "Usuário não autenticado"
    };
  }

  try {
    const response = await fetch(`${API_BASE}/dispatch/batch`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({ acoes })
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Erro ao executar batch:", error);
    return {
      sucesso: false,
      mensagem: "Erro de comunicação com o servidor",
      erro: error.message
    };
  }
}

// ============================================
// AÇÕES PRÉ-DEFINIDAS
// ============================================

// Senha
export const AcoesSenha = {
  gerarTotem: (id_opcao) => executarAcao("TOTEM_GERAR_SENHA", { id_opcao }),
  chamar: (id_senha, id_guiche) => executarAcao("CHAMAR_SENHA", { id_senha, id_guiche }),
  atender: (id_senha) => executarAcao("SENHA_ATENDER", { id_senha }),
  cancelar: (id_senha, motivo) => executarAcao("CANCELAR_SENHA", { id_senha, motivo }),
  complementar: (id_senha, complemento) => executarAcao("COMPLEMENTAR_SENHA", { id_senha, complemento })
};

// Triagem
export const AcoesTriagem = {
  classificar: (id_senha, classificacao, observacoes) => 
    executarAcao("TRIAGEM_CLASSIFICAR", { id_senha, classificacao, observacoes }),
  registrar: (id_senha, dados) => 
    executarAcao("TRIAGEM_REGISTRAR", { id_senha, ...dados })
};

// Atendimento
export const AcoesAtendimento = {
  iniciar: (id_paciente, tipo_atendimento) => 
    executarAcao("ATENDIMENTO_INICIAR", { id_paciente, tipo_atendimento }),
  transicionar: (id_atendimento, status, local_destino) => 
    executarAcao("ATENDIMENTO_TRANSICIONAR", { id_atendimento, status, local_destino }),
  finalizar: (id_atendimento, desfecho) => 
    executarAcao("ATENDIMENTO_FINALIZAR", { id_atendimento, desfecho }),
  cancelar: (id_atendimento, motivo) => 
    executarAcao("ATENDIMENTO_CANCELAR", { id_atendimento, motivo })
};

// Medicação
export const AcoesMedicacao = {
  registrar: (id_prescricao, id_atendimento, medicamentos) => 
    executarAcao("ADMINISTRACAO_MEDICACAO_REGISTRAR", { id_prescricao, id_atendimento, medicamentos }),
  cancelar: (id_administracao, motivo) => 
    executarAcao("CANCELAR_ADMINISTRACAO_MEDICACAO", { id_administracao, motivo })
};

// Farmácia
export const AcoesFarmacia = {
  dispensar: (id_prescricao, medicamentos) => 
    executarAcao("FARMACIA_DISPENSAR", { id_prescricao, medicamentos })
};

// Alertas
export const AcoesAlerta = {
  registrar: (id_atendimento, tipo, mensagem) => 
    executarAcao("REGISTRAR_ALERTA", { id_atendimento, tipo, mensagem }),
  consumir: (id_alerta) => 
    executarAcao("ALERTA_CONSUMO", { id_alerta })
};

export default {
  executarAcao,
  executarBatch,
  AcoesSenha,
  AcoesTriagem,
  AcoesAtendimento,
  AcoesMedicacao,
  AcoesFarmacia,
  AcoesAlerta
};
