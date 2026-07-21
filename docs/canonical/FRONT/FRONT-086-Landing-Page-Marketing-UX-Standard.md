# FRONT-086 — Landing Page and Marketing UX Standard

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Experiência de Marketing e Landing Page  
> **Companheiro:** FRONT-001 (Login), FRONT-003 (Portal Enterprise), FRONT-017 (Theme Experience), FRONT-084 (Responsive Assets), MD-020 (Portal Core), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Definir o padrão oficial de experiência de **Landing Pages** e **Marketing UX** da New Wave Enterprise Platform.

Este documento estabelece quais ideias de UX externas são **aprovadas para reaproveitamento** e quais são **proibidas** no ecossistema, garantindo que a identidade visual e arquitetural do Portal Enterprise seja preservada.

---

## 2. Princípio Arquitetural

A New Wave Enterprise Platform **não copia** arquitetura ou visual de agências ou plataformas externas.

Ela adota **boas práticas de UX e marketing** que são universais, mas as implementa com sua própria identidade visual, stack e padrões.

```
Ideias Externas (GV8, Linear, Stripe, Vercel, Azure, Atlassian)
    ↓
Filtro de Governança Arquitetural
    ↓
Aprovação (30% das ideias)
    ↓
Implementação com identidade New Wave
```

---

## 3. Stack Oficial de Landing Pages

| Camada | Tecnologia | Finalidade |
|--------|-----------|-----------|
| Frontend | React + Vite + TypeScript | SPA ou SSG |
| Estilos | CSS Modules | Componentização |
| Estado | Context API | Tema, Auth |
| Backend | Express + MySQL | API e contratos |
| Observabilidade | Sentry + Lighthouse | Qualidade |

**Proibido:** Vue.js, Angular, Svelte, Nuxt para Landing Pages oficiais.

---

## 4. Ideias Aprovadas para Reaproveitamento

### 4.1 Estrutura de Landing Page ⭐⭐⭐⭐⭐

Aprovado: organização sequencial clara para apresentação comercial.

```
Hero
    ↓
Produtos / Módulos
    ↓
Soluções
    ↓
Mercados / Segmentos
    ↓
Clientes / Portfólio
    ↓
Tecnologias
    ↓
Métricas / Contadores
    ↓
Planos / CTA
    ↓
Contato
```

Essa estrutura é **universal** e **aprovada** para Landing Pages New Wave.

Referência: GV8, Linear, Stripe, Vercel.

---

### 4.2 Cards de Serviços / Módulos ⭐⭐⭐⭐⭐

Aprovado: apresentar cada módulo/solução em card simples e objetivo.

Exemplo New Wave:

```
Portal Enterprise
    ↓
HIS Enterprise
    ↓
ERP Enterprise
    ↓
Segurança Eletrônica
    ↓
IA Corporativa
    ↓
WhatsApp AI
    ↓
Cloud
    ↓
Consultoria
```

---

### 4.3 Contadores Animados ⭐⭐⭐⭐

Aprovado: indicadores numéricos com animação.

Exemplo New Wave:

```
470+
Tabelas

230+
Stored Procedures

15+
Módulos

100%
Multiempresa

24/7
Offline Runtime
```

---

### 4.4 Portfólio de Clientes ⭐⭐⭐⭐⭐

Aprovado: showcase de cases e clientes.

Exemplo New Wave:

```
Hospital Alpha
    ↓
Gestão Médica
    ↓
Portal Enterprise
    ↓
Segurança
    ↓
Angel Cosméticos
    ↓
Meu Pet
    ↓
Meu Sushi
```

---

### 4.5 Responsividade ⭐⭐⭐⭐⭐

Aprovado: layout adaptativo para desktop, tablet e mobile.

Breakpoints obrigatórios:

| Dispositivo | Largura |
|-------------|---------|
| Desktop XL | ≥ 1600px |
| Desktop | 1280–1599px |
| Notebook | 1024–1279px |
| Tablet | 768–1023px |
| Mobile | ≤ 767px |

---

### 4.6 Chamadas para Ação (CTA) ⭐⭐⭐⭐⭐

Aprovado: repetição estratégica de CTAs.

Exemplos New Wave:

```
Solicitar Demonstração
    ↓
Agendar Apresentação
    ↓
Conhecer Plataforma
    ↓
Falar com Especialista
```

---

## 5. Ideias Reprovadas / Não Copiáveis

### 5.1 Hero Simples ❌

O Hero da GV8 é básico.

O Portal Enterprise exige Hero mais elaborado.

Exemplo New Wave:

```
Imagem cinematográfica
    ↓
Glassmorphism
    ↓
Dashboard ao fundo
    ↓
Efeitos sutis
    ↓
Gradiente institucional
```

---

### 5.2 Layout Tradicional ❌

O layout da GV8 é relativamente tradicional.

Para Landing Pages New Wave, buscar referências em:

- Linear
- Stripe
- Vercel
- Microsoft Azure
- Atlassian

Mais limpo, mais tecnológico, mais corporativo.

---

### 5.3 Cores de Marketing ❌

A identidade GV8 é voltada ao marketing.

A New Wave mantém sua identidade própria:

- Azul institucional
- Roxo tecnológico
- Preto
- Branco

---

### 5.4 Tipografia Genérica ❌

Investir em tipografia moderna e consistente.

Manter hierarquia clara:

- Títulos
- Subtítulos
- Corpo
- Labels

---

## 6. Elementos Obrigatórios New Wave

### 6.1 Dashboard Animado

```
Portal Enterprise
    ↓
[ Dashboard ]
    ↓
Usuários Online
    ↓
Hospital Alpha
    ↓
UPA
    ↓
UBS
    ↓
Financeiro
    ↓
Estoque
    ↓
IA
    ↓
Gráficos vivos
```

---

### 6.2 Mapa do Brasil

Mostrando:

```
Clientes
    ↓
Hospitais
    ↓
Prefeituras
    ↓
Clínicas
    ↓
Empresas
```

---

### 6.3 Timeline Corporativa

```
2006
    ↓
2010
    ↓
2018
    ↓
2024
    ↓
2026
    ↓
Portal Enterprise
```

---

### 6.4 Arquitetura Visual

Mostrar visualmente:

```
Portal
    ↓
Kernel
    ↓
Módulos
    ↓
Banco
    ↓
Runtime
    ↓
IA
```

---

## 7. Regras de Aprovação

Qualquer ideia de UX externa só pode ser aprovada se passar pelo **Filtro de Governança Arquitetural**:

1. Alinha-se ao stack oficial? (React + Vite + TypeScript + CSS Modules)
2. Alinha-se à identidade visual New Wave?
3. Alinha-se aos princípios do Portal Enterprise?
4. Não introduz ferramentas não suportadas?
5. Não quebra regras de segurança ou LGPD?

Se a resposta for **NÃO** para qualquer item, a ideia é **reprovada**.

---

## 8. Referências Aprovadas

A New Wave Enterprise Platform pode se inspirar em UX de:

- Linear
- Stripe
- Vercel
- Microsoft Azure
- Atlassian

Desde que implementadas com a identidade New Wave.

Referências **não aprovadas** para cópia direta:

- Agências de marketing genéricas
- Templates de landing page
- Sites institucionais não tecnológicos

---

## 9. Compatibilidade

Este padrão é compatível com:

- React 18+
- Vite 7+
- TypeScript 5+
- CSS Modules
- Tailwind CSS
- Node.js 20+
- pnpm 11+
- Turbo 2+

---

## Estado

**Aprovado para utilização como padrão oficial da New Wave Enterprise Platform.**
