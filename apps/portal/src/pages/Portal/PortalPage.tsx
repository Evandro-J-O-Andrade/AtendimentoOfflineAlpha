import { usePortalRuntime } from '../../runtime/usePortalRuntime'

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
