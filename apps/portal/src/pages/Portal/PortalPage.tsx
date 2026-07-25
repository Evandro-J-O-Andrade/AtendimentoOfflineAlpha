/**
 * Portal Page
 *
 * Página principal do Portal Enterprise após seleção de contexto.
 * Renderiza barra de navegação e estrutura baseada no runtime carregado.
 *
 * @see {@link EnterpriseShell}
 * @see {@link PortalRuntimeProvider}
 * @see {@link MAP-005-Portal-Architecture}
 */
import { usePortalRuntime } from '../../runtime/usePortalRuntime'

/**
 * Portal Page Component
 *
 * Renderiza branding e navegação do Portal a partir do runtime.
 * É o container inicial do Portal após login e seleção de contexto.
 *
 * @returns Estrutura base do Portal com navegação.
 */
export function PortalPage() {
  const runtime = usePortalRuntime()

  return (
    <div>
      <h1>{runtime.branding.name}</h1>

      <nav>
        <ul>
          {runtime.navigation.map((group) => (
            <li key={group.id}>
              <strong>{group.label}</strong>
              <ul>
                {group.items.map((item) => (
                  <li key={item.id}>
                    <a href={item.route}>{item.label}</a>
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  )
}
