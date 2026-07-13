# FRONT-DESIGN-SYSTEM

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Design System da plataforma.
```

---

## 1. Objetivo

Este documento define o **Design System oficial** da plataforma New Wave Enterprise.

Ele serve para:
- Garantir consistência visual em todos os produtos
- Centralizar tokens de design
- Definir componentes base reutilizáveis
- Suportar multi-brand e white-label
- Garantir acessibilidade

Design System não é apenas "cores e fontes".
Design System é o **contrato visual da plataforma**.

---

## 2. Princípio Fundamental

```text
Design System é transversal.
Design System não pertence a um produto.
Design System serve a todos os produtos.
Todo componente respeita tokens.
Toda tela respeita o Design System.
```

---

## 3. Tokens de Design

### 3.1 Cores

```text
Primary
  - primary-50
  - primary-100
  - primary-200
  - primary-300
  - primary-400
  - primary-500 (base)
  - primary-600
  - primary-700
  - primary-800
  - primary-900

Secondary
  - secondary-50
  - secondary-100
  - ...
  - secondary-500 (base)
  - ...
  - secondary-900

Accent
  - accent-50
  - ...
  - accent-500 (base)
  - ...
  - accent-900

Semantic
  - success
  - warning
  - error
  - info

Neutral
  - gray-50
  - gray-100
  - ...
  - gray-500 (base)
  - ...
  - gray-900
```

### 3.2 Tipografia

```text
Font Family
  - primary: Inter
  - secondary: [fonte secundária]
  - mono: [fonte monoespaçada]

Font Size
  - xs: 0.75rem
  - sm: 0.875rem
  - base: 1rem
  - lg: 1.125rem
  - xl: 1.25rem
  - 2xl: 1.5rem
  - 3xl: 1.875rem
  - 4xl: 2.25rem

Font Weight
  - regular: 400
  - medium: 500
  - semibold: 600
  - bold: 700

Line Height
  - tight: 1.25
  - normal: 1.5
  - relaxed: 1.75

Letter Spacing
  - tight: -0.025em
  - normal: 0
  - wide: 0.025em
```

### 3.3 Espaçamento

```text
xs: 0.25rem (4px)
sm: 0.5rem (8px)
md: 1rem (16px)
lg: 1.5rem (24px)
xl: 2rem (32px)
2xl: 3rem (48px)
3xl: 4rem (64px)
```

### 3.4 Breakpoints

```text
mobile: 0px
tablet: 768px
desktop: 1024px
wide: 1280px
```

### 3.5 Sombras

```text
shadow-sm
shadow-md
shadow-lg
shadow-xl
```

### 3.6 Bordas

```text
radius-sm: 0.25rem
radius-md: 0.5rem
radius-lg: 1rem
radius-full: 9999px
```

---

## 4. Componentes Base

### 4.1 Visão geral

| Componente | Descrição | Uso |
|------------|-----------|-----|
| Button | Botão com variantes | Ações |
| Input | Campo de entrada | Formulários |
| Card | Container de conteúdo | Cards, widgets |
| Table | Tabela de dados | Listagens |
| Form | Formulário com validação | Cadastros |
| Modal | Diálogo modal | Confirmações, detalhes |
| Navigation | Menu de navegação | Navegação |
| Dashboard | Container de dashboard | Dashboards |

### 4.2 Button

```text
Variantes:
  - primary
  - secondary
  - outline
  - ghost
  - danger

Tamanhos:
  - sm
  - md
  - lg

Estados:
  - default
  - hover
  - active
  - disabled
  - loading
```

### 4.3 Input

```text
Variantes:
  - default
  - error
  - success

Tamanhos:
  - sm
  - md
  - lg

Elementos:
  - label
  - input
  - error message
  - helper text
  - icon (opcional)
```

### 4.4 Card

```text
Variantes:
  - default
  - hover
  - selected

Elementos:
  - header
  - body
  - footer
  - image (opcional)
  - actions (opcional)
```

### 4.5 Table

```text
Variantes:
  - default
  - striped
  - hover

Elementos:
  - header
  - body
  - footer
  - sorting
  - pagination
  - selection
```

### 4.6 Form

```text
Elementos:
  - fields
  - validation
  - submit
  - cancel

Validação:
  - required
  - min/max
  - pattern
  - custom
```

### 4.7 Modal

```text
Variantes:
  - default
  - fullscreen
  - drawer

Elementos:
  - header
  - body
  - footer
  - close button
```

### 4.8 Navigation

```text
Variantes:
  - sidebar
  - topbar
  - bottomnav
  - drawer

Elementos:
  - items
  - active state
  - badge
  - collapse
```

### 4.9 Dashboard

```text
Variantes:
  - grid
  - list
  - masonry

Elementos:
  - widgets
  - charts
  - tables
  - filters
