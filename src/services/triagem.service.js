import api from './api';

const registrarTriagem = (payload) => api.post('/triagem/registrar.php', payload).then(r => r.data);

export default { registrarTriagem };
