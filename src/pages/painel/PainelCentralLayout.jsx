import React, { useState, useEffect } from 'react';
import { useFFAs } from '../../shared/hooks/useFFAs';
import { useAlertasFFAs } from '../../shared/hooks/useAlertasFFAs';
import { useLocaisAtendimento } from '../../shared/hooks/useLocaisAtendimento';
import './PainelCentralLayout.css';

/**
 * Painel Central - Dashboard de Monitoramento em Tempo Real
 * Visualiza todas as FFAs em andamento, alertas críticos e estatísticas
 */
export function PainelCentralLayout() {
  const { ffas } = useFFAs();
  const { PRIORIDADES, ffasUrgentes, ffasExpiradas, countPorPrioridade, calcularTempoRestante } = useAlertasFFAs();
  const { LOCAIS, totaisPorLocal } = useLocalisAtendimento();

  const [filtroLocal, setFiltroLocal] = useState(null);

  // FFAs em andamento (excluindo finalizadas)
  const ffasAtivas = ffas.filter((f) => !['ALTA', 'FINALIZADO', 'TRANSFERENCIA'].includes(f.status));

  // FFAs filtradas por local
  const ffasFiltradas = filtroLocal ? ffasAtivas.filter((f) => f.local_atual === filtroLocal) : ffasAtivas;

  const temposRestantes = {};
  ffasAtivas.forEach((ffa) => {
    temposRestantes[ffa.id] = calcularTempoRestante(ffa);
  });

  const getCor = (classificacao) => PRIORIDADES[classificacao]?.cor || '#999';
  const getIcone = (classificacao) => PRIORIDADES[classificacao]?.icone || '⚪';

  return (
    <div className="painel-central-layout">
      {/* Header */}
      <div className="painel-header">
        <h1>📊 Painel Central de Monitoramento</h1>
        <p>Acompanhamento de Filas de Atendimento em Tempo Real</p>
      </div>

      {/* Stats Top */}
      <div className="stats-container">
        <div className="stat-box">
          <span className="stat-icone">📋</span>
          <div className="stat-content">
            <span className="stat-label">Pacientes Ativos</span>
            <span className="stat-valor">{ffasAtivas.length}</span>
          </div>
        </div>

        <div className="stat-box alertado">
          <span className="stat-icone">🔴</span>
          <div className="stat-content">
            <span className="stat-label">Expirados/Urgentes</span>
            <span className="stat-valor">{ffasExpiradas.length + ffasUrgentes.length}</span>
          </div>
        </div>

        <div className="stat-box">
          <span className="stat-icone">⏱️</span>
          <div className="stat-content">
            <span className="stat-label">Tempo Médio Espera</span>
            <span className="stat-valor">
              {ffasAtivas.length > 0
                ? Math.round(ffasAtivas.reduce((a, f) => a + (temposRestantes[f.id] || 0), 0) / ffasAtivas.length)
                : '--'}
              {' min'}
            </span>
          </div>
        </div>
      </div>

      {/* Prioridades Distribution */}
      <div className="prioridades-distribuicao">
        <h3>Distribuição por Prioridade</h3>
        <div className="prioridades-chart">
          {Object.entries(PRIORIDADES).map(([key, value]) => (
            <div key={key} className="prioridade-bar">
              <div className="prioridade-label">
                <span className="prioridade-icone">{value.icone}</span>
                <span>{value.label}</span>
              </div>
              <div className="prioridade-progress-container">
                <div
                  className="prioridade-progress"
                  style={{
                    width: `${(countPorPrioridade[key] / ffasAtivas.length) * 100}%`,
                    backgroundColor: value.cor,
                  }}
                >
                  {countPorPrioridade[key]}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Alertas Críticos */}
      {(ffasExpiradas.length > 0 || ffasUrgentes.length > 0) && (
        <div className="alertas-criticos">
          <h3>⚠️ Alertas Críticos</h3>
          <div className="alertas-lista">
            {ffasExpiradas.map((ffa) => (
              <div key={ffa.id} className="alerta-item alerta-expirado">
                <span className="alerta-icone">🔴</span>
                <span className="alerta-texto">
                  Paciente {ffa.id_paciente} - {ffa.gpat} - EXPIRADO
                </span>
              </div>
            ))}
            {ffasUrgentes.map((ffa) => (
              <div key={ffa.id} className="alerta-item alerta-urgente">
                <span className="alerta-icone">⚠️</span>
                <span className="alerta-texto">
                  Paciente {ffa.id_paciente} - Expira em {temposRestantes[ffa.id]} min
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Filas por Local */}
      <div className="filas-locais-container">
        <h3>Filas por Local</h3>
        <div className="locais-grid">
          {Object.entries(LOCAIS).map(([local, nome]) => (
            <button
              key={local}
              className={`local-btn ${filtroLocal === local ? 'ativo' : ''}`}
              onClick={() => setFiltroLocal(filtroLocal === local ? null : local)}
            >
              <span className="local-nome">{nome}</span>
              <span className="local-count">{totaisPorLocal[local]}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Tabela de FFAs */}
      <div className="ffas-tabela-container">
        <h3>{filtroLocal ? `Fila: ${LOCAIS[filtroLocal]}` : 'Todas as FFAs'}</h3>
        <div className="ffas-tabela">
          <div className="tabela-header">
            <div className="col col-pos">#</div>
            <div className="col col-pri">Prioridade</div>
            <div className="col col-gpat">GPAT</div>
            <div className="col col-pac">Paciente</div>
            <div className="col col-status">Status</div>
            <div className="col col-tempo">Tempo</div>
            <div className="col col-local">Local</div>
          </div>

          <div className="tabela-body">
            {ffasFiltradas.length === 0 ? (
              <div className="tabela-vazia">Nenhuma FFA neste local</div>
            ) : (
              ffasFiltradas.map((ffa, idx) => (
                <div
                  key={ffa.id}
                  className={`tabela-row ${temposRestantes[ffa.id] === 0 ? 'expirada' : ''}`}
                  style={{ borderLeftColor: getCor(ffa.classificacao_manchester) }}
                >
                  <div className="col col-pos">{idx + 1}</div>
                  <div className="col col-pri">
                    <span className="prioridade-badge" style={{ backgroundColor: getCor(ffa.classificacao_manchester) }}>
                      {getIcone(ffa.classificacao_manchester)}
                    </span>
                  </div>
                  <div className="col col-gpat">{ffa.gpat}</div>
                  <div className="col col-pac">Paciente {ffa.id_paciente}</div>
                  <div className="col col-status">{ffa.status}</div>
                  <div className="col col-tempo">
                    {temposRestantes[ffa.id] === 0 ? (
                      <span className="tempo-expirado">EXPIRADO</span>
                    ) : (
                      <span className="tempo-normal">{temposRestantes[ffa.id]} min</span>
                    )}
                  </div>
                  <div className="col col-local">{ffa.local_atual || '-'}</div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default PainelCentralLayout;
