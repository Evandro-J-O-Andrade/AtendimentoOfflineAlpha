# MD-014 — Design System

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o sistema visual oficial da plataforma, garantindo consistência, reuso e identidade única em todas as aplicações registradas.

---

## Princípio Fundamental

```text
Nenhuma aplicação cria componentes visuais próprios
quando existir componente canônico disponível.
```

---

## Estrutura Física

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
    compostos/
      DataTable/
      Modal/
      Drawer/
      Form/
      Card/
      Layout/
      Grid/
      Navigation/
      Search/
      Dropdown/
      Pagination/
      FileUpload/
    complexos/
      Dashboard/
      Chart/
      FiltroAvancado/
      Kanban/
      Timeline/
      Calendario/
      Wizard/
      Stepper/
  padroes/
    formularios/
    listagens/
    cadastros-basicos/
    dashboards/
    feedback/
    navegacao/
  estilos/
    reset.css
    variaveis.css
    tema-claro.css
    tema-escuro.css
    utilitarios.css
  docs/
    Storybook/
    exemplos/
    guia-de-uso/
```

---

## Tokens Do Design System

Tokens são valores imutáveis que definem a aparência da plataforma.

### Cores

```text
Primárias: marca do tenant (white-label)
Secundárias: ações secundárias
Neutras: cinzas para texto e fundos
Semânticas: sucesso, erro, aviso, informação
```

### Tipografia

```text
Família de fonte primária
Tamanhos: xs, sm, md, lg, xl, 2xl
Pesos: regular, medium, semibold, bold
Altura de linha e espaçamento entre letras padronizados
```

### Espaçamento

```text
Unidade base: 4px ou 8px
Escala: 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24
```

### Layout

```text
Grid: 12 colunas
Gutter: 24px padrão
Breakpoints: sm, md, lg, xl, 2xl
Container max-width por breakpoint
```

---

## Componentes

### Primitivos

São átomos visuais. Sem lógica de negócio.

```text
Button
Input
Checkbox
Radio
Switch
Select
Textarea
Badge
Avatar
Icon
Spinner
Skeleton
Tooltip
Popover
```

Características:

```text
Acessíveis (WAI-ARIA)
Responsivos
Suportam tema claro e escuro
Recebem props tipadas
São apresentacionalmente puros
```

### Compostos

São moléculas e organismos. Combinam primitivos.

```text
DataTable
Modal
Drawer
Form
Card
Layout
Grid
Navigation
Search
Dropdown
Pagination
FileUpload
```

Características:

```text
Possuem comportamento padrão
São reutilizáveis entre aplicações
Recebem dados via props
Disparam eventos via callbacks
Respeitam contratos documentados
```

### Complexos

São organismos de domínio. Combinam compostos com lógica específica.

```text
Dashboard
Chart
FiltroAvancado
Kanban
Timeline
Calendario
Wizard
Stepper
```

Características:

```text
Podem ter lógica de apresentação
São readonly no que tange a regra de negócio
São parametrizáveis
São compostos por componentes canônicos
```

---

## Padrões De Uso

Padrões são combinações documentadas de componentes para cenários comuns.

### Formulários

```text
Estrutura padrão de cadastro
Validação visual
Agrupamento de campos
Ações padrão (salvar, cancelar, limpar)
```

### Listagens

```text
Tabela com filtros
Paginação e ordenação
Ações em lote
Seleção múltipla
```

### Dashboards

```text
Grid de widgets
Filtros globais
Cards de KPI
Gráficos padronizados
```

### Feedback

```text
Sucesso, erro, aviso, informação
Toasts e notificações
Confirmações
Loading states
```

---

## Multi-Tenant E White Label

### Tokens Dinâmicos

Cada tenant pode definir:

```text
Cor primária
Cor secundária
Fonte (dentro de família permitida)
Logo
Ícone de aplicação
```

### Implementação

```text
CSS Variables injetadas no :root
Tokens resolvidos em runtime
ThemeProvider aplica tokens do tenant no login
Nenhum dado de tenant vaza para outro tenant via tema
```

### Restrições De Customização

```text
Fonte: apenas da família aprovada
Cores primárias: validadas para contraste mínimo
Logo: dimensões e formato definidos
Nenhuma alteração estrutural permitida (grid, spacing)
```

---

## Acessibilidade

Padrão mínimo:

```text
WCAG 2.1 Nível AA
Contraste mínimo de cores
Navegação por teclado
Semântica HTML correta
ARIA labels em elementos interativos
Focus management em modais e drawers
Screen reader testing obrigatório para componentes complexos
```

---

## Documentação Cada componente possui Storybook com:

```text
Preview visual
Lista de props
Exemplos de uso
Exemplos de estados
Exemplos de variações
Código de exemplo
Orientações de acessibilidade
```

---

## Versionamento

```text
Design System versionado semanticamente.
Breaking changes anunciados com antecedência.
Depreciação gradual com período de migração.
Changelog público por versão.
```

---

## Regras

1. Nenhum componente visual é criado antes de verificar se já existe no Design System.
2. Nenhum componente é alterado sem aprovação do time de Design System.
3. Nenhuma aplicação define tokens de cor, tipografia ou espaçamento diretamente.
4. Nenhuma aplicação altera estrutura de grid ou layout sem aprovação.
5. Componentes complexos são criados apenas quando três ou mais aplicações precisam.
6. Todo componente novo inclui testes de acessibilidade.
7. Todo componente novo inclui Storybook.
8. Tokens são consumidos via variáveis CSS ou tokens do framework, nunca valores hardcoded.

### Fluxo De Criação De Componente

```text
Identificar necessidade
  ↓
Verificar se componente canônico existe
  ↓
Se existe: usar
Se não existe: propor ao time de Design System
  ↓
Aprovação e implementação
  ↓
Documentação
  ↓
Disponibilização para todas as aplicações
```

---

## Integração Com Outros Módulos

- App Registry: componentes utilizados por aplicações registradas.
- Shell: Shell usa componentes canônicos.
- Auth: componentes de autenticação (LoginForm) são canônicos.
- Runtime: componentes de status de conexão e sincronização são canônicos.
- Analytics: componentes de dashboard e chart são canônicos.

---

## Proibições

São proibidos:

```text
Componente visual duplicado
Estilo inline exceto overrides documentados
Token hardcoded
Cor hexa direta no código
Fonte customizada não aprovada
Layout customizado quebrando grid padrão
Componente sem documentação em produção
Componente sem acessibilidade em produção
Import direto de componente interno de outra aplicação
Alteração de variável CSS sem passar pelo Design System
```

---

## Lei Do Design System

```text
Aparência é da plataforma.
Lógica é das aplicações.
Reuso é obrigatório.
```

---

## Responsabilidades

Time De Design System É Responsável Por:

```text
Criar e manter componentes canônicos
Manter tokens e documentação
Garantir acessibilidade
Gerenciar versões e depreciações
Atender demandas de novos componentes
Garantir performance visual
Manter Storybook atualizado
```

Times De Aplicação São Responsáveis Por:

```text
Usar componentes canônicos
Reportar bugs ou limitações
Solicitar novos componentes via processo oficial
Respeitar restrições de customização
NÃO duplicar componentes existentes
NÃO alterar tokens diretamente
