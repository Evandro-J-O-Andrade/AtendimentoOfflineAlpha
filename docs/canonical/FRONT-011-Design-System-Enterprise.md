# FRONT-011 — Design System Enterprise

## Status

Documento Canônico de Frontend.
Define o sistema visual oficial da plataforma.

---

## Objetivo

Garantir consistência, reuso e identidade visual única em todas as aplicações da plataforma.

---

## Princípio Fundamental

```text
Nenhuma aplicação cria componentes visuais próprios
quando existir componente canônico disponível.

Design System é a única fonte de verdade visual.
```

---

## MDs Relacionados

| MD | Finalidade |
|----|-----------|
| MD-014 — Design System | Documento canônico de Design System |
| MD-041 — Design System Enterprise | Documento complementar |
| MD-042 — Frontend Shell Architecture | Shell e estrutura visual |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 a FRONT-010 | Experiências que usam o Design System |

---

## Estrutura do Design System

```
design-system/
  tokens/
    cores.ts
    tipografia.ts
    espacamento.ts
    sombras.ts
    raios.ts
    breakpoints.ts
    animacoes.ts
    zindex.ts
  componentes/
    primitivos/
      Button/
      Input/
      Checkbox/
      Radio/
      Switch/
      Select/
      Textarea/
      Badge/
      Avatar/
      Icon/
      Spinner/
      Skeleton/
      Tooltip/
      Popover/
      Toggle/
      Slider/
    compostos/
      DataTable/
      Modal/
      Drawer/
      Form/
      Card/
      Layout/
      Grid/
      Navigation/
      Sidebar/
      Header/
      SearchBar/
      NotificationBadge/
      ContextSelector/
      DashboardShell/
    padroes/
      LoginPattern/
      ContextSelectionPattern/
      PortalHomePattern/
      DashboardPattern/
      ListPattern/
      FormPattern/
      FilterPattern/
      EmptyState/
      ErrorState/
      LoadingState/
```

---

## Tokens Canônicos

### Cores

```text
Primárias
  --color-primary-50
  --color-primary-100
  ...
  --color-primary-900
  --color-primary-DEFAULT

Secundária
  --color-secondary-50...
  --color-secondary-DEFAULT

Neutras
  --color-slate-50...950

Semânticas
  --color-success
  --color-warning
  --color-danger
  --color-info

Funcionais
  --color-background
  --color-surface
  --color-surface-elevated
  --color-border
  --color-text-primary
  --color-text-secondary
  --color-text-muted
```

### Tipografia

```text
Família: Inter (padrão), monospace para código
Tamanhos:
  --font-size-xs (0.75rem)
  --font-size-sm (0.875rem)
  --font-size-base (1rem)
  --font-size-lg (1.125rem)
  --font-size-xl (1.25rem)
  --font-size-2xl (1.5rem)
  --font-size-3xl (1.875rem)
  --font-size-4xl (2.25rem)

Pesos:
  --font-weight-normal (400)
  --font-weight-medium (500)
  --font-weight-semibold (600)
  --font-weight-bold (700)
  --font-weight-black (900)

Altura:
  --line-height-tight (1.25)
  --line-height-normal (1.5)
  --line-height-relaxed (1.75)
```

### Espaçamento

```text
Escala de 4px:
  --space-1 (0.25rem = 4px)
  --space-2 (0.5rem = 8px)
  --space-3 (0.75rem = 12px)
  --space-4 (1rem = 16px)
  --space-5 (1.25rem = 20px)
  --space-6 (1.5rem = 24px)
  --space-8 (2rem = 32px)
  --space-10 (2.5rem = 40px)
  --space-12 (3rem = 48px)
  --space-16 (4rem = 64px)
```

### Sombras

```text
--shadow-sm
--shadow-md
--shadow-lg
--shadow-xl
--shadow-2xl
--shadow-inner
```

### Raios

```text
--radius-sm (0.25rem)
--radius-md (0.5rem)
--radius-lg (0.75rem)
--radius-xl (1rem)
--radius-2xl (1.5rem)
--radius-full (9999px)
```

