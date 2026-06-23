# LC-001 → LC-018 — Leis Canônicas Globais

## Status
Documento Canônico de Arquitetura.
Constituição arquitetural da Plataforma Midas.

---

# Lei Canônica Global LC-001
```text
Portal é a entrada oficial da plataforma.
```
Fluxo:
```text
Login
↓
Portal
↓
Container/App
↓
Contexto Operacional
↓
Dashboard
↓
Operação
```

---

# Lei Canônica Global LC-002
```text
Login não define contexto.
```
Login responde: "Quem é você?"
Contexto responde: "Onde você está operando?"

---

# Lei Canônica Global LC-003
```text
Identity ≠ Operational Context
```
Exemplo:
```text
João
↓
Login
```
Pode acessar:
```text
Hospital A → Médico
Hospital B → Coordenador
```

---

# Lei Canônica Global LC-004
```text
Todo domínio possui dashboard próprio.
```
HIS: Dashboard Assistencial
CRM: Dashboard Comercial
RH: Dashboard Pessoas
Financeiro: Dashboard Financeiro
Farmácia: Dashboard Farmacêutico
Analytics: Dashboard Executivo

---

# Lei Canônica Global LC-005
```text
Senha é o núcleo operacional assistencial.
```
Incorreto: Paciente → Atendimento
Correto: Senha → Fila → FFA → Atendimento → Execução → Farmácia → Faturamento

---

# Lei Canônica Global LC-006
```text
Paciente possui histórico. Senha possui fluxo.
```
Paciente: entidade longitudinal.
Senha: entidade operacional.

---

# Lei Canônica Global LC-007
```text
SP First Architecture.
```
Todo operação crítica:
```text
Frontend → API → Application Service → Dispatcher → Stored Procedure → Database
```
Nunca: Frontend → CRUD direto → Tabela

---

# Lei Canônica Global LC-008
```text
Banco é a fonte da verdade.
```
Nunca: JWT/Cache/Frontend
Sempre: Database

---

# Lei Canônica Global LC-009
```text
JWT é mecanismo de transporte.
```
Estratégia: JWT + HttpOnly Cookie + Session Validation
Proibido: localStorage, sessionStorage para auth

---

# Lei Canônica Global LC-010
```text
LGPD First.
```
Toda entidade deve possuir quando aplicável:
```text
Finalidade
Consentimento
Retenção
Auditoria
Anonimização
```

---

# Lei Canônica Global LC-011
```text
Audit First.
```
Toda ação crítica gera:
```text
Evento → Timeline → Auditoria → Observabilidade
```

---

# Lei Canônica Global LC-012
```text
Tenant First.
```
Toda operação executa dentro de:
```text
Tenant → Organização → Unidade → Setor → Local
```

---

# Lei Canônica Global LC-013
```text
IA é transversal.
```
AI Core consumido por:
```text
Portal, HIS, CRM, RH, Financeiro, Analytics, Workflow, Documentos
```

---

# Lei Canônica Global LC-014
```text
Application Registry é obrigatório.
```
Nenhum módulo existe sem registro.

---

# Lei Canônica Global LC-015
```text
Portal é Hub Corporativo.
```
Portal não é dashboard, intranet ou HIS. É o orquestrador da experiência.

---

# Lei Canônica Global LC-016
```text
Intranet é aplicação.
```
Assim como Chat, AVA, CRM, HIS, RH, Financeiro.

---

# Lei Canônica Global LC-017
```text
Dispatcher Layer é obrigatório.
```
Modelo oficial:
```text
Controller → Application Service → Dispatcher → Stored Procedure → Database
```

---

# Lei Canônica Global LC-018
```text
Toda operação deve ser rastreável.
```
```
Usuário → Contexto → Ação → Evento → Auditoria → Timeline
```

---

# Integrações
| MD/FINALIDADE |
|----------|
| MD-110 — Canonical Laws | Leis supremas |
| MD-107 — Tenant Architecture | Multi-tenant |
| MAP-001 → MAP-020 | Domínios |
| MD-065 — Observability | Rastreabilidade |

---

# Status Atual
```
LC-001 a LC-018: ✅ CANONIZADAS
```

---