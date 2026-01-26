import React, { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useContextoAtendimento } from './ContextoAtendimentoContext.jsx'

function uniqueBy(list, key) {
  const seen = new Set()
  return list.filter((x) => {
    const v = x[key]
    if (seen.has(v)) return false
    seen.add(v)
    return true
  })
}

export default function SelecionarContextoPage() {
  const { contextosDisponiveis, refreshContextos, selecionarContexto, errorMessage } = useContextoAtendimento()
  const [loading, setLoading] = useState(true)
  const [idSistema, setIdSistema] = useState('')
  const [idUnidade, setIdUnidade] = useState('')
  const [idLocal, setIdLocal] = useState('')
  const navigate = useNavigate()

  useEffect(() => {
    ;(async () => {
      setLoading(true)
      try {
        await refreshContextos()
      } finally {
        setLoading(false)
      }
    })()
  }, [])

  const sistemas = useMemo(() => uniqueBy(contextosDisponiveis, 'id_sistema'), [contextosDisponiveis])
  const unidades = useMemo(() => uniqueBy(contextosDisponiveis.filter((c) => String(c.id_sistema) === String(idSistema)), 'id_unidade'), [contextosDisponiveis, idSistema])
  const locais = useMemo(() => contextosDisponiveis.filter((c) => String(c.id_sistema) === String(idSistema) && String(c.id_unidade) === String(idUnidade)), [contextosDisponiveis, idSistema, idUnidade])

  const localSelecionado = useMemo(() => locais.find((c) => String(c.id_local) === String(idLocal)), [locais, idLocal])

  async function confirmar() {
    if (!localSelecionado) return
    await selecionarContexto(localSelecionado)
    // destino padrão por perfil
    const perfil = (localSelecionado.perfil || '').toUpperCase()
    if (perfil.includes('RECEP')) return navigate('/operacao/recepcao', { replace: true })
    return navigate('/operacao/recepcao', { replace: true })
  }

  return (
    <div className="container" style={{ maxWidth: 720 }}>
      <div className="card">
        <h2 style={{ marginTop: 0 }}>Selecionar contexto</h2>
        <p style={{ opacity: 0.85, marginTop: 0 }}>
          Selecione Sistema → Unidade → Local. Isso define permissões, fila e auditoria.
        </p>

        {errorMessage ? <div className="alert" style={{ marginBottom: 12 }}>{errorMessage}</div> : null}

        {loading ? (
          <div className="alert">Carregando contextos disponíveis...</div>
        ) : (
          <div className="grid">
            <label>
              Sistema
              <select className="input" value={idSistema} onChange={(e) => { setIdSistema(e.target.value); setIdUnidade(''); setIdLocal('') }}>
                <option value="">Selecione</option>
                {sistemas.map((s) => (
                  <option key={s.id_sistema} value={s.id_sistema}>{s.sistema || `Sistema #${s.id_sistema}`}</option>
                ))}
              </select>
            </label>

            <label>
              Unidade
              <select className="input" value={idUnidade} disabled={!idSistema} onChange={(e) => { setIdUnidade(e.target.value); setIdLocal('') }}>
                <option value="">Selecione</option>
                {unidades.map((u) => (
                  <option key={u.id_unidade} value={u.id_unidade}>{u.unidade || `Unidade #${u.id_unidade}`}</option>
                ))}
              </select>
            </label>

            <label>
              Local
              <select className="input" value={idLocal} disabled={!idUnidade} onChange={(e) => setIdLocal(e.target.value)}>
                <option value="">Selecione</option>
                {locais.map((l) => (
                  <option key={l.id_local} value={l.id_local}>{l.local || `Local #${l.id_local}`} {l.perfil ? `(${l.perfil})` : ''}</option>
                ))}
              </select>
            </label>

            <button className="btn" onClick={confirmar} disabled={!localSelecionado}>Entrar</button>
          </div>
        )}
      </div>
    </div>
  )
}
