import api from './api';

const gerarSenha = (origem = 'TOTEM') => api.post('/senha/gerar.php', { origem }).then(r => r.data);

export default {
  gerarSenha,
};