### Breakpoints

```text
--breakpoint-sm (640px)
--breakpoint-md (768px)
--breakpoint-lg (1024px)
--breakpoint-xl (1280px)
--breakpoint-2xl (1536px)
```

### Z-Index

```text
--z-dropdown (1000)
--z-sticky (1020)
--z-fixed (1030)
--z-modal-backdrop (1040)
--z-modal (1050)
--z-popover (1060)
--z-tooltip (1070)
```

---

## Princípios de UI

### Clareza

```text
Cada elemento tem propósito.
Cada texto é legível.
Cada ação é evidente.
Hierarquia visual clara.
Sem ruído desnecessário.
```

### Consistência

```text
Mesmo componente = mesmo comportamento.
Mesma ação = mesmo padrão visual.
Mesma cor = mesmo significado.
Mesmo espaçamento = mesma escala.
```

### Feedback

```text
Toda ação tem resposta visual.
Loading, sucesso, erro, vazio.
Estados são sempre comunicados.
Transições são suaves, nunca intrusivas.
```

### Acessibilidade

```text
Contraste mínimo 4.5:1 (WCAG AA)
Focus visível em todos os controles
Labels em todos os inputs
Semantic HTML
ARIA labels quando necessário
Navegação por teclado
Suporte a leitores de tela
```

### Responsividade

```text
Mobile-first
Fluid layouts
Touch-friendly (44px mínimo)
Breakpoints consistentes
Sem overflow horizontal
Imagens adaptativas (srcset, WebP/AVIF)
```

---

## Componentes Primitivos

### Button

```text
Variantes: primary, secondary, outline, ghost, danger
Tamanhos: sm, md, lg
Estados: default, hover, active, disabled, loading
Ícone: esquerda, direita, apenas ícone
Loading: spinner substitui texto
```

### Input

```text
Tipos: text, email, password, number, search
Estados: default, focus, error, disabled
Características:
  - Label flutuante (opcional)
  - Ícone de ação (limpar, toggle password)
  - Mensagem de erro inline
  - Contador de caracteres (opcional)
```

### Select

```text
Nativo ou customizado
Busca interna (opcional)
Agrupamento por categoria
Seleção múltipla (opcional)
Estados: default, open, disabled
```

### Checkbox / Radio / Switch

```text
Label clicável
Estados: unchecked, checked, indeterminate, disabled
Switch: animação suave
Acessibilidade: vinculado ao input
```

### Badge

```text
Variantes: default, primary, secondary, success, warning, danger, info
Tamanhos: sm, md, lg
Com ícone (opcional)
Pills onRemove (opcional)
```

### Avatar

```text
Tamanhos: xs, sm, md, lg, xl
Fallback: iniciais
Status: online, offline, busy, away
Imagem ou ícone padrão
Agrupamento (stack)
```

### Spinner

```text
Tamanhos: sm, md, lg
Cores: primary, secondary, white
Overlay mode (fullscreen)
Inline mode
```

### Skeleton

```text
Linha de texto
Card
Avatar
Tabela
Lista
Animação: pulse shimmer
```

### Tooltip / Popover

```text
Posicionamento: top, bottom, left, right, auto
Trigger: hover, click, focus
Delay: configuração
Arrow: opcional
Dismiss: ESC, click outside
```

---

## Componentes Compostos

### DataTable

```text
Colunas ordenáveis
Filtros por coluna
Seleção de linhas (simples/múltipla)
Paginação
Tamanhos: compact, default, comfortable
Estados: loading, empty, error
Ações por linha (menu dropdown)
Bulk actions (quando seleção múltipla)
```

### Modal

```text
Tamanhos: sm, md, lg, xl, full
Overlay: fechar clicando fora, ESC
Header: título + botão fechar
Body: scrollável independente
Footer: ações primária e secundária
Animações: fade + scale
Focus trap dentro do modal
```

### Drawer

