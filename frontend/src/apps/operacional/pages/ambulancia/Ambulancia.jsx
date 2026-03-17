import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import './Ambulancia.css';

const Ambulancia = () => {
  const navigate = useNavigate();
  const [viaturas, setViaturas] = useState([]);
  const [solicitacoes, setSolicitacoes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState(null);

  useEffect(() => {
    carregarDados();
  }, []);

  const carregarDados = async () => {
    try {
      setLoading(true);
      const token = localStorage.getItem('token');
      
      // Carregar viaturas
      const vtrResponse = await fetch('/api/operacional/viaturas', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const vtrData = await vtrResponse.json();
      setViaturas(vtrData?.dados || []);

      // Carregar solicitações de transporte
      const solResponse = await fetch('/api/operacional/transporte-ambulancia', {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      const solData = await solResponse.json();
      setSolicitacoes(solData?.dados || []);
      
      setErro(null);
    } catch (err) {
      setErro('Erro ao carregar dados: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const aceitarSolicitacao = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await fetch(`/api/operacional/transporte-ambulancia/${id}/aceitar`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
      });
      carregarDados();
    } catch (err) {
      alert('Erro ao aceitar solicitação');
    }
  };

  const finalizarTransporte = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await fetch(`/api/operacional/transporte-ambulancia/${id}/finalizar`, {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
      });
      carregarDados();
    } catch (err) {
      alert('Erro ao finalizar transporte');
    }
  };

  const getStatusBadge = (status) => {
    const statusMap = {
      'PENDENTE': { class: 'badge-pendente', text: 'Pendente' },
      'EM_TRANSITO': { class: 'badge-transito', text: 'Em Trânsito' },
      'CHEGANDO': { class: 'badge-chegando', text: 'Chegando' },
      'EM_ATENDIMENTO': { class: 'badge-atendimento', text: 'Em Atendimento' },
      'RETORNO': { class: 'badge-retorno', text: 'Retorno' },
      'FINALIZADO': { class: 'badge-finalizado', text: 'Finalizado' },
      'CANCELADO': { class: 'badge-cancelado', text: 'Cancelado' }
    };
    const s = statusMap[status] || { class: 'badge-default', text: status };
    return <span className={`badge ${s.class}`}>{s.text}</span>;
  };

  if (loading) {
    return (
      <div className="ambulancia-container">
        <div className="loading">Carregando...</div>
      </div>
    );
  }

  return (
    <div className="ambulancia-container">
      <header className="ambulancia-header">
        <h1>🚑 Ambulância / Transporte</h1>
        <button onClick={() => navigate('/operacional')} className="btn-voltar">
          ← Voltar
        </button>
      </header>

      {erro && <div className="erro-mensagem">{erro}</div>}

      <div className="ambulancia-content">
        {/* Painel de Viaturas */}
        <section className="panel">
          <h2>🚐 Viaturas</h2>
          <div className="viaturas-grid">
            {viaturas.map((vtr) => (
              <div key={vtr.id_viatura} className="viatura-card">
                <div className="viatura-info">
                  <h3>{vtr.placa}</h3>
                  <p>{vtr.modelo}</p>
                  <p>Status: {vtr.status}</p>
                </div>
                <div className="viatura-status">
                  {vtr.disponivel ? 
                    <span className="status-disponivel">Disponível</span> : 
                    <span className="status-ocupada">Ocupada</span>
                  }
                </div>
              </div>
            ))}
            {viaturas.length === 0 && (
              <p className="no-data">Nenhuma viatura cadastrada</p>
            )}
          </div>
        </section>

        {/* Solicitações de Transporte */}
        <section className="panel">
          <h2>📋 Solicitações de Transporte</h2>
          <table className="data-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Paciente</th>
                <th>Origem</th>
                <th>Destino</th>
                <th>Tipo</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
              {solicitacoes.map((sol) => (
                <tr key={sol.id}>
                  <td>{sol.id}</td>
                  <td>{sol.paciente_nome}</td>
                  <td>{sol.origem}</td>
                  <td>{sol.destino}</td>
                  <td>{sol.tipo_transporte}</td>
                  <td>{getStatusBadge(sol.status)}</td>
                  <td>
                    {sol.status === 'PENDENTE' && (
                      <button 
                        onClick={() => aceitarSolicitacao(sol.id)}
                        className="btn-acao btn-aceitar"
                      >
                        Aceitar
                      </button>
                    )}
                    {sol.status === 'EM_TRANSITO' && (
                      <button 
                        onClick={() => finalizarTransporte(sol.id)}
                        className="btn-acao btn-finalizar"
                      >
                        Finalizar
                      </button>
                    )}
                  </td>
                </tr>
              ))}
              {solicitacoes.length === 0 && (
                <tr>
                  <td colSpan="7" className="no-data">
                    Nenhuma solicitação pendente
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </section>

        {/* Registro de Ocorrências */}
        <section className="panel">
          <h2>📝 Registrar Ocorrência</h2>
          <form className="form-ocorrencia" onSubmit={(e) => {
            e.preventDefault();
            alert('Funcionalidade em desenvolvimento');
          }}>
            <div className="form-group">
              <label>Tipo de Ocorrência</label>
              <select>
                <option value="">Selecione...</option>
                <option value="SAIDA">Saída</option>
                <option value="CHEGADA_ORIGEM">Chegada na Origem</option>
                <option value="CHEGADA_DESTINO">Chegada no Destino</option>
                <option value="OCORRENCIA">Ocorrência</option>
              </select>
            </div>
            <div className="form-group">
              <label>Observação</label>
              <textarea rows="3" placeholder="Descreva a ocorrência..."></textarea>
            </div>
            <button type="submit" className="btn-submit">Registrar</button>
          </form>
        </section>
      </div>
    </div>
  );
};

export default Ambulancia;
