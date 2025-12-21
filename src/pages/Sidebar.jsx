import React, { useEffect, useState } from 'react';
import api from '../api/api';

export default function Sidebar() {
    const [fila, setFila] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        setLoading(true);
        api.get('/atendimento.php')
            .then(res => {
                const data = Array.isArray(res.data) ? res.data : [];
                setFila(data);
                setError(null);
            })
            .catch(err => {
                console.error(err);
                setFila([]);
                setError('Não foi possível carregar a fila.');
            })
            .finally(() => setLoading(false));
    }, []);

    return (
        <aside style={{ width: '300px', padding: '20px', background: '#f5f5f5' }}>
            <h3>Fila de Atendimento</h3>

            {loading && <p>Carregando...</p>}
            {error && <p style={{ color: 'red' }}>{error}</p>}
            {!loading && !error && fila.length === 0 && <p>Nenhum atendimento na fila.</p>}

            {!loading && !error && fila.map(p => (
                <div key={p.id_atendimento} style={{ marginBottom: '10px', padding: '5px', border: '1px solid #ddd', borderRadius: '5px' }}>
                    {p.nome_completo} ({p.status_atendimento})
                </div>
            ))}
        </aside>
    );
}