```text
Posições: left, right, bottom
Tamanhos: sm, md, lg
Overlay opcional
Swipe para fechar (mobile)
Header: título + fechar
Body: scrollável
```

### Form

```text
Layout: vertical, horizontal, inline
Validação:实时 ou no blur
Estados: default, touched, dirty, error, success
Feedback: mensagens inline
Submit: botão com loading state
Reset: opcional
```

### Card

```text
Variantes: default, elevated, outlined, filled
Header, body, footer opcionais
Hover: elevação (opcional)
Click: ação (opcional)
Borda: padrão sutil
```

### Navigation / Sidebar / Header

```text
Ver FRONT-003, FRONT-004
Padronização de ícones
Estados de navegação ativa
Suporte a collapse/expand
Responsivo
```

### SearchBar

```text
Ver FRONT-014
Input com ícone de busca
Autocomplete
Filtros rápidos
Atalho Cmd+K
Resultados agrupados
```

### ContextSelector

```text
Ver FRONT-002
Seleção de tenant/unidade/local/perfil
Resumo visual do contexto
Troca rápida
Persistência na sessão
```

---

## Temas

### Light (padrão)

```text
Background: branco / slate-50
Surface: branco
Bordas: slate-200
Texto: slate-900 (primário), slate-500 (secundário)
Primária: indigo-600 (customizável por tenant)
```

### Dark

```text
Background: slate-950
Surface: slate-900
Bordas: slate-800
Texto: slate-100 (primário), slate-400 (secundário)
Primária: indigo-400 (customizável por tenant)
```

### High Contrast

```text
Para acessibilidade
Cores com contraste >= 7:1
Bordas reforçadas
Sem sombras sutis
Opcional por tenant
```

---

## White Label

```text
Cor primária customizável
Cor secundária customizável
Fonte customizável (limitado a web safe + Google Fonts)
Logo customizável
Favicon customizável
Tema (light/dark) padrão por tenant
```

---

## Implementação

### Stack

```text
React + TypeScript
Tailwind CSS (utility-first)
CSS Variables para tokens
Storybook para documentação
Chromatic para regression tests
```

### Regras

```text
Nenhum estilo inline em produção (exceto dynamic styles).
Todos os estilos via classes do Design System.
Componentes compartilhados em packages/ui.
Cada app consome packages/ui, nunca define seu próprio Button/Input/Select.
Customizações via props, nunca via CSS customizado por app.
```

---

## Governança

```text
Design System é propriedade da plataforma.
Novos componentes passam por aprovação de design + engenharia.
Breaking changes em componentes exigem nova versão (semver).
Componentes depreciados têm prazo mínimo de 6 meses.
Deprecated ≠ removido. Deprecated = não recomendado.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-014 — Design System | Documento canônico original |
| MD-041 — Design System Enterprise | Complemento canônico |
| MD-020 — Portal Core Architecture | Shell visual |
| MD-042 — Frontend Shell Architecture | Estrutura frontend |
| MD-094 — White Label Architecture | Customização por tenant |
| MD-095 — Multi-Brand Architecture | Multi-brand |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 a FRONT-010 | Consumidores do Design System |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Design | Definir tokens, componentes, padrões visuais |
| Frontend | Implementar componentes, manter Storybook |
| QA | Testes visuais (Chromatic), acessibilidade |
| Tenants | Customizar via white label (sem alterar núcleo) |
| Apps | Usar componentes, não criar novos |

---

## Métricas

```text
Componentes documentados
Componentes depreciados
Uso por componente (app que consome)
Bundle size do design system
Testes de acessibilidade (coverage)
Regressões visuais detectadas
Tempo de imersão de novo designer/dev
Satisfação com Design System (DSAT)
```

---

## Lei

```text
Design System é a voz visual da plataforma.
Todo componente canônico nasce aqui.
Nenhum componente nasce isolado.
Nenhuma app cria seu próprio Design System.
```

---

## Próximo

```text
FRONT-011 completo
  ↓
FRONT-012 — Widget Framework
```
