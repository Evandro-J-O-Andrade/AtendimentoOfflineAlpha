import React, { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { obterFilaRecepcao, chamarSenha, gerarSenhaSamu } from './recepcaoApi.js'
import { apiErrorMessage } from '../../../shared/api/http.js'
import { laneCssByTipo } from '../../../shared/constants/lanes.js'
import { useContextoAtendimento } from '../../../features/contexto/ContextoAtendimentoContext.jsx'

function groupLane(tipo) {
  const t = (tipo || '').toUpperCase()
  if (t === 'PEDIATRICO') return 'PEDIATRICO'
  if (t === 'CLINICO') return 'CLINICO'
  return 'PRIORIDADE' // PRIORITARIO/EMERGENCIA/outros
}

function laneTitle(group) {
  if (group === 'CLINICO') return 'Clínico / Adulto'
  if (group === 'PEDIATRICO') return 'Pediátrico'
  return 'Prioridade / Emergência'
}

function laneCss(group) {
  if (group === 'CLINICO') return 'azul'
  if (group === 'PEDIATRICO') return 'amarelo'
  return 'laranja'
}

export default function RecepcaoFilaPage() {
  const { contexto, limparContexto } = useContextoAtendimento()
  const [itens, setItens] = useState([])
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(true)
  const [guiche, setGuiche] = useState('GUICHE-1')
  const [busyId, setBusyId] = useState(null)

  async function refresh() {
    setError(null)
    const list = await obterFilaRecepcao()
    setItens(Array.isArray(list) ? list : [])
  }

  useEffect(() => {
    let timer = null
    ;(async () => {
      setLoading(true)
      try {
        await refresh()
      } catch (e) {
        setError(e)
      } finally {
        setLoading(false)
      }
      timer = setInterval(() => {
        refresh().catch(() => {})
      }, 3000)
    })()

    return () => {
      if (timer) clearInterval(timer)
    }
  }, [])

  const lanes = useMemo(() => {
    const groups = { CLINICO: [], PEDIATRICO: [], PRIORIDADE: [] }
    for (const item of itens) {
      groups[groupLane(item.tipo_atendimento || item.tipo || item.tipoSenha)].push(item)
    }
    return groups
  }, [itens])

  async function onChamar(item) {
    setBusyId(item.id_senha || item.id)
    try {
      await chamarSenha({ id_senha: item.id_senha || item.id, guiche })
      await refresh()
    } catch (e) {
      setError(e)
    } finally {
      setBusyId(null)
    }
  }

  async function onSamu() {
    setBusyId('SAMU')
    try {
      await gerarSenhaSamu()
      await refresh()
    } catch (e) {
      setError(e)
    } finally {
      setBusyId(null)
    }
  }

  return (
    <div className="container">
      <div className="row" style={{ justifyContent: 'space-between' }}>
        <div>
          <h2 style={{ margin: 0 }}>Recepção</h2>
          <div style={{ opacity: 0.85, fontSize: 13 }}>
            Contexto: {contexto?.sistema || contexto?.id_sistema} / {contexto?.unidade || contexto?.id_unidade} / {contexto?.local || contexto?.id_local}
          </div>
        </div>
        <div className="row">
          <select className="input" style={{ width: 180 }} value={guiche} onChange={(e) => setGuiche(e.target.value)}>
            <option value="GUICHE-1">GUICHE-1</option>
            <option value="GUICHE-2">GUICHE-2</option>
            <option value="SALA-1">SALA-1</option>
          </select>
          <button className="btn" onClick={onSamu} disabled={busyId === 'SAMU'}>
            {busyId === 'SAMU' ? 'Gerando SAMU...' : 'SAMU'}
          </button>
          <button className="btn" onClick={limparContexto}>Trocar contexto</button>
        </div>
      </div>

      {error ? <div className="alert" style={{ marginTop: 12 }}>{apiErrorMessage(error)}</div> : null}
      {loading ? <div className="alert" style={{ marginTop: 12 }}>Carregando fila...</div> : null}

      <div className="grid" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', marginTop: 12 }}>
        {['CLINICO', 'PEDIATRICO', 'PRIORIDADE'].map((g) => (
          <div key={g} className={`lane lane--${laneCss(g)}`}>
            <h3>{laneTitle(g)} <span className="badge" style={{ marginLeft: 8 }}>{lanes[g].length}</span></h3>
            <div className="laneBody grid">
              {lanes[g].length === 0 ? (
                <div style={{ opacity: 0.7 }}>Sem senhas.</div>
              ) : lanes[g].map((item) => {
                const id = item.id_senha || item.id
                const tipo = (item.tipo_atendimento || item.tipo || '').toUpperCase()
                const css = laneCssByTipo(tipo)
                return (
                  <div key={id} className="card" style={{ padding: 12 }}>
                    <div className="row" style={{ justifyContent: 'space-between' }}>
                      <div>
                        <div style={{ fontSize: 18, fontWeight: 700 }}>
                          {(item.prefixo || '').toUpperCase()}{item.numero ?? item.numero_senha ?? ''}
                        </div>
                        <div style={{ opacity: 0.8, fontSize: 12 }}>
                          {tipo || 'CLINICO'} • {item.status || item.status_senha || 'EM_FILA'}
                        </div>
                      </div>
                      <span className="badge">{css.toUpperCase()}</span>
                    </div>

                    <div className="row" style={{ marginTop: 10, justifyContent: 'space-between' }}>
                      <button className="btn" onClick={() => onChamar(item)} disabled={busyId === id}>
                        {busyId === id ? 'Chamando...' : 'Chamar'}
                      </button>
                      <Link className="btn" to={`/operacao/recepcao/complemento/${id}`} style={{ textDecoration: 'none', textAlign: 'center' }}>
                        Complementar
                      </Link>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
