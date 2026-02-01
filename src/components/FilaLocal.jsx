import React, { useState, useEffect } from 'react';
import { useFFAs } from '../hooks/useFFAs';
import { useAlertasFFAs } from '../hooks/useAlertasFFAs';
import { useLocaisAtendimento } from '../hooks/useLocaisAtendimento';
import './FilaLocal.css';

/**
 * Componente FilaLocal
 * Exibe fila de pacientes por local com contagem regressiva de Manchester
 */
export function FilaLocal({ local }) {
  const { filaLocal, ffaSelecionada, selecionarFFa } = useFFAs();
  const { PRIORIDADES, calcularTempoRestante } = useAlertasFFAs();
  const { LOCAIS } = useLocaisAtendimento();

  const fila = filaLocal(local);
  const [tempos, setTempos] = useState({});

  // Atualiza tempos a cada segundo
  useEffect(() => {
    const interval = setInterval(() => {
      const novoTempos = {};
      fila.forEach((ffa) => {
        novoTempos[ffa.id] = calcularTempoRestante(ffa);
      });
      setTempos(novoTempos);
    }, 1000);
    return () => clearInterval(interval);
  }, [fila, calcularTempoRestante]);

  const formatarTempo = (minutos) => {
    if (minutos === null) return 'N/A';
    if (minutos === 0) return '⏰ EXPIRADO';
    if (minutos < 1) return '< 1 min';
    return `${minutos} min`;
  };

  const formatarMinutosSegundos = (minutos) => {
    if (minutos === null || minutos < 0) return '--:--';
    const m = Math.floor(minutos);
    const s = Math.floor((minutos - m) * 60);
    return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  };

  const getCor = (classificacao) => {
    return PRIORIDADES[classificacao]?.cor || '#999';
  };

  const getIcone = (classificacao) => {
    return PRIORIDADES[classificacao]?.icone || '⚪';
  };

  return (
    <div className="fila-local">
      <div className="fila-header">
        <h2>{LOCAIS[local] || local}</h2>
        <span className="fila-count">{fila.length} pacientes</span>
      </div>

      <div className="fila-lista">
        {fila.length === 0 ? (
          <div className="fila-vazia">
            <p>Nenhum paciente em espera</p>
          </div>
        ) : (
          fila.map((ffa, idx) => (
            <div
              key={ffa.id}
              className={`fila-item ${ffaSelecionada?.id === ffa.id ? 'selecionada' : ''}`}
              style={{ borderLeftColor: getCor(ffa.classificacao_manchester) }}
              onClick={() => selecionarFFa(ffa)}
            >
              <div className="fila-item-posicao">#{idx + 1}</div>

              <div className="fila-item-info">
                <div className="fila-item-paciente">
                  <span className="prioridade-icone">{getIcone(ffa.classificacao_manchester)}</span>
                  <strong>Paciente {ffa.id_paciente}</strong>
                </div>
                <div className="fila-item-detalhes">
                  <span className="gpat">{ffa.gpat}</span>
                  <span className="status">{ffa.status}</span>
                </div>
              </div>

              <div className="fila-item-tempo">
                <div className="tempo-restante">
                  {tempos[ffa.id] === 0 ? (
                    <span className="tempo-expirado">EXPIRADO</span>
                  ) : (
                    <>
                      <span className="tempo-minutos">{formatarMinutosSegundos(tempos[ffa.id])}</span>
                      <span className="tempo-label">
                        {PRIORIDADES[ffa.classificacao_manchester]?.urgencia}
                      </span>
                    </>
                  )}
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default FilaLocal;
