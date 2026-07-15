# SPEC-LOGIN-PAGE

## Status

```text
ESPECIFICAÇÃO (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Correções obrigatórias da Login Page.
```

---

## 1. Propósito

Este documento é a **especificação oficial de correções da Login Page** da plataforma New Wave Enterprise.

Ele serve para:
- Registrar bloqueadores que impedem a página de funcionar
- Registrar correções visuais necessárias
- Registrar correções funcionais necessárias
- Servir como contrato para implementação

Nenhuma alteração visual é feita sem passar por esta especificação.

---

## 2. Bloqueadores

Itens que impedem a página de funcionar corretamente.

### BLOQ-01 — Layout com overflow

| Campo | Valor |
|-------|-------|
| **Problema** | Página permite scroll horizontal e vertical quando não deveria |
| **Causa** | `overflow-x: hidden` insuficiente; elementos com width > 100% |
| **Solução** | `height: 100vh` + `overflow: hidden` em `.pageLayout`; `.mainContent` com `overflow: hidden`; card pode ter scroll apenas em mobile |
| **Critério de aceitação** | Nenhum scroll horizontal em nenhuma resolução; nenhum scroll vertical quando o card couber na tela |

### BLOQ-02 — Autenticação não chega ao backend

| Campo | Valor |
|-------|-------|
| **Problema** | Formulário envia dados mas backend/SP não são chamados |
| **Causa** | A verificar: endpoint, baseUrl, CORS, timeout, tratamento de erro |
| **Solução** | Garantir fluxo completo: Login → POST → Backend → SP `sp_master_login` → Sessão → Token → Retorno |
| **Critério de aceitação** | Login válido retorna token; login inválido retorna erro; erros de rede são tratados |

### BLOQ-03 — MFA não validado

| Campo | Valor |
|-------|-------|
| **Problema** | Estado `MFA_REQUIRED` pode não estar funcionando |
| **Causa** | A verificar: contrato de resposta, estado, fluxo de retorno |
| **Solução** | Garantir fluxo: Login → MFA_REQUIRED → Tela MFA → Confirmação → Portal |
| **Critério de aceitação** | MFA é exibido quando backend retorna `state: 'MFA_REQUIRED'` |

---

## 3. Correções Visuais

### VIS-01 — Hero esquerdo

| Campo | Valor |
|-------|-------|
| **Problema** | Falta estrutura hero institucional |
| **Solução** | Adicionar overlay gradiente, logo, título, texto e ícones institucionais |
| **Estrutura** | Cidade (background) → Overlay → Logo → Título → Subtítulo → Ícones |

### VIS-02 — Card de login

| Campo | Valor |
|-------|-------|
| **Problema** | Card pequeno, sem efeito glass |
| **Solução** | Aumentar padding, borda, radius, adicionar glass effect |
| **Critério de aceitação** | Card visualmente igual ao mockup |

### VIS-03 — Logo no formulário

| Campo | Valor |
|-------|-------|
| **Problema** | Logo pequena, distante do título |
| **Solução** | Aumentar para ~160px, reduzir margem inferior |
| **Critério de aceitação** | Logo centralizada acima do título, espaçamento adequado |

### VIS-04 — Inputs

| Campo | Valor |
|-------|-------|
| **Problema** | Altura, padding, borda e alinhamento de ícones incorretos |
| **Solução** | Ajustar padding, radius, posicionamento absoluto dos ícones |
| **Critério de aceitação** | Ícones centralizados verticalmente dentro dos campos |

### VIS-05 — Botão de ver senha

| Campo | Valor |
|-------|-------|
| **Problema** | Botão fora do container do input |
| **Solução** | Garantir posicionamento absoluto dentro de `.inputWrapper` com padding direito adequado |
| **Critério de aceitação** | Botão dentro do campo, alinhado à direita |

### VIS-06 — Ícones dos badges

| Campo | Valor |
|-------|-------|
| **Problema** | Ícones não aparecem (bolinhas pretas) |
| **Causa** | SVG sem `fill: currentColor` ou herança de cor incorreta |
| **Solução** | Adicionar `.badgeIcon path { fill: currentColor; }` |
| **Critério de aceitação** | 🛡 Segurança, ☁ Alta Disponibilidade, 🔒 Conformidade visíveis |

### VIS-07 — Botão Entrar

| Campo | Valor |
|-------|-------|
| **Problema** | Texto incorreto durante loading |
| **Solução** | Estados: `Entrar` (normal), `Entrando...` (loading) |
| **Critério de aceitação** | Nunca mostrar "Processando" |

### VIS-08 — Tema claro/escuro

| Campo | Valor |
|-------|-------|
| **Problema** | Apenas botão, sem funcionamento real |
| **Solução** | Implementar troca real com classes `.themeDark` / `.themeLight` |
| **Cores tema claro** | `#EDF6FF`, `#DDEEFF`, `#F8FBFF`, `#D3E8FF`, `#A9CCF8` |
| **Critério de aceitação** | Toda a página troca de tema sem recarregar |

### VIS-09 — Ícone Lua

| Campo | Valor |
|-------|-------|
| **Problema** | Desalinhado verticalmente |
| **Solução** | Garantir alinhamento vertical perfeito com o texto |
| **Critério de aceitação** | Ícone e texto no mesmo eixo vertical |

### VIS-10 — Footer

| Campo | Valor |
|-------|-------|
| **Problema** | Espaçamento incorreto |
| **Solução** | Ajustar gap entre logo, texto e CEO |
| **Critério de aceitação** | Igual ao mockup |

### VIS-11 — Responsividade

| Campo | Valor |
|-------|-------|
| **Problema** | Layout quebra em algumas resoluções |
| **Solução** | Testar em 1920, 1600, 1440, 1366, notebook, tablet, mobile |
| **Critério de aceitação** | Nenhuma quebra em nenhuma resolução |

---

## 4. Correções Funcionais

### FUN-01 — Autenticação real

| Campo | Valor |
|-------|-------|
| **Problema** | Login não chega ao backend |
| **Solução** | Garantir: endpoint `/auth/login`, método POST, body correto, resposta mapeada |
| **Fluxo** | Login → POST → Backend → SP `sp_master_login` → Sessão → Token → Retorno → Portal |
| **Critério de aceitação** | Login válido autentica; login inválido retorna erro; erros são tratados |

### FUN-02 — MFA real

| Campo | Valor |
|-------|-------|
| **Problema** | MFA pode não estar funcionando |
| **Solução** | Garantir fluxo: Login → `MFA_REQUIRED` → Tela MFA → Confirmação → Portal |
| **Critério de aceitação** | MFA é exibido e confirmado corretamente |

---

## 5. Refatoração

### REF-01 — Componentes

| Campo | Valor |
|-------|-------|
| **Problema** | Código monolítico |
| **Solução** | Separar em: `LoginHero.tsx`, `LoginCard.tsx`, `LoginFooter.tsx`, `ThemeProvider`, `LoginPage.module.css` |
| **Critério de aceitação** | Cada componente com responsabilidade única, CSS sem duplicação |

---

## 6. Fidelidade Visual

| Campo | Valor |
|-------|-------|
| **Objetivo** | Reproduzir mockup com fidelidade > 95% |
| **Restrições** | Manter arquitetura atual, não criar mocks, não criar placeholders |
| **Critério de aceitação** | Visual igual ao mockup; todos os componentes funcionais |

---

## 7. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-15 | Kilo | Especificação de correções da Login Page |

---

Documento Canônico — SPEC-LOGIN-PAGE

**Esta é a especificação oficial de correções da Login Page da plataforma New Wave Enterprise.**
