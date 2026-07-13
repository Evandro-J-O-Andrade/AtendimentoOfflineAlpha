# FRONTEND-TESTING

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Estratégia de testes do frontend.
```

---

## 1. Objetivo

Este documento define a **estratégia de testes oficial** do frontend da plataforma New Wave Enterprise.

Ele serve para:
- Garantir qualidade
- Prevenir regressões
- Documentar comportamento esperado
- Apoiar refatorações seguras
- Garantir acessibilidade

Testes não são opcionais.
Testes são **parte da arquitetura**.

---

## 2. Princípio Fundamental

```text
Todo componente deve ser testado.
Todo hook deve ser testado.
Todo serviço deve ser testado.
Toda feature deve ser testada.
Testes são documentação executável.
```

---

## 3. Pirâmide de Testes

### 3.1 Visão geral

```
       /\
      /  \
     / E2E \
    /--------\
   /          \
  / Integration \
 /--------------\
/                \
/   Unit Tests    \
/------------------\
```

### 3.2 Unit Tests

| Aspecto | Descrição |
|---------|-----------|
| Cobertura | Componentes, hooks, utils, services |
| Ferramenta | Vitest |
| Execução | Rápida (< 5s por arquivo) |
| Isolamento | Total |
| Mocks | Permitidos |

### 3.3 Integration Tests

| Aspecto | Descrição |
|---------|-----------|
| Cobertura | Features, fluxos, contratos |
| Ferramenta | Vitest + Testing Library |
| Execução | Média (< 30s por arquivo) |
| Isolamento | Parcial |
| Mocks | Mínimos |

### 3.4 E2E Tests

| Aspecto | Descrição |
|---------|-----------|
| Cobertura | Fluxos críticos, jornadas |
| Ferramenta | Playwright |
| Execução | Lenta (> 1min por fluxo) |
| Isolamento | Nenhum |
| Mocks | Nenhum |

---

## 4. Estratégia por Camada

### 4.1 Components

```text
Todo componente deve ter:
  - Teste de renderização
  - Teste de interação
  - Teste de acessibilidade
  - Teste de estados

Exemplo:
  Button.test.tsx
    - renders with primary variant
    - calls onClick when clicked
    - is disabled when disabled prop is true
    - has correct aria-label
```

### 4.2 Hooks

```text
Todo hook deve ter:
  - Teste de comportamento
  - Teste de estados
  - Teste de efeitos colaterais

Exemplo:
  useAuth.test.ts
    - returns session when logged in
    - returns null when logged out
    - calls refresh when token expires
```

### 4.3 Services

```text
Todo serviço deve ter:
  - Teste de requisição
  - Teste de resposta
  - Teste de erro
  - Teste de retry

Exemplo:
  authService.test.ts
    - login returns session on success
    - login throws on invalid credentials
    - refresh retries on network error
```

### 4.4 Features

```text
Toda feature deve ter:
  - Teste de fluxo principal
  - Teste de fluxo alternativo
  - Teste de erro

Exemplo:
  login.feature.test.tsx
    - user can login with valid credentials
    - user sees error on invalid credentials
    - user can recover password
```

---

## 5. Ferramentas

### 5.1 Unit/Integration

| Ferramenta | Uso |
|------------|-----|
| Vitest | Test runner |
| Testing Library | Componentes |
| MSW | Mock de API |
| Jest DOM | Assertions de acessibilidade |

### 5.2 E2E

| Ferramenta | Uso |
|------------|-----|
| Playwright | Test runner |
| Playwright Config | Multi-browser |
| Playwright Report | Relatórios |

### 5.3 Acessibilidade

| Ferramenta | Uso |
|------------|-----|
| jest-axe | Acessibilidade em unit tests |
| Playwright Accessibility | Acessibilidade em E2E |

---

## 6. Padrões

### 6.1 Nomenclatura

```text
Arquivo: {nome}.test.tsx
Descrição: {ação} {resultado}

Exemplos:
  Button.test.tsx
  useAuth.test.ts
  authService.test.ts
  login.feature.test.tsx
```

### 6.2 Estrutura

```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from './Button'

describe('Button', () => {
  it('renders with primary variant', () => {
    render(<Button variant="primary">Click</Button>)
    expect(screen.getByRole('button')).toHaveClass('btn-primary')
  })

  it('calls onClick when clicked', () => {
    const onClick = vi.fn()
    render(<Button onClick={onClick}>Click</Button>)
    fireEvent.click(screen.getByRole('button'))
    expect(onClick).toHaveBeenCalledOnce()
  })
})
```

### 6.3 Mocks

```text
APIs:
  - MSW para mock de rede
  - Dados fixos para teste

Contexts:
  - Providers customizados
  - Valores padrão

Hooks:
  - Mocks de hooks externos
  - Valores de retorno fixos
```

---

## 7. Cobertura

### 7.1 Metas

| Camada | Cobertura Mínima |
|--------|------------------|
| Components | 90% |
| Hooks | 90% |
| Services | 90% |
| Utils | 95% |
| Features | 80% |
| E2E | Fluxos críticos |

### 7.2 Medição

```text
Ferramenta: Vitest coverage
Relatório: HTML + terminal
CI: Bloqueante se abaixo da meta
```

---

## 8. Acessibilidade

### 8.1 Regras

```text
Todo componente deve:
  - Ter role correto
  - Ter aria-label quando necessário
  - Ser navegável por teclado
  - Ter contraste adequado
  - Ter foco visível
```

### 8.2 Testes

```text
Testes de acessibilidade:
  - axe-core integration
  - Playwright accessibility
  - Teclado navigation
  - Screen reader simulation
```

---

## 9. Regras de Governança

### 9.1 Criação

```text
Novo componente:
1. Criar arquivo .test.tsx
2. Escrever testes básicos
3. Atingir cobertura mínima
4. Aprovar
```

### 9.2 Alteração

```text
Alterar componente:
1. Executar testes existentes
2. Adicionar testes para nova funcionalidade
3. Manter cobertura mínima
4. Aprovar
```

### 9.3 Exclusão

```text
Excluir componente:
1. Remover testes associados
2. Verificar dependências
3. Aprovar
```

---

## 10. CI/CD

### 10.1 Pipeline

```text
Pull Request:
  ├── Lint
  ├── Typecheck
  ├── Unit Tests
  ├── Integration Tests
  └── Build

Merge para main:
  ├── E2E Tests
  ├── Coverage Report
  └── Deploy
```

### 10.2 Bloqueantes

```text
PR bloqueado se:
  - Lint falhar
  - Typecheck falhar
  - Testes falharem
  - Cobertura abaixo da meta
```

---

## 11. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Baixa | FRONTEND-API.md | Documentação de API |

---

## 12. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
- FRONTEND-ARCHITECTURE
- FRONT-KERNEL-MAP
- FRONT-CONTRACTS
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação da estratégia de testes |

---

Documento Canônico — FRONTEND-TESTING

**Este é o documento oficial de estratégia de testes do frontend da plataforma New Wave Enterprise.**