```

---

## 5. Temas

### 5.1 Light Theme

```text
Background: #FFFFFF
Surface: #F8FAFC
Text primary: #0F172A
Text secondary: #475569
Border: #E2E8F0
Primary: #3B82F6
Success: #10B981
Warning: #F59E0B
Error: #EF4444
```

### 5.2 Dark Theme

```text
Background: #0F172A
Surface: #1E293B
Text primary: #F8FAFC
Text secondary: #94A3B8
Border: #334155
Primary: #60A5FA
Success: #34D399
Warning: #FBBF24
Error: #F87171
```

### 5.3 Multi-brand

```text
Cada tenant pode ter:
  - primary color customizada
  - logo customizada
  - nome customizado
  - tema light/dark

Isso é configuração de tenant,
não altera o Design System.
```

---

## 6. Acessibilidade

### 6.1 Regras

```text
Contrast ratio mínimo: 4.5:1
Focus visible em todos os elementos interativos
Semantic HTML
ARIA labels quando necessário
Keyboard navigation
Screen reader friendly
```

### 6.2 Níveis

```text
WCAG 2.1 AA: obrigatório
WCAG 2.1 AAA: desejável
```

---

## 7. Regras de Uso

### 7.1 Componentes

```text
Todo componente deve:
  - Respeitar tokens
  - Ser acessível
  - Suportar temas
  - Ser documentado
  - Ter testes

Nenhum componente deve:
  - Hardcodar cores
  - Hardcodar tamanhos
  - Ignorar acessibilidade
  - Duplicar funcionalidade
```

### 7.2 Telas

```text
Toda tela deve:
  - Usar componentes do Design System
  - Respeitar tokens
  - Ser responsiva
  - Suportar temas
  - Ser acessível

Nenhuma tela deve:
  - Criar componente próprio sem necessidade
  - Hardcodar estilos
  - Ignorar responsividade
  - Ignorar acessibilidade
```

---

## 8. Estrutura de Código

### 8.1 Estrutura recomendada

```
packages/design-system/
  ├── src/
  │   ├── tokens/
  │   │   ├── colors.ts
  │   │   ├── typography.ts
  │   │   ├── spacing.ts
  │   │   ├── shadows.ts
  │   │   └── breakpoints.ts
  │   │
  │   ├── themes/
  │   │   ├── light.ts
  │   │   ├── dark.ts
  │   │   └── index.ts
  │   │
  │   ├── components/
  │   │   ├── Button/
  │   │   │   ├── Button.tsx
  │   │   │   ├── Button.module.css
  │   │   │   ├── Button.test.tsx
  │   │   │   └── index.ts
  │   │   ├── Input/
  │   │   ├── Card/
  │   │   ├── Table/
  │   │   ├── Form/
  │   │   ├── Modal/
  │   │   ├── Navigation/
  │   │   └── Dashboard/
  │   │
  │   ├── utils/
  │   │   ├── cn.ts
  │   │   ├── accessibility.ts
  │   │   └── responsive.ts
  │   │
  │   └── index.ts
  │
  └── package.json
```

### 8.2 Regras de componente

```text
Cada componente deve ter:
  - Arquivo principal .tsx
  - Estilos .module.css
  - Testes .test.tsx
  - Exportação em index.ts
  - Tipos TypeScript
  - Documentação JSDoc
```

---

## 9. Integração com Kernel

### 9.1 Design System consome Core

```text
Design System
  ↓
Core Runtime (tokens, temas)
  ↓
Kernel (contexto, tenant)
```

Design System não acessa Kernel diretamente.
Design System consome tokens do Core.

### 9.2 Multi-brand

```text
Tenant A
  ↓
Primary color: #3B82F6
  ↓
Design System aplica tema

Tenant B
  ↓
Primary color: #10B981
  ↓
Design System aplica tema
```

---

## 10. Regras de Governança

### 10.1 Criação de componente

```text
Novo componente:
1. Verificar se já existe componente equivalente
2. Se existir: reutilizar
3. Se não existir: criar com tokens
4. Documentar
5. Testar
6. Aprovar
```

### 10.2 Alteração de token

```text
Alterar token:
1. Avaliar impacto em todos os componentes
2. Avaliar impacto em todos os produtos
3. Aprovar via GATE
4. Alterar
5. Comunicar
```

### 10.3 Exclusão de componente

```text
Excluir componente:
1. Verificar dependências
2. Migrar consumidores
3. Marcar como deprecated
4. Remover após período
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | FRONTEND-ARCHITECTURE.md | Arquitetura frontend detalhada |
| Alta | FRONT-KERNEL-MAP.md | Mapa front-kernel |
| Média | FRONT-CONTRACTS.md | Contratos frontend detalhados |
| Baixa | FRONTEND-TESTING.md | Estratégia de testes |

---

## 12. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do Design System |

---

Documento Canônico — FRONT-DESIGN-SYSTEM

**Este é o Design System oficial da plataforma New Wave Enterprise.**
