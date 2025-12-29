import React, { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import api from '../../services/api';
import { useAuth } from '../../context/AuthContext';

export default function Sessions() {
  const { user, tokenPayload, isAdmin, signOut } = useAuth();
  const location = useLocation();
  const [sessions, setSessions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [targetUserId, setTargetUserId] = useState('');

  const load = async (userId = null) => {
    setLoading(true);
    try {
      const q = userId ? `?user_id=${encodeURIComponent(userId)}` : '';
      const res = await api.get(`/auth/sessions.php${q}`);
      setSessions(res.data);
    } catch (e) {
      console.error(e);
      alert(e.response?.data?.message || e.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const uid = params.get('user_id');
    if (uid) {
      setTargetUserId(uid);
      load(uid);
    } else {
      load();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [location.search]);

  const revoke = async (id) => {
    try {
      await api.post('/auth/revoke_session.php', { id_refresh: id });
      // se revoke é a sessão atual, deslogar
      if (tokenPayload?.sid && tokenPayload.sid === id) {
        alert('Você revogou a sessão atual. Você será deslogado.');
        signOut();
        return;
      }
      await load();
    } catch (e) {
      alert(e.response?.data?.message || 'Erro ao revogar sessão');
    }
  };

  const revokeAll = async () => {
    if (!window.confirm('Revogar todas as sessões ativas para este usuário?')) return;
    try {
      await api.post('/auth/revoke_all.php', {});
      // se revogou as próprias sessões, deslogar
      alert('Todas as sessões revogadas. Você será deslogado.');
      signOut();
    } catch (e) {
      alert(e.response?.data?.message || 'Erro ao revogar sessões');
    }
  };

  const viewOther = async () => {
    if (!targetUserId) return;
    await load(targetUserId);
  };

  return (
    <div className="sessions-page">
      <h2>Sessões ativas</h2>
      <p>Usuário: <strong>{user?.nome || user?.login}</strong></p>

      {isAdmin() && (
        <div style={{ marginBottom: 12 }}>
          <label>Ver sessões de outro usuário (ID): </label>
          <input value={targetUserId} onChange={e => setTargetUserId(e.target.value)} />
          <button onClick={viewOther}>Ver</button>
          <button onClick={() => { setTargetUserId(''); load(); }}>Voltar</button>
        </div>
      )}

      <div style={{ marginBottom: 12 }}>
        <button onClick={() => load()}>Atualizar</button>
        <button onClick={revokeAll} style={{ marginLeft: 8 }}>Revogar todas as sessões</button>
      </div>

      {loading ? (
        <p>Carregando...</p>
      ) : (
        <table border="1" cellPadding="6">
          <thead>
            <tr>
              <th>ID</th>
              <th>Dispositivo</th>
              <th>IP</th>
              <th>Criado</th>
              <th>Expira</th>
              <th>Revogado</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
            {sessions.map(s => (
              <tr key={s.id_refresh} style={{ background: s.current ? '#e6ffea' : undefined }}>
                <td>{s.id_refresh}{s.current ? ' (este dispositivo)' : ''}</td>
                <td>{s.user_agent || '—'}</td>
                <td>{s.ip || '—'}</td>
                <td>{s.created_at}</td>
                <td>{s.expires_at}</td>
                <td>{s.revoked ? 'Sim' : 'Não'}</td>
                <td>
                  {!s.revoked && <button onClick={() => revoke(s.id_refresh)}>Revogar</button>}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
