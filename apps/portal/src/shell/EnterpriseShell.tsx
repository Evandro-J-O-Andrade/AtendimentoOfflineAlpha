import { useState } from 'react'
import { usePortalRuntime } from './PortalRuntime'
import { useAuth } from '@atendimentooffline/auth'
import type { ReactNode } from 'react'
import { WidgetRenderer } from './WidgetRenderer'
import type { DomainConfig } from '../domains'
import { useRouter } from '../app/router'

const shellStyle: React.CSSProperties = {
  display: 'flex',
  flexDirection: 'column',
  height: '100vh',
  fontFamily: 'system-ui, sans-serif'
}

const headerStyle: React.CSSProperties = {
  height: 56,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  padding: '0 16px',
  borderBottom: '1px solid #e5e7eb',
  background: '#0f172a',
  color: '#fff'
}

const bodyStyle: React.CSSProperties = {
  display: 'flex',
  flex: 1,
  minHeight: 0
}

const asideStyle: React.CSSProperties = {
  width: 240,
  borderRight: '1px solid #e5e7eb',
  padding: 12,
  overflowY: 'auto'
}

const mainStyle: React.CSSProperties = {
  flex: 1,
  padding: 16,
  overflowY: 'auto'
}

const domainItemStyle: React.CSSProperties = {
  padding: '6px 8px',
  cursor: 'pointer',
  borderRadius: 4,
  marginBottom: 4
}

const domainItemHoverStyle: React.CSSProperties = {
  ...domainItemStyle,
  background: '#f1f5f9'
}

/**
 * Enterprise Shell
 *
 * Shell principal do Portal Enterprise. Renderiza layout com header,
 * sidebar de domínios, área principal e widgets.
 *
 * Integra DomainRegistry para navegação por domínios canônicos.
 *
 * @param props.children - Conteúdo adicional renderizado abaixo do shell.
 * @returns Estrutura visual completa do Portal.
 *
 * @see {@link ShellContent}
 * @see {@link PortalRuntimeProvider}
 * @see {@link WidgetRenderer}
 * @see {@link DomainConfig}
 * @see {@link DOMAIN_REGISTRY}
 */
function ShellContent() {
  const rt = usePortalRuntime()
  const { logout } = useAuth()
  const { navigate } = useRouter()
  const [hoveredDomain, setHoveredDomain] = useState<string | null>(null)

  return (
    <div style={shellStyle}>
      <header style={headerStyle}>
        <div>
          <strong>{rt.branding?.name ?? 'Enterprise Portal'}</strong>
          <div style={{ fontSize: 12, opacity: 0.8 }}>
            {rt.tenant?.name ?? '—'} / {rt.context?.name ?? '—'}
          </div>
        </div>
        <div>
          <span>{rt.user?.name ?? '—'}</span>
          <button
            type="button"
            onClick={logout}
            style={{ marginLeft: 12, background: 'transparent', color: '#fff', border: '1px solid #fff', borderRadius: 4, padding: '4px 8px', cursor: 'pointer' }}
          >
            Logout
          </button>
        </div>
      </header>
      <div style={bodyStyle}>
        <aside style={asideStyle}>
          <nav>
            <div style={{ fontWeight: 600, marginBottom: 8 }}>Domínios</div>
            {rt.applications
              .filter((app) => app.enabled)
              .map((app) => (
                <div
                  key={app.id}
                  style={hoveredDomain === app.id ? domainItemHoverStyle : domainItemStyle}
                  onMouseEnter={() => setHoveredDomain(app.id)}
                  onMouseLeave={() => setHoveredDomain(null)}
                  onClick={() => {
                    navigate({
                      type: 'domain',
                      domain: {
                        id: app.id,
                        nome: app.name,
                        modulo: app.code,
                        rota: app.route,
                        icone: app.icon ?? '',
                        acoes: app.permission ? [app.permission] : []
                      } as DomainConfig
                    })
                  }}
                >
                  {app.name}
                </div>
              ))}
          </nav>
          {rt.management?.enabled && (
            <div style={{ marginTop: 16, padding: 12, border: '1px solid #cbd5e1', borderRadius: 8 }}>
              <strong>Gestão</strong>
              {(rt.management.containers ?? []).map((c) => (
                <div key={c.id} style={{ padding: '4px 0' }}>
                  {c.name}
                </div>
              ))}
            </div>
          )}
        </aside>
        <main style={mainStyle}>
          <h1>{rt.dashboard?.title ?? 'Dashboard'}</h1>
          <section style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
            {rt.applications
              .filter((a) => a.enabled)
              .map((app) => (
                <div
                  key={app.id}
                  style={{
                    border: '1px solid #e2e8f0',
                    borderRadius: 8,
                    padding: 16,
                    minWidth: 160
                  }}
                >
                  <strong>{app.name}</strong>
                </div>
              ))}
          </section>
           <section style={{ marginTop: 24 }}>
             <h2>Widgets</h2>
             {rt.widgets.length === 0 && <em>Nenhum widget</em>}
             <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
               {rt.widgets.map((widget) => (
                 <WidgetRenderer key={widget.id} widget={widget} />
               ))}
             </div>
           </section>
          <section style={{ marginTop: 24 }}>
            <h2>Notificações</h2>
            {(rt.notifications ?? []).length === 0 && <em>Nenhuma notificação</em>}
            <ul>
              {(rt.notifications ?? []).map((notification) => (
                <li key={notification.id}>{notification.text}</li>
              ))}
            </ul>
          </section>
        </main>
      </div>
    </div>
  )
}

/**
 * Enterprise Shell Export
 *
 * Componente exportado que renderiza o ShellContent e permite
 * injeção de conteúdo adicional via children.
 *
 * @param props.children - Nós filhos injetados abaixo do shell padrão.
 * @returns Shell do Portal com conteúdo opcional.
 * @see {@link ShellContent}
 */
export function EnterpriseShell({ children }: { children?: ReactNode }) {
  return (
    <>
      <ShellContent />
      {children}
    </>
  )
}

