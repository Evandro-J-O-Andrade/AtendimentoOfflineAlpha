const axios = require('axios');

const BASE = process.env.BASE_URL || 'http://localhost';
const LOGIN = process.env.TEST_LOGIN || 'recepcao1';
const SENHA = process.env.TEST_SENHA || 'Senha123!';

(async function () {
  try {
    console.log('Login...');
    const loginResp = await axios.post(`${BASE}/api/auth.php`, { login: LOGIN, senha: SENHA });
    console.log('Login result:', loginResp.data);

    const { token } = loginResp.data;
    if (!token) throw new Error('No token');

    // parse refresh cookie from set-cookie header
    const setCookie = loginResp.headers['set-cookie'] || [];
    const cookieHeader = setCookie.find(s => s.includes('refresh_token='));
    let refreshCookieValue = null;
    if (cookieHeader) {
      const m = cookieHeader.match(/refresh_token=([^;]+)/);
      if (m) refreshCookieValue = m[1];
    }

    console.log('Calling /api/auth/me.php');
    const me = await axios.get(`${BASE}/api/auth/me.php`, { headers: { Authorization: `Bearer ${token}` } });
    console.log('me:', me.data);

    console.log('Listing sessions (via cookie)...');
    const sessions = await axios.get(`${BASE}/api/auth/sessions.php`, { headers: { Cookie: `refresh_token=${refreshCookieValue}` } });
    console.log('sessions:', sessions.data);

    console.log('Refreshing token (via cookie)...');
    // send cookie header manually (Node does not use browser cookie jar here)
    const r = await axios.post(`${BASE}/api/auth/refresh.php`, {}, { headers: { Cookie: `refresh_token=${refreshCookieValue}` } });
    console.log('refresh:', r.data);

    console.log('Revogando todas as sessões (via cookie)...');
    const revokeAll = await axios.post(`${BASE}/api/auth/revoke_all.php`, {}, { headers: { Cookie: `refresh_token=${refreshCookieValue}` } });
    console.log('revoke_all:', revokeAll.data);

    console.log('Logout...');
    const logout = await axios.post(`${BASE}/api/auth/logout.php`, {}, { headers: { Cookie: `refresh_token=${refreshCookieValue}` } });
    console.log('logout:', logout.data);

    console.log('All good');
    process.exit(0);
  } catch (e) {
    console.error('ERROR', e.response?.data || e.message);
    process.exit(1);
  }
})();
