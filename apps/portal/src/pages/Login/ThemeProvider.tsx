import { createContext, useContext, useState, type ReactNode } from 'react'

type Theme = 'dark' | 'light'

/**
 * Theme Context Value
 *
 * Estrutura de dados exposta pelo contexto de tema do Portal.
 */
interface ThemeContextValue {
  theme: Theme
  toggle: () => void
}

const ThemeContext = createContext<ThemeContextValue | null>(null)

/**
 * Theme Provider
 *
 * Provider de tema (dark/light) para os componentes de login.
 * Gerencia o estado do tema e função de alternância.
 *
 * @param props.children - Nós filhos que consumirão o contexto de tema.
 * @returns Context provider com tema atual.
 *
 * @see {@link useTheme}
 */
export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>('dark')

  const toggle = () => setTheme((prev) => (prev === 'dark' ? 'light' : 'dark'))

  return <ThemeContext.Provider value={{ theme, toggle }}>{children}</ThemeContext.Provider>
}

/**
 * Hook de Tema do Login
 *
 * Hook para acessar tema atual e função de alternância.
 * Deve ser usado dentro de ThemeProvider.
 *
 * @returns Objeto com tema e função toggle.
 * @throws {Error} Se usado fora de ThemeProvider.
 *
 * @see {@link ThemeProvider}
 */
export function useTheme() {
  const ctx = useContext(ThemeContext)
  if (!ctx) {
    throw new Error('useTheme deve ser usado dentro de <ThemeProvider>')
  }
  return ctx
}
