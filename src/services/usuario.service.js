import api from './api';

const login = (payload) => api.post('/usuario/login.php', payload).then(r => r.data);
const listar = () => api.get('/usuario/listar.php').then(r => r.data);
const criar = (payload) => api.post('/usuario/criar.php', payload).then(r => r.data);
const atualizar = (payload) => api.post('/usuario/atualizar.php', payload).then(r => r.data);
const me = () => api.get('/auth/me.php').then(r => r.data);
const logout = () => api.post('/auth/logout.php').then(r => r.data);

export default { login, listar, criar, atualizar, me, logout };
