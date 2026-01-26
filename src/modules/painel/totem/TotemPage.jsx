import React, { useEffect, useState } from 'react'
import { apiErrorMessage } from '../../../shared/api/http.js'
import { gerarSenhaTotem, obterPlantaoTotem } from './totemApi.js'

function formatSenha(s) {
  if (!s) return ''
  const p = (s.prefixo || '').toUpperCase()
  const n = s.numero ?? ''
  return `${p}${n}`
}

export default function TotemPage() {
  const [medicos, setMedicos] = useState([])
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(null)
  const [ultimo, setUltimo] = useState(null)
  const [error, setError] = useState(null)

  async function refreshPlantao() {
    const list = await obterPlantaoTotem()
    setMedicos(Array.isArray(list) ? list : [])
  }

  useEffect(() => {
    let timer = null
    ;(async () => {
      setLoading(true)
      try {
        await refreshPlantao()
      } catch (e) {
        setError(e)
      } finally {
        setLoading(false)
      }
      timer = setInterval(() => {
        refreshPlantao().catch(() => {})
      }, 15000)
    })()

    return () => {
      if (timer) clearInterval(timer)
    }
  }, [])

  async function gerar(tipo) {
    setError(null)
    setBusy(tipo)
    try {
      const res = await gerarSenhaTotem(tipo)
      setUltimo(res)
    } catch (e) {
      setError(e)
    } finally {
      setBusy(null)
    }
  }

  return (
    <div className="container" style={{ maxWidth: 920 }}>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>TOTEM</h2>

        <div className="alert" style={{ marginBottom: 12 }}>
          <div style={{ fontWeight: 700, marginBottom: 6 }}>Médicos de plantão (informativo)</div>
          {loading ? (
            <div>Carregando...</div>
          ) : medicos.length === 0 ? (
            <div style={{ opacity: 0.85 }}>Nenhum plantão ativo informado.</div>
          ) : (
            <div className="row" style={{ flexWrap: 'wrap' }}>
              {medicos.map((m, idx) => (
                <span key={idx} className="badge">{m.nome || m.nome_medico} {m.tipo ? `(${m.tipo})` : ''}</span>
              ))}
            </div>
          )}
        </div>

        {error ? <div className="alert" style={{ marginBottom: 12 }}>{apiErrorMessage(error)}</div> : null}

        <div className="grid" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))' }}>
          <button className="btn" style={{ padding: 20, fontSize: 18 }} onClick={() => gerar('CLINICO')} disabled={busy !== null}>
            {busy === 'CLINICO' ? 'Gerando...' : 'Senha Adulto (Clínico)'}
          </button>
          <button className="btn" style={{ padding: 20, fontSize: 18 }} onClick={() => gerar('PEDIATRICO')} disabled={busy !== null}>
            {busy === 'PEDIATRICO' ? 'Gerando...' : 'Senha Pediátrico'}
          </button>
          <button className="btn" style={{ padding: 20, fontSize: 18 }} onClick={() => gerar('PRIORITARIO')} disabled={busy !== null}>
            {busy === 'PRIORITARIO' ? 'Gerando...' : 'Senha Prioridade'}
          </button>
        </div>

        {ultimo ? (
          <div className="alert" style={{ marginTop: 12 }}>
            <div style={{ fontWeight: 700 }}>Última senha gerada: {formatSenha(ultimo)}</div>
            <div style={{ opacity: 0.85, fontSize: 13 }}>Levar o comprovante até a recepção.</div>
          </div>
        ) : null}
      </div>
    </div>
  )
}
