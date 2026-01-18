import React, { useEffect, useState } from 'react';
import api from '@/services/api';
import './SelectLocalModal.css';

export default function SelectLocalModal({ open, onClose, onSelect, usuario }) {
  const [locais, setLocais] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState('');

  useEffect(() => {
    if (!open || !usuario) return;

    setLoading(true);
    api.get('/local_usuario_listar.php')
      .then(res => {
        let data = Array.isArray(res.data) ? res.data : [];

        if (usuario.perfis.includes('MEDICO')) data = data.filter(l => l.tipo === 'MEDICO' && l.ativo === 1);
        else if (usuario.perfis.includes('RECEPCAO')) data = data.filter(l => l.tipo === 'RECEPCAO' && l.ativo === 1);
        else if (usuario.perfis.includes('ENFERMAGEM')) data = data.filter(l => l.tipo === 'ENFERMAGEM' && l.ativo === 1);

        setLocais(data);
      })
      .catch(() => setLocais([]))
      .finally(() => setLoading(false));
  }, [open, usuario]);

  useEffect(() => { if (!open) setSelected(''); }, [open]);

  if (!open) return null;

  return (
    <div className="select-local-modal-overlay">
      <div className="select-local-modal">
        <h3>Escolha seu local de atendimento</h3>
        <div className="usuario-info">
          <strong>Usuário:</strong> {usuario?.nome_completo}<br/>
          <strong>Perfil:</strong> {usuario?.perfis?.join(', ')}
        </div>

        {loading ? <div>Carregando locais...</div> :
          <select value={selected} onChange={e => setSelected(e.target.value)}>
            <option value="">-- selecione --</option>
            {locais.map(l => (
              <option key={l.id_local_usuario} value={JSON.stringify(l)}>
                {l.nome} {l.sala ? `- Sala: ${l.sala}` : ''}
              </option>
            ))}
          </select>
        }

        <div className="actions">
          <button onClick={() => selected && onSelect(JSON.parse(selected))}>Selecionar</button>
          <button onClick={onClose}>Fechar</button>
        </div>
      </div>
    </div>
  );
}
