import React, { useEffect, useState } from 'react';
import api from '../services/api';

export default function SelectLocalModal({ open, onClose, onSelect, tipoUsuario }) {
  const [locais, setLocais] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState('');

  useEffect(() => {
    if (!open) return;

    setLoading(true);
    api.get('/local_usuario_listar.php')  // endpoint que retorna todos os locais
      .then(res => {
        const data = Array.isArray(res.data) ? res.data : [];
        // Filtra pelo tipo do usuário
        setLocais(data.filter(l => l.tipo === tipoUsuario && l.ativo === 1));
      })
      .catch(err => {
        console.error('Erro ao carregar locais', err);
        setLocais([]);
      })
      .finally(() => setLoading(false));
  }, [open, tipoUsuario]);

  useEffect(() => {
    if (!open) setSelected('');
  }, [open]);

  if (!open) return null;

  return (
    <div className="select-local-modal-overlay">
      <div className="select-local-modal">
        <h3>Escolha seu local de atendimento</h3>
        {loading ? (
          <div>Carregando locais...</div>
        ) : (
          <select value={selected} onChange={e => setSelected(e.target.value)}>
            <option value="">-- selecione --</option>
            {locais.map(l => (
              <option key={l.id_local_usuario} value={JSON.stringify(l)}>
                {l.nome}
              </option>
            ))}
          </select>
        )}

        <div style={{ marginTop: 12, display: 'flex', gap: 8 }}>
          <button onClick={() => selected && onSelect(JSON.parse(selected))}>Selecionar</button>
          <button onClick={onClose}>Fechar</button>
        </div>
      </div>
    </div>
  );
}
