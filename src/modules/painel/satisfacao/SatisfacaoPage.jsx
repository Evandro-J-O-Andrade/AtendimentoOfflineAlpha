import React from 'react'

export default function SatisfacaoPage() {
  return (
    <div className="container" style={{ maxWidth: 720 }}>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>Painel de satisfação</h2>
        <p style={{ opacity: 0.85 }}>
          Este painel é interativo (feedback do paciente). O backend deve registrar eventos em totem_feedback e auditar.
        </p>
        <div className="alert">TODO: implementar botões de avaliação e integração com sp_registrar_feedback_totem.</div>
      </div>
    </div>
  )
}
