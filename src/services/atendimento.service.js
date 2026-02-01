import api from './api';

const abrirRecepcao = (payload) => api.post('/atendimento/recepcao.php', payload).then(r => r.data);
const abrirAtendimento = (payload) => api.post('/atendimento/abrir.php', payload).then(r => r.data);
const finalizarAtendimento = (payload) => api.post('/atendimento/finalizar.php', payload).then(r => r.data);
const mudarLocal = (payload) => api.post('/atendimento/mudar_local.php', payload).then(r => r.data);
const buscarFicha = (id_atendimento) => api.get(`/paciente.php?id_atendimento=${id_atendimento}`).then(r => r.data);

export default {
  abrirRecepcao,
  abrirAtendimento,
  finalizarAtendimento,
  mudarLocal,
  buscarFicha,
};
