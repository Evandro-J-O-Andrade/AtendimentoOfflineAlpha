/**
 * Dispatcher API - Interface para chamar o Master Dispatcher
 * HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * Usa a arquitetura canônica: Frontend -> API -> sp_master_dispatcher -> sp_executor_* -> Banco
 */

import { apiGet, apiPost } from "./api";

/**
 * Executar ação via dispatcher
 * @param {string} acao - Código da ação (ex: 'SENHA_CRIAR', 'CHAMAR_SENHA')
 * @param {string} contexto - Contexto da ação (ex: 'FILA', 'ATENDIMENTO', 'TRIAGEM')
 * @param {object} payload - Dados específicos da ação
 * @returns {Promise<object>} Resposta do servidor
 */
export async function executarAcao(acao, contexto = "DEFAULT", payload = {}) {
  return apiPost("/runtime/dispatch", {
    acao,
    contexto,
    payload,
  });
}

/**
 * Executar múltiplas ações em uma única transação
 * @param {Array} acoes - Array de objetos {acao, contexto, payload}
 * @returns {Promise<object>} Resposta do servidor
 */
export async function executarAcoesBatch(acoes) {
  return apiPost("/runtime/dispatch/batch", { acoes });
}

/**
 * Listar todas as ações disponíveis para o perfil atual
 * @returns {Promise<object>} Lista de ações permitidas
 */
export async function listarAcoesPermitidas() {
  return apiGet("/runtime/dispatch/acao/list");
}

// ============================================
// AÇÕES DE FILA/SENHA
// ============================================

/**
 * Gerar senha no totem
 * @param {number} id_local - ID do local/unidade
 * @param {string} tipo_prioridade - Tipo de prioridade (NORMAL, URGENTE)
 * @returns {Promise<object>}
 */
export async function gerarSenhaTotem(id_local, tipo_prioridade = "NORMAL") {
  return executarAcao("TOTEM_GERAR_SENHA", "FILA", {
    id_local,
    tipo_prioridade,
  });
}

/**
 * Criar nova senha na recepção
 * @param {number} id_local - ID do local
 * @param {number} id_paciente - ID do paciente (opcional)
 * @param {string} observacoes - Observações
 * @returns {Promise<object>}
 */
export async function criarSenha(id_local, id_paciente = null, observacoes = "") {
  return executarAcao("SENHA_CRIAR", "FILA", {
    id_local,
    id_paciente,
    observacoes,
  });
}

/**
 * Chamar senha no painel
 * @param {number} id_senha - ID da senha a ser chamada
 * @param {number} id_guiche - ID do guichê
 * @returns {Promise<object>}
 */
export async function chamarSenha(id_senha, id_guiche) {
  return executarAcao("SENHA_CHAMAR", "FILA", {
    id_senha,
    id_guiche,
  });
}

/**
 * Atender senha
 * @param {number} id_senha - ID da senha
 * @param {number} id_profissional - ID do profissional que atende
 * @returns {Promise<object>}
 */
export async function atenderSenha(id_senha, id_profissional) {
  return executarAcao("SENHA_ATENDER", "FILA", {
    id_senha,
    id_profissional,
  });
}

/**
 * Cancelar senha
 * @param {number} id_senha - ID da senha
 * @param {string} motivo - Motivo do cancelamento
 * @returns {Promise<object>}
 */
export async function cancelarSenha(id_senha, motivo) {
  return executarAcao("CANCELAR_SENHA", "FILA", {
    id_senha,
    motivo,
  });
}

/**
 * Complementar senha (adicionar informações)
 * @param {number} id_senha - ID da senha
 * @param {object} dados - Dados complementares
 * @returns {Promise<object>}
 */
export async function complementarSenha(id_senha, dados) {
  return executarAcao("COMPLEMENTAR_SENHA", "FILA", {
    id_senha,
    ...dados,
  });
}

// ============================================
// AÇÕES DE TRIAGEM
// ============================================

/**
 * Classificar senha (Manchester)
 * @param {number} id_senha - ID da senha
 * @param {string} nivel_risco - Nível de risco (VERMELHO, LARANJA, AMARELO, VERDE, AZUL)
 * @param {object} dados_triagem - Dados da triagem
 * @returns {Promise<object>}
 */
