# MD-102 — SP First Architecture

## Status

Documento Canônico Fundacional de Execução.
Determina que toda regra de negócio reside em Stored Procedures.

---

## Objetivo

Garantir que toda regra de negócio, validação e escrita opere exclusivamente no banco.

---

## Princípio

```text
Nenhuma regra de negócio no frontend.
Nenhuma regra de negócio no backend Node.
Nenhum CRUD direto.
Toda operação relevante passa por Stored Procedure.
```

---

## Camadas de Execução

```
┌─────────────────────────────────────────────┐
│                FRONTEND                      │
│     (React/PWA - sem regra de negócio)       │
└──────────────────┬──────────────────────────┘
                   │ API Call
┌──────────────────▼──────────────────────────┐
│           BACKEND / NODE                     │
│   (roteamento, auth, validação de sessão)   │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│            DISPATCHER                        │
│    (MD-003 — fluxo canônico)                 │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         STORED PROCEDURE                     │
│      (regra de negócio canônica)             │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               EVENT STORE                    │
│          (rastro oficial)                    │
└─────────────────────────────────────────────┘
```

---

## Regras

| Regra | Descrição |
|-------|-----------|
| Regra #1 | Frontend NÃO decide regra de negócio |
| Regra #2 | Backend NÃO decide regra de negócio |
| Regra #3 | Nenhum INSERT/UPDATE/DELETE direto em tabela |
| Regra #4 | Toda operação relevante tem SP própria |
| Regra #5 | SP valida permissões antes de executar |
| Regra #6 | SP valida contexto operacional |
| Regra #7 | SP valida tenant/unidade/local |
| Regra #8 | SP gera evento após sucesso |
| Regra #9 | SP retorna código canônico de resultado |
| Regra #10 | Erro em SP NÃO deixa estado inconsistente |

---

## Categorias de SP Canônicas

| Categoria | Prefixo | Domínio |
|-----------|---------|---------|
| Auth | `sp_auth_*` | Login, permissão, contexto |
| Dispatcher | `sp_checkpoint_*`, `sp_checkpoint_*` | Roteamento seguro |
| Operacional | `sp_atendimento_*`, `sp_chamar_senha` | HIS, fila, senha |
| Farmácia | `sp_farmacia_*` | Dispensação, estoque |
| Faturamento | `sp_faturamento_*` | Faturamento, conciliação |
| CAT | `sp_cat_*` | Notificação compulsória |
| Admin | `sp_admin_*`, `seed_*` | Administração |
| Auditoria | `sp_auditar_*` | Rastro de auditoria |

---

## Integrações

```text
MD-001 — Núcleo da Plataforma
MD-002 — Autenticação
MD-003 — Contexto Operacional
MD-004 — Dispatcher
MD-005 — Event Store Core
MD-010 — Security
MD-016 — Auditoria
MD-017 — Multi-Tenant
MD-034 — Identity Access Management
MD-101 — Canonical Data Architecture
MD-103 — Dispatcher Execution Model
MD-104 — Event Convergence Architecture
```

---

## Responsabilidades

- **Frontend:** Exibe, captura input, dispara API.
- **Backend Node:** Autentica sessão, valida contexto, chama SP.
- **Dispatcher:** Encaminha requisição para SP correta, trata erros.
- **SP:** Executa regra de negócio, valida permissões, altera dados.
- **Evento:** Registra rastro sem quebrar transação principal.

---

## Proibições

```text
Proibido criar regra de negócio em controller
Proibido criar regra de negócio em service Node
Proibido criar regra de negócio em middleware
Proibido criar regra de negócio em stored procedure auxiliar que não seja a canônica
Proibido criar regra de negócio em frontend
Proibido criar regra de negócio em N8N
Proibido criar regra de negócio em IA
```

---

## Lei Final

```text
SP é a única porta de escrita.
Backend é o porteiro.
Frontend é a janela.
Banco é a verdade.
```
