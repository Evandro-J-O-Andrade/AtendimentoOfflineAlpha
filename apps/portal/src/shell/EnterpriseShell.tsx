import { usePortalRuntime } from './PortalRuntime'
import { useAuth } from '@atendimentooffline/auth'
import type { ReactNode } from 'react'
import { WidgetRenderer } from './WidgetRenderer'

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

function ShellContent() {
  const rt = usePortalRuntime()
  const { logout } = useAuth()

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
            {rt.navigation.length === 0 && <em>Nenhuma navegação</em>}
            {rt.navigation.map((group) => (
              <div key={group.id} style={{ marginBottom: 12 }}>
                <div style={{ fontWeight: 600 }}>{group.label}</div>
                {group.items.map((item) => (
                  <div key={item.id} style={{ padding: '4px 0' }}>
                    {item.label}
                  </div>
                ))}
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

export function EnterpriseShell({ children }: { children?: ReactNode }) {
  return (
    <>
      <ShellContent />
      {children}
    </>
  )
}
