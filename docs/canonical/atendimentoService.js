import api from '../../../services/api';

/**
 * AtendimentoService - Camada de integração canônica.
 * Respeita a sequência: sessão -> senha -> atendimento.
 */
export const atendimentoService = {
    // Invoca sp_senha_chamar
    chamarPaciente: async (idSessao, idSenha) => {
        const response = await api.post('/fila/chamar', {
            p_id_sessao_usuario: idSessao,
            p_id_senha: idSenha
        });
        return response.data;
    },

    // Invoca sp_senha_nao_compareceu (Regra de Negócio: Registro de Chamada Não Atendida)
    registrarNaoComparecimento: async (idSessao, idSenha) => {
        const response = await api.post('/fila/nao-compareceu', {
            p_id_sessao_usuario: idSessao,
            p_id_senha: idSenha
        });
        return response.data;
    },

    // Invoca sp_atendimento_iniciar
    iniciarAtendimentoClinico: async (idSessao, idSenha, idPaciente) => {
        const response = await api.post('/atendimento/iniciar', {
            p_id_sessao_usuario: idSessao,
            p_id_senha: idSenha,
            p_id_paciente: idPaciente
        });
        return response.data;
    },

    // Invoca sp_atendimento_finalizar_evasao (Regra de Negócio: Evasão estrita)
    registrarEvasao: async (idSessao, idAtendimento) => {
        const response = await api.post('/atendimento/evasao', {
            p_id_sessao_usuario: idSessao,
            p_id_atendimento: idAtendimento
        });
        return response.data;
    },

    // Busca o status real da senha para a máquina de estados do frontend
    buscarStatusSenha: async (idSenha) => {
        const response = await api.get(`/senha/${idSenha}/status`);
        return response.data; // Retorna o campo 'status' da tabela senha
    }
};