import { useMemo } from 'react'
import { useTotemSenha } from '../../core/hooks/useTotemSenha'
import { useTotemAuth } from '../../core/hooks/useTotemAuth'
import type { TotemOpcao } from '@atendimentooffline/contracts'
import { totemConfig } from '../../app/config'
import '../../styles/totem.css'

function dataExtenso(): string {
  const now = new Date()
  return now.toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
    weekday: 'long'
  })
}

export default function TotemSenha() {
  const { sessao, login, loading: authLoading, erro: authErro } = useTotemAuth({
    apiUrl: totemConfig.apiUrl
  })

  const { plantao, loading, mensagem, erro, grupos, gerarSenha } = useTotemSenha({
    apiUrl: totemConfig.apiUrl,
    id_unidade: totemConfig.id_unidade,
    id_local_operacional: totemConfig.id_local_operacional,
    id_sessao: sessao?.id_sessao_usuario ?? null
  })

  const renderBotoes = useMemo(() => {
    return (lista: TotemOpcao[], classe: string) =>
      lista.map((opcao) => (
        <button
          key={opcao.id_opcao}
          type="button"
          className={`totem-btn ${classe}`}
          onClick={() => gerarSenha(opcao.id_opcao, opcao.label)}
          disabled={loading}
        >
          {String(opcao.label || 'GERAR SENHA').toUpperCase()}
        </button>
      ))
  }, [loading, gerarSenha])

  if (!sessao) {
    return (
      <div className="totem-page">
        <section className="totem-head">
          <div className="totem-head-title">
            <h1>PREFEITURA DO MUNICIPIO DE POA - SP</h1>
            <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
          </div>
        </section>

        <section className="totem-main">
          <h3>AUTENTICACAO DO TOTEM</h3>
          <form
            className="totem-login-form"
            onSubmit={(e) => {
              e.preventDefault()
              const form = e.target as HTMLFormElement
              const username = (form.elements.namedItem('username') as HTMLInputElement).value
              const password = (form.elements.namedItem('password') as HTMLInputElement).value
              login(username, password)
            }}
          >
            <input name="username" placeholder="Usuario" autoComplete="username" />
            <input name="password" type="password" placeholder="Senha" autoComplete="current-password" />
            <button type="submit" className="totem-btn btn-normal" disabled={authLoading}>
              ENTRAR
            </button>
            {authErro && <div className="totem-msg err">{authErro}</div>}
          </form>
        </section>
      </div>
    )
  }

  return (
    <div className="totem-page">
      <section className="totem-head">
        <div className="totem-head-logos">
          <img src="/assets/img/prefeitura.png" alt="Prefeitura" />
        </div>
        <div className="totem-head-title">
          <h1>PREFEITURA DO MUNICIPIO DE POA - SP</h1>
          <h2>PRONTO ATENDIMENTO DR GUIDO GUIDA</h2>
          <p>{dataExtenso()}</p>
        </div>
        <div className="totem-head-alpha">
          <img src="/assets/img/sistema.png" alt="Alpha" />
        </div>
      </section>

      <section className="totem-plantao">
        {plantao.length === 0 && <div className="totem-plantao-empty">Sem escala medica do dia.</div>}
        {plantao.map((item, idx) => (
          <div key={`${item.medico_nome}-${idx}`} className="totem-plantao-row">
            <div className="esp">{String(item.especialidade || 'MEDICO CLINICO').toUpperCase()}</div>
            <div className="medico">
              {String(item.medico_nome || 'MEDICO DE PLANTAO').toUpperCase()} - CRM: {item.crm || 'N/A'}
            </div>
          </div>
        ))}
      </section>

      <section className="totem-main">
        <h3>SENHA ELETRONICA DE CHAMADA PARA ATENDIMENTO</h3>

        <div className="totem-boxes">
          <div className="box-prioritario">
            <div className="box-img">
              <img src="/assets/img/prioritario.jpg" alt="Prioritário" />
            </div>
            <h4>Prioritário para preferenciais</h4>
            <div className="btn-grid">
              {renderBotoes(grupos.prioritario, 'btn-prioritario')}
            </div>
          </div>

          <div className="box-pediatria">
            <div className="box-img">
              <img src="/assets/img/pediatrico.png" alt="Pediatria" />
            </div>
            <h4>Pediatria</h4>
            <div className="btn-grid">
              {renderBotoes(grupos.pediatria, 'btn-pediatria')}
            </div>
          </div>

          <div className="box-normal">
            <div className="box-img">
              <img src="/assets/img/normal.png" alt="Normal" />
            </div>
            <h4>Normal para clínico normal</h4>
            <div className="btn-grid">
              {renderBotoes(grupos.normalAdulto, 'btn-normal')}
            </div>
          </div>
        </div>
      </section>

      {mensagem && <div className="totem-msg ok">{mensagem}</div>}
      {erro && <div className="totem-msg err">{erro}</div>}
    </div>
  )
}