export async function classificarSenha(id_senha, nivel_risco, dados_triagem = {}) {
  return executarAcao("TRIAGEM_CLASSIFICAR", "TRIAGEM", {
    id_senha,
    nivel_risco,
    ...dados_triagem,
  });
}

/**
 * Registrar triagem completa
 * @param {number} id_senha - ID da senha
 * @param {object} dados - Dados da triagem
 * @returns {Promise<object>}
 */
export async function registrarTriagem(id_senha, dados) {
  return executarAcao("TRIAGEM_REGISTRAR", "TRIAGEM", {
    id_senha,
    ...dados,
  });
}

// ============================================
// AÇÕES DE ATENDIMENTO
// ============================================

/**
 * Iniciar atendimento
 * @param {number} id_senha - ID da senha/atendimento
 * @param {number} id_profissional - ID do profissional
 * @returns {Promise<object>}
 */
export async function iniciarAtendimento(id_senha, id_profissional) {
  return executarAcao("ATENDIMENTO_INICIAR", "ATENDIMENTO", {
    id_senha,
    id_profissional,
  });
}

/**
 * Transicionar atendimento (mudar status)
 * @param {number} id_atendimento - ID do atendimento
 * @param {string} status - Novo status
 * @param {object} dados - Dados adicionais
 * @returns {Promise<object>}
 */
export async function transicionarAtendimento(id_atendimento, status, dados = {}) {
  return executarAcao("ATENDIMENTO_TRANSICIONAR", "ATENDIMENTO", {
    id_atendimento,
    status,
    ...dados,
  });
}

/**
 * Finalizar atendimento
 * @param {number} id_atendimento - ID do atendimento
 * @param {object} dados - Dados da finalização
 * @returns {Promise<object>}
 */
export async function finalizarAtendimento(id_atendimento, dados = {}) {
  return executarAcao("ATENDIMENTO_FINALIZAR", "ATENDIMENTO", {
    id_atendimento,
    ...dados,
  });
}

/**
 * Cancelar atendimento
 * @param {number} id_atendimento - ID do atendimento
 * @param {string} motivo - Motivo do cancelamento
 * @returns {Promise<object>}
 */
export async function cancelarAtendimento(id_atendimento, motivo) {
  return executarAcao("ATENDIMENTO_CANCELAR", "ATENDIMENTO", {
    id_atendimento,
    motivo,
  });
}

/**
 * Vincular paciente ao atendimento
 * @param {number} id_atendimento - ID do atendimento
 * @param {number} id_paciente - ID do paciente
 * @returns {Promise<object>}
 */
export async function vincularPaciente(id_atendimento, id_paciente) {
  return executarAcao("ATENDIMENTO_VINCULAR_PACIENTE", "ATENDIMENTO", {
    id_atendimento,
    id_paciente,
  });
}

// ============================================
// AÇÕES DE PACIENTE
// ============================================

/**
 * Atualizar dados do paciente
 * @param {number} id_paciente - ID do paciente
 * @param {object} dados - Dados a atualizar
 * @returns {Promise<object>}
 */
export async function atualizarPaciente(id_paciente, dados) {
  return executarAcao("PACIENTE_ATUALIZAR", "PACIENTE", {
    id_paciente,
    ...dados,
  });
}

// ============================================
// AÇÕES DE FARMÁCIA
// ============================================

/**
 * Dispensar medicamento
 * @param {number} id_prescricao - ID da prescrição
 * @param {number} id_paciente - ID do paciente
 * @param {object} dados - Dados da dispensação
 * @returns {Promise<object>}
 */
export async function dispensarMedicamento(id_prescricao, id_paciente, dados = {}) {
  return executarAcao("FARMACIA_DISPENSAR", "FARMACIA", {
    id_prescricao,
    id_paciente,
    ...dados,
  });
}

/**
 * Registrar administração de medicação
 * @param {number} id_prescricao - ID da prescrição
 * @param {number} id_medicamento - ID do medicamento
 * @param {object} dados - Dados da administração
 * @returns {Promise<object>}
 */
export async function registrarAdministracao(id_prescricao, id_medicamento, dados = {}) {
  return executarAcao("ADMINISTRACAO_MEDICACAO_REGISTRAR", "FARMACIA", {
    id_prescricao,
    id_medicamento,
    ...dados,
  });
}

