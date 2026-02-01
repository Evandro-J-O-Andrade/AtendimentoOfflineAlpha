import api from './api';

const proximoPaciente = () => api.get('/fila/geral.php').then(r => r.data);
const chamar = (payload) => api.post('/fila/chamar.php', payload).then(r => r.data);

export default { proximoPaciente, chamar };
