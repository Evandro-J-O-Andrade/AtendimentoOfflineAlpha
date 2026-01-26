import React, { useMemo, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { apiErrorMessage } from '../../../shared/api/http.js'
import { complementarAtendimento, encaminharAtendimento } from './recepcaoApi.js'

const DESTINOS = [
  { value: 'TRIAGEM', label: 'Triagem' },
  { value: 'RX_EXTERNO', label: 'RX Externo' },
  { value: 'MEDICACAO_EXTERNA', label: 'Medicação Externa' },
  { value: 'MEDICO_DIRETO', label: 'Médico Direto' },
  { value: 'EMERGENCIA', label: 'Emergência' }
]

export default function RecepcaoComplementoPage() {
  const { idSenha } = useParams()
  const navigate = useNavigate()

  const [salvando, setSalvando] = useState(false)
  const [encaminhando, setEncaminhando] = useState(false)
  const [error, setError] = useState(null)

  const [form, setForm] = useState({
    nome_completo: '',
    data_nascimento: '', // opcional (quando existir no banco)
    telefone: '',
    sexo: '',
    prioridade_social: 'PADRAO'
  })

  const [ffaId, setFfaId] = useState(null)
  const [destino, setDestino] = useState('TRIAGEM')

  const idadeAproximada = useMemo(() => {
    if (!form.data_nascimento) return null
    const d = new Date(form.data_nascimento)
    if (Number.isNaN(d.getTime())) return null
    const now = new Date()
    let years = now.getFullYear() - d.getFullYear()
    const m = now.getMonth() - d.getMonth()
    if (m < 0 || (m === 0 && now.getDate() < d.getDate())) years--
    return years
  }, [form.data_nascimento])

  async function salvarComplemento() {
    setError(null)
    setSalvando(true)
    try {
      const res = await complementarAtendimento({
        id_senha: Number(idSenha),
        ...form
      })
      const id = res.id_ffa || res.ffa_id || res.id
      setFfaId(id || true)
    } catch (e) {
      setError(e)
    } finally {
      setSalvando(false)
    }
  }

  async function encaminhar() {
    setError(null)
    setEncaminhando(true)
    try {
      await encaminharAtendimento({
        id_senha: Number(idSenha),
        destino
      })
      navigate('/operacao/recepcao', { replace: true })
    } catch (e) {
      setError(e)
    } finally {
      setEncaminhando(false)
    }
  }

  return (
    <div className="container" style={{ maxWidth: 900 }}>
      <div className="row" style={{ justifyContent: 'space-between' }}>
        <div>
          <h2 style={{ margin: 0 }}>Complementar atendimento</h2>
          <div style={{ opacity: 0.85, fontSize: 13 }}>Senha #{idSenha}</div>
        </div>
        <div className="row">
          <button className="btn" onClick={() => navigate('/operacao/recepcao')}>Voltar</button>
        </div>
      </div>

      {error ? <div className="alert" style={{ marginTop: 12 }}>{apiErrorMessage(error)}</div> : null}

      <div className="grid" style={{ gridTemplateColumns: '1fr 1fr', marginTop: 12 }}>
        <div className="card">
          <h3 style={{ marginTop: 0 }}>Dados do paciente (cria/atualiza Pessoa → Paciente → FFA)</h3>
          <div className="grid">
            <label>
              Nome completo
              <input className="input" value={form.nome_completo} onChange={(e) => setForm({ ...form, nome_completo: e.target.value })} />
            </label>

            <label>
              Data de nascimento (opcional)
              <input className="input" type="date" value={form.data_nascimento} onChange={(e) => setForm({ ...form, data_nascimento: e.target.value })} />
              {idadeAproximada !== null ? <div style={{ opacity: 0.8, fontSize: 12, marginTop: 4 }}>Idade aprox.: {idadeAproximada} anos</div> : null}
            </label>

            <label>
              Telefone
              <input className="input" value={form.telefone} onChange={(e) => setForm({ ...form, telefone: e.target.value })} />
            </label>

            <label>
              Prioridade social (recepção)
              <select className="input" value={form.prioridade_social} onChange={(e) => setForm({ ...form, prioridade_social: e.target.value })}>
                <option value="PADRAO">Padrão</option>
                <option value="IDOSO">Idoso</option>
                <option value="CRONICO">Crônico</option>
              </select>
            </label>

            <button className="btn" onClick={salvarComplemento} disabled={salvando || !form.nome_completo}>
              {salvando ? 'Salvando...' : 'Salvar / Abrir FFA'}
            </button>

            {ffaId ? <div className="alert">FFA vinculada com sucesso. Agora você pode encaminhar.</div> : null}
          </div>
        </div>

        <div className="card">
          <h3 style={{ marginTop: 0 }}>Encaminhar</h3>
          <p style={{ opacity: 0.85, marginTop: 0 }}>
            Encaminhar cria a entrada na fila do setor (triagem/RX/med/médico/emergência). A chamada no setor continua manual.
          </p>

          <label>
            Destino
            <select className="input" value={destino} onChange={(e) => setDestino(e.target.value)}>
              {DESTINOS.map((d) => (
                <option key={d.value} value={d.value}>{d.label}</option>
              ))}
            </select>
          </label>

          <div className="row" style={{ marginTop: 12 }}>
            <button className="btn" onClick={encaminhar} disabled={!ffaId || encaminhando}>
              {encaminhando ? 'Encaminhando...' : 'Encaminhar'}
            </button>
          </div>

          {!ffaId ? <div style={{ opacity: 0.75, fontSize: 12, marginTop: 10 }}>Para encaminhar, primeiro salve o complemento (abra FFA).</div> : null}
        </div>
      </div>
    </div>
  )
}
