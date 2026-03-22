import "./Timeline.css";

function formatarData(data) {
  if (!data) return "-";
  try {
    return new Date(data).toLocaleString("pt-BR");
  } catch {
    return data;
  }
}

function getEventoCor(tipo) {
  const valor = String(tipo || "").toUpperCase();
  if (valor.includes("TRIAGEM")) return "timeline-event-triagem";
  if (valor.includes("MEDICO") || valor.includes("ATENDIMENTO")) return "timeline-event-medico";
  if (valor.includes("LAB") || valor.includes("EXAME")) return "timeline-event-lab";
  return "timeline-event-default";
}

export default function Timeline({
  eventos = [],
  titulo = "Linha do Tempo do Atendimento",
  vazioMensagem = "Nenhum evento encontrado para este paciente."
}) {
  const lista = Array.isArray(eventos) ? eventos : [];

  return (
    <div className="timeline-container">
      <div className="timeline-header">
        <h3>{titulo}</h3>
        <span className="timeline-count">{lista.length} evento(s)</span>
      </div>

      {lista.length === 0 ? (
        <div className="timeline-empty">{vazioMensagem}</div>
      ) : (
        <div className="timeline-list">
          {lista.map((evento, index) => (
            <div
              key={`${evento.data || evento.data_evento || "evento"}-${index}`}
              className={`timeline-item ${getEventoCor(evento.tipo || evento.tipo_evento)}`}
            >
              <div className="timeline-marker" />
              <div className="timeline-content">
                <div className="timeline-topline">
                  <strong>{evento.tipo || evento.tipo_evento || "Evento"}</strong>
                  <span>{formatarData(evento.data || evento.data_evento)}</span>
                </div>

                <div className="timeline-description">
                  {evento.descricao || evento.detalhe || "Sem descrição disponível"}
                </div>

                {(evento.profissional_nome || evento.profissional || evento.usuario_nome) && (
                  <div className="timeline-profissional">
                    Profissional: {evento.profissional_nome || evento.profissional || evento.usuario_nome}
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
