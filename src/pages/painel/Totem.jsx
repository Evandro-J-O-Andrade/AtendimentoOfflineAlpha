import React, { useState } from 'react'
import api from '@/services/api'
import './Totem.css'

export default function Totem() {
  const [senha, setSenha] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [nota, setNota] = useState(5)
  const [comentario, setComentario] = useState('')
  const [showSurvey, setShowSurvey] = useState(false)

  async function gerarSenha(origem = 'TOTEM') {
    setLoading(true)
    setError(null)
    try {
      const res = await api.post('/senha_gerar.php', { origem })
      const s = res.data?.senha || res.data
      if (s) {
        setSenha(s)
        setShowSurvey(true)
      } else {
        setError('Resposta inesperada do servidor')
      }
    } catch (err) {
      setError(err?.response?.data?.message || err.message)
    } finally {
      setLoading(false)
    }
  }

  async function enviarFeedback() {
    try {
      await api.post('/totem_feedback_criar.php', { id_senha: senha.id_senha, origem: senha.origem, nota, comentario })
      setShowSurvey(false)
      setNota(5)
      setComentario('')
      alert('Obrigado pelo seu feedback!')
    } catch (err) {
      console.error(err)
      alert('Erro ao enviar feedback')
    }
  }

  return (
    <div className="totem-root">
      <h2>Totem</h2>
      <div className="buttons">
        <button onClick={() => gerarSenha('TOTEM')} disabled={loading}>Normal</button>
        <button onClick={() => gerarSenha('TOTEM_PRI_PEDI')} disabled={loading}>Prioritário - Pediatria</button>
        <button onClick={() => gerarSenha('TOTEM_PRI_ADULTO')} disabled={loading}>Prioritário - Adulto</button>
      </div>

      {error && <div className="error">{error}</div>}

      {senha && (
        <div className="senha-box">
          <div className="senha-title">Sua senha</div>
          <div className="senha-number">{senha.numero}</div>
          <div className="senha-origin">Origem: {senha.origem}</div>
        </div>
      )}

      {showSurvey && (
        <div className="survey">
          <h3>Pesquisa de satisfação</h3>
          <label>
            Nota: {nota}
            <input type="range" min="1" max="5" value={nota} onChange={(e) => setNota(Number(e.target.value))} />
          </label>
          <label>
            Comentário:
            <textarea value={comentario} onChange={(e) => setComentario(e.target.value)} />
          </label>
          <div className="survey-actions">
            <button onClick={enviarFeedback}>Enviar</button>
            <button onClick={() => setShowSurvey(false)}>Fechar</button>
          </div>
        </div>
      )}
    </div>
  )
}
