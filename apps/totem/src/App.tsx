import { TotemRouter, useTotemRouter } from './app/providers'
import TotemSenha from './pages/TotemSenha/TotemSenha'
import TotemSatisfacao from './pages/TotemSatisfacao/TotemSatisfacao'

function TotemRouterView() {
  const { route } = useTotemRouter()

  if (route === 'satisfacao') {
    return <TotemSatisfacao />
  }

  return <TotemSenha />
}

export default function App() {
  return (
    <TotemRouter>
      <TotemRouterView />
    </TotemRouter>
  )
}
