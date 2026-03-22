/**
 * AssistencialService - Serviço para ações assistenciais
 *HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * Tipos de ações:
 * - request: Indicar intenção (ex: RX, exame) - persiste em FFA_pending/tmp
 * - post: Confirmar input / registrar - persiste em ffa, atendimento_solicitacao, atendimento_evento
 * - push: Persistir e propagar fluxo - atualiza ffa (status), atendimento_evento, estoque_movimento, faturamento_item
 */

import { executarOrquestradora } from '../api/spApi';

function normalizarNumero(valor) {
  if (valor === '' || valor === null || valor === undefined) return null;
  const numero = Number(valor);
  return Number.isNaN(numero) ? null : numero;
}

function montarPressaoArterial(sistolica, diastolica) {
  if (!sistolica || !diastolica) return null;
  return `${sistolica}/${diastolica}`;
}

/**
 * Indicar intenção/solicitação (request)
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} solicitacao - { tipo_solicitacao, urgente, observacao, id_ffa }
 * @returns {Promise<object>}
 */
export async function solicitar(id_sessao, solicitacao) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'request',
    payload: solicitacao
  });
}

/**
 * Confirmar input / registrar (post)
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dados - { id_ffa, tipo_solicitacao, detalhes }
 * @returns {Promise<object>}
 */
export async function registrar(id_sessao, dados) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'post',
    payload: dados
  });
}

/**
 * Persistir e propagar fluxo (push)
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} dados - { id_ffa, status, resultado }
 * @returns {Promise<object>}
 */
export async function propagarFluxo(id_sessao, dados) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'push',
    payload: dados
  });
}

/**
 * Salvar evolução do paciente
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} evolucao - Dados da evolução
 * @returns {Promise<object>}
 */
export async function salvarEvolucao(id_sessao, evolucao) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'SALVAR_EVOLUCAO',
    payload: evolucao
  });
}

/**
 * Salvar anamnese
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} anamnese - Dados da anamnese
 * @returns {Promise<object>}
 */
export async function salvarAnamnese(id_sessao, anamnese) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'SALVAR_ANAMNESE',
    payload: anamnese
  });
}

/**
 * Iniciar atendimento
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_ffa - ID do FFA
 * @returns {Promise<object>}
 */
export async function iniciarAtendimento(id_sessao, id_ffa) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'INICIAR_ATENDIMENTO',
    payload: { id_ffa }
  });
}

/**
 * Finalizar atendimento
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {number} id_ffa - ID do FFA
 * @returns {Promise<object>}
 */
export async function finalizarAtendimento(id_sessao, id_ffa) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'FINALIZAR_ATENDIMENTO',
    payload: { id_ffa }
  });
}

/**
 * Registrar prescrição
 * @param {number} id_sessao - ID da sessão do usuário
 * @param {object} prescricao - Dados da prescrição
 * @returns {Promise<object>}
 */
export async function registrarPrescricao(id_sessao, prescricao) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'REGISTRAR_PRESCRICAO',
    payload: prescricao
  });
}

/**
 * Inicia a triagem de um paciente/FFA.
 * Compatível com as transições identificadas no dump.
 * @param {number} id_sessao
 * @param {number} id_ffa
 * @returns {Promise<object>}
 */
export async function iniciarTriagem(id_sessao, id_ffa) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'TRIAGEM_INICIAR',
    payload: { id_ffa }
  });
}

/**
 * Salva os dados clínicos da triagem em payload compatível com o dump.
 * @param {number} id_sessao
 * @param {number} id_ffa
 * @param {object} dadosTriagem
 * @returns {Promise<object>}
 */
export async function salvarTriagem(id_sessao, id_ffa, dadosTriagem = {}) {
  const payload = {
    id_ffa,
    id_saas_entidade: dadosTriagem.id_saas_entidade ?? 1,
    id_unidade: dadosTriagem.id_unidade ?? null,
    peso: normalizarNumero(dadosTriagem.peso),
    altura: normalizarNumero(dadosTriagem.altura),
    pressao_arterial: montarPressaoArterial(dadosTriagem.pressao_sistolica, dadosTriagem.pressao_diastolica),
    frequencia_cardiaca: normalizarNumero(dadosTriagem.frecuencia_cardiaca ?? dadosTriagem.frequencia_cardiaca),
    frequencia_respiratoria: normalizarNumero(dadosTriagem.respiracao),
    temperatura: normalizarNumero(dadosTriagem.temperatura),
    saturacao: normalizarNumero(dadosTriagem.saturacao),
    hgt: normalizarNumero(dadosTriagem.hgt),
    queixa_principal: dadosTriagem.queixa_principal ?? '',
    prioridade_cor: dadosTriagem.prioridade_cor ?? dadosTriagem.classificacao_risco ?? null,
    classificacao_risco: dadosTriagem.classificacao_risco ?? null,
    escala_dor: normalizarNumero(dadosTriagem.escala_dor),
    observacao: dadosTriagem.observacao ?? dadosTriagem.observacoes_triagem ?? '',
    ip_origem: dadosTriagem.ip_origem ?? null,
    device_info: dadosTriagem.device_info ?? 'frontend-triagem'
  };

  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'TRIAGEM_SALVAR',
    payload
  });
}

/**
 * Finaliza a triagem com classificação e sinais essenciais.
 * @param {number} id_sessao
 * @param {number} id_ffa
 * @param {object} dadosTriagem
 * @returns {Promise<object>}
 */
export async function finalizarTriagem(id_sessao, id_ffa, dadosTriagem = {}) {
  return executarOrquestradora({
    id_sessao,
    modulo: 'ASSISTENCIAL',
    acao: 'TRIAGEM_FINALIZAR',
    payload: {
      id_ffa,
      temperatura: normalizarNumero(dadosTriagem.temperatura),
      pressao: montarPressaoArterial(dadosTriagem.pressao_sistolica, dadosTriagem.pressao_diastolica),
      classificacao_risco: dadosTriagem.classificacao_risco ?? null,
      prioridade_cor: dadosTriagem.prioridade_cor ?? null,
      observacao: dadosTriagem.observacao ?? dadosTriagem.observacoes_triagem ?? ''
    }
  });
}

export default {
  solicitar,
  registrar,
  propagarFluxo,
  salvarEvolucao,
  salvarAnamnese,
  iniciarAtendimento,
  finalizarAtendimento,
  registrarPrescricao,
  iniciarTriagem,
  salvarTriagem,
  finalizarTriagem
};