/**
 * Criar ordem de medicação
 * @param {number} id_prescricao - ID da prescrição
 * @param {Array} medicamentos - Lista de medicamentos
 * @returns {Promise<object>}
 */
export async function criarOrdemMedicacao(id_prescricao, medicamentos) {
  return executarAcao("ADMINISTRACAO_MEDICACAO_ORDEM", "FARMACIA", {
    id_prescricao,
    medicamentos,
  });
}

// ============================================
// AÇÕES DE ENFERMAGEM
// ============================================

/**
 * Registrar procedimento de enfermagem
 * @param {number} id_atendimento - ID do atendimento
 * @param {string} tipo_procedimento - Tipo de procedimento
 * @param {object} dados - Dados do procedimento
 * @returns {Promise<object>}
 */
export async function registrarProcedimento(id_atendimento, tipo_procedimento, dados = {}) {
  return executarAcao("ENFERMAGEM_REGISTRAR", "ENFERMAGEM", {
    id_atendimento,
    tipo_procedimento,
    ...dados,
  });
}

// ============================================
// AÇÕES DE PRESCRIÇÃO
// ============================================

/**
 * Criar prescrição
 * @param {number} id_atendimento - ID do atendimento
 * @param {number} id_paciente - ID do paciente
 * @param {number} id_profissional - ID do profissional
 * @param {Array} itens - Itens da prescrição
 * @returns {Promise<object>}
 */
export async function criarPrescricao(id_atendimento, id_paciente, id_profissional, itens) {
  return executarAcao("PRESCRICAO_CRIAR", "PRESCRICAO", {
    id_atendimento,
    id_paciente,
    id_profissional,
    itens,
  });
}

// ============================================
// AÇÕES DE FFA (PRONTUÁRIO)
// ============================================

/**
 * Criar FFA/Prontuário
 * @param {number} id_atendimento - ID do atendimento
 * @param {number} id_paciente - ID do paciente
 * @returns {Promise<object>}
 */
export async function criarFFA(id_atendimento, id_paciente) {
  return executarAcao("FFA_CRIAR", "FFA", {
    id_atendimento,
    id_paciente,
  });
}

/**
 * Adicionar item na FFA
 * @param {number} id_ffa - ID da FFA
 * @param {string} tipo_item - Tipo do item
 * @param {object} dados - Dados do item
 * @returns {Promise<object>}
 */
export async function adicionarItemFFA(id_ffa, tipo_item, dados) {
  return executarAcao("FFA_ADICIONAR_ITEM", "FFA", {
    id_ffa,
    tipo_item,
    ...dados,
  });
}

// ============================================
// AÇÕES DE ALERTA
// ============================================

/**
 * Registrar alerta
 * @param {number} id_atendimento - ID do atendimento
 * @param {string} tipo_alerta - Tipo de alerta
 * @param {string} mensagem - Mensagem do alerta
 * @returns {Promise<object>}
 */
export async function registrarAlerta(id_atendimento, tipo_alerta, mensagem) {
  return executarAcao("REGISTRAR_ALERTA", "ALERTA", {
    id_atendimento,
    tipo_alerta,
    mensagem,
  });
}

// ============================================
// HEARTBEAT (Manter sessão ativa)
// ============================================

/**
 * Enviar heartbeat para manter sessão ativa
 * @returns {Promise<object>}
 */
export async function sessionHeartbeat() {
  return executarAcao("SESSION_HEARTBEAT", "SESSION", {});
}

export default {
  executarAcao,
  executarAcoesBatch,
  listarAcoesPermitidas,
  // Fila
  gerarSenhaTotem,
  criarSenha,
  chamarSenha,
  atenderSenha,
  cancelarSenha,
  complementarSenha,
  // Triagem
  classificarSenha,
  registrarTriagem,
  // Atendimento
  iniciarAtendimento,
  transicionarAtendimento,
  finalizarAtendimento,
  cancelarAtendimento,
  vincularPaciente,
  // Paciente
  atualizarPaciente,
  // Farmácia
  dispensarMedicamento,
  registrarAdministracao,
  criarOrdemMedicacao,
  // Enfermagem
  registrarProcedimento,
  // Prescrição
  criarPrescricao,
  // FFA
  criarFFA,
  adicionarItemFFA,
  // Alerta
  registrarAlerta,
  // Session
  sessionHeartbeat,
};
