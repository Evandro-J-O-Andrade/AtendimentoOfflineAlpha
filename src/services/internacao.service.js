import api from './api';

const inicializar = (payload) => api.post('/internacao/inicial.php', payload).then(r => r.data);
const alta = (payload) => api.post('/internacao/alta.php', payload).then(r => r.data);

export default { inicializar, alta };
