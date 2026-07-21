# CHECKPOINT — Tela Original de Login

**Data:** 2026-07-21  
**Status:** Estável  
**Componente:** `apps/portal/src/pages/Login/`

---

## Estrutura da Tela

```
LoginPage (orquestrador)
├── LoginHero (painel esquerdo)
│   ├── Logo
│   ├── Título + Subtítulo
│   └── Brand Icons (6 ícones com animação)
└── LoginCard (painel direito - card pai)
    ├── Theme Toggle
    ├── Logo do formulário
    ├── Título + Subtítulo
    ├── Formulário
    │   ├── Input Usuário (floating label)
    │   ├── Input Senha (floating label + toggle visibility)
    │   ├── Checkbox "Lembrar de mim"
    │   ├── Link "Esqueceu sua senha?"
    │   └── Botão "Entrar"
    ├── Divisória "Plataforma segura e confiável"
    └── Security Badges (3 badges)
```

---

## Componentes

| Arquivo | Função |
|---------|--------|
| `LoginPage.tsx` | Orquestrador, estado global, tema |
| `LoginHero.tsx` | Painel esquerdo, brand icons animados |
| `LoginCard.tsx` | Card pai do formulário, floating labels |
| `LoginFooter.tsx` | Rodapé |
| `ThemeProvider.tsx` | Provider de tema |
| `LoginPage.module.css` | Estilos globais da tela |

---

## Animação dos Brand Icons (Hero)

- **Hover:** ícone cresce 8%, ganha fundo azul metálico (`rgba(59,130,246,0.25)`) e sombra azul
- **Clique:** overlay central com backdrop blur
  - Ícone gira 360° enquanto cresce de 0.2x → 1x (0.9s)
  - Texto do ícone aparece com fade-in + translateY após 0.65s
  - Tamanho final do ícone: 200px

**Estilo dos ícones:**
- Traço fino `strokeWidth="1.25"` (estilo desenho a lápis)
- Formas limpas com cantos arredondados (`rx="1"`)
- Cores adaptadas por tema

---

## Floating Labels (Formulário)

**Comportamento:**
- Estado vazio: label dentro do input, centralizado
- Ao focar/clicar: label sove para borda superior + aumenta 18px + scale(1.05)
- Com valor digitado: label permanece na posição superior
- Ao limpar: label volta para dentro do input

**Campos com floating label:**
- Usuário
- Senha
- Código MFA

**CSS:**
- `.floatingLabel` com transição suave de `top`, `transform`, `color`, `background`
- `.fieldIcon ~ .floatingLabel` ajusta `left: 44px` quando há ícone
- `.input:focus ~ .floatingLabel` e `.input:not(:placeholder-shown) ~ .floatingLabel`

---

## Layout do Card Pai

- **Direita:** card largo, quase encostando no footer com 5px de espaçamento
- `.rightPanel`: `flex: 1`, `padding: 5px`, `justify-content: stretch`
- `.formContainer`: `flex: 1`, `padding: 5px`, `align-items: stretch`
- `.cardForm`: `max-width: none`, `flex: 1`, `display: flex`, `flex-direction: column`, `gap: 20px`
- Mobile: mantém 5px de borda, layout empilhado

---

## Ícones do Formulário

| Ícone | Função | Estilo |
|-------|--------|--------|
| `IconUser` | Campo usuário | Traço 1.25px, círculos arredondados |
| `IconLock` | Campo senha | Retângulo com keyhole |
| `IconEye` | Mostrar senha | Olho com pupila |
| `IconEyeOff` | Ocultar senha | Olho fechado com traço diagonal |
| `IconMoon` | Tema escuro | Lua crescente |
| `IconSun` | Tema claro | Sol com raios |
| `IconShieldCheck` | Badge segurança | Escudo com check |
| `IconCloud` | Badge disponibilidade | Nuvem orgânica |
| `IconLockKeyhole` | Badge LGPD | Cadeado com keyhole |

**Interações:**
- Ícones de campo mudam para azul `#1e70f4` no `:focus`
- Toggle de senha com hover azul translúcido
- Badges com hover suave (`translateY(-1px)`)

---

## Temas

### Dark Mode (padrão)
- Fundo hero: imagem `pagsaas.webp` com overlay gradiente
- Card: `rgba(9, 16, 29, 0.88)` + backdrop blur
- Texto: branco/azul
- Badges: fundo escuro translúcido

### Light Mode
- Fundo hero: mesma imagem com overlay claro
- Card: `rgba(255, 255, 255, 0.72)` + bordas azuis
- Texto: preto/cinza escuro
- Badges: fundo branco translúcido

---

## Responsividade

| Breakpoint | Layout |
|------------|--------|
| Desktop ≥ 1024px | Grid 60/40 (hero + form) |
| Tablet 768-1023px | Coluna, hero oculto, card full width |
| Mobile ≤ 767px | Card full width, padding reduzido |

---

## Stack

- React 18.3.1
- Vite 7.3.6
- TypeScript 5.9.3
- CSS Modules
- pnpm 11.10.0
- Turbo 2.10.5

---

## Estado

**Aprovado como tela original de login do Portal Enterprise.**
