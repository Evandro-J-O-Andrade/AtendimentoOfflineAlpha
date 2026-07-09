# AI_CONTEXT.md — Memória Permanente do Projeto

> **Arquivo de memória da plataforma.** Reutilize este arquivo em TODA nova
> conversa com qualquer IA (Gemini, ChatGPT, Claude, Copilot, Kilo, AVA).
> Ele é a fonte da verdade consolidada. Não invente tabelas, campos, APIs,
> regras ou arquitetura fora do que está documentado aqui e em
> `docs/canonical/`.

---

## 1. Identidade do Projeto

- **Projeto:** `AtendimentoOfflineAlpha`
- **Plataforma:** **Midas Enterprise** — Sistema Operacional Unificado SaaS,
  multi-tenant, cognitivo, offline-first.
- **Natureza:** NÃO é ERP, CRM, HIS ou coleção de apps. É a plataforma que
  torna qualquer um desses uma extensão natural (o HIS é apenas uma App).
- **Propósito:** Amplificar a capacidade humana de criar, decidir e crescer.
  Tecnologia é meio; Pessoa é fim; Dados são ativos; Conhecimento é poder.

### Documentos Supremos (leia-os na íntegra quando possível)
1. `000-CONSTITUICAO-PLATAFORMA.md` — Constituição da Plataforma (CANÔNICO, CONSOLIDADO)
2. `000-CONSTITUICAO-IA.md` — Guia Operacional das IAs (62 regras)
3. `docs/canonical/MD-110-Canonical-Laws.md` — Leis Canônicas Supremas
4. `docs/canonical/MD-CONSOLIDADO-001-Plataforma-Enterprise-Architecture.md`
5. `docs/canonical/MODELO_DOMINIO_CANONICO.md` — Entidades canônicas
6. `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md`
7. `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md`
8. `docs/canonical/ROADMAP_CANONICO.md`

### Hierarquia de Verdade (em conflito, prevalece a de cima)
```
BANCO (MySQL)  → Fonte da Verdade
  └─ Stored Procedures → Regra de Negócio Canônica
      └─ Event Store (kernel_ledger) → Rastro Oficial
          └─ Analytics (derivado)
              └─ BI / Dashboards (derivado)
                  └─ Frontend (leitura/projeção)
                      └─ Cache (atalho, NUNCA verdade)
```

---

## 2. Regras Obrigatórias (NÃO VIOLAR)

### Princípios Absolutos
- **Banco (MySQL) é a única fonte operacional da verdade.**
- **Stored Procedure é a ÚNICA porta de escrita.** Nunca INSERT/UPDATE/DELETE direto em tabela de negócio.
- **Regra de negócio vive na SP.** Proibido em frontend, controller, service, middleware, N8N, IA.
- **Evento é a memória.** Append-only, imutável, consultável. Sem evento não existe operação.
- **Nenhuma deleção física.** Cancelamento = novo evento; Remoção = status inativo (soft delete).
- **Multi-tenant transversal.** Todo dado carrega `id_tenant`; toda query filtra por tenant; todo evento registra tenant.
- **Pessoa é raiz.** Identidade pertence à Pessoa, não ao Tenant.

### Fluxo de Acesso Obrigatório
```
Login → Portal → IAM → Selecionar Contexto → Workspace → App Registry → App → Dashboard → Operação
```
- Nunca abrir App direto por URL (`localhost:5173/...`).
- Portal orquestra; Apps executam. Portal não tem regra de negócio.

### Fluxo de Execução Canônico (Backend)
```
Route → Controller → Dispatcher → Orquestrador → Executor → SP → Ledger → Response
```
- Dispatcher valida contrato + permissão + chama SP + registra evento. **Não executa regra de negócio.**
- Node é gateway de transporte (valida sessão/contexto, roteia). Não decide regra.
- APIs são **stateless**. Redis é cache, nunca fonte da verdade.

### Classificação de Procedures (nunca copiar legado literalmente)
`Dispatcher | Orquestrador | Executor | Validator | Ledger | Runtime | IAM | Kernel | Workflow`

### Database
- **Views** = leitura (`vw_painel_fila`, `vw_dashboard_urgencia`).
- **Functions** = cálculo (`idade()`, `tempo_espera()`, `score()`).
- **Triggers proibidas** para lógica de negócio (só auditoria técnica, integração DB, performance).

### Identidade & Segurança
- **IAM decide acesso** = `identidade + tenant + app + escopo + permissão + contexto`.
- JWT em Cookie **HttpOnly, Secure, SameSite=Strict**. **Nunca localStorage/sessionStorage/URL**.
- MFA obrigatório (internos/admins; recomendado para todos).
- Identidade é permanente; Contexto é variável (1 usuário, múltiplos tenants/perfis, sem novo login).

### Workflow / N8N
- N8N é infraestrutura canônica, versionada e auditada. Sem aprovação não vai a produção.
- Credenciais no Vault, nunca no código. Workflow segue `Dispatcher → Orquestrador → Executor → Evento`.

### IA
- **IA sugere, não decide.** Não altera dados sem autorização humana explícita. Todo output é auditável.
- Toda IA segue a mesma constituição (sem privilégio arquitetural).

### Anti-Patterns Proibidos (resumo)
```
❌ Regra de negócio fora da SP            ❌ CRUD direto em tabela
❌ SELECT sem filtro de tenant           ❌ INSERT/UPDATE/DELETE sem SP
❌ Deleção física                         ❌ Criar v2/final/backup/old/temp
❌ Frontend decide permissão              ❌ App decide acesso
❌ Token em localStorage                  ❌ App fora do Registry
❌ Frontend acessando banco               ❌ Backend alterando tabela direto
❌ Trigger com lógica de negócio         ❌ Redis como fonte da verdade
❌ Usar código legado como referência     ❌ App standalone em localhost
❌ Push direto para main / commit c/ segredo / log c/ dado sensível
```

### Regras de Conduta da IA (manter projeto íntegro)
- **Nunca assumir:** procure em MD/MAP/BR → dump (análise, não cópia) → código → só então infere e documenta.
- **Nunca renomear, mover ou reorganizar** arquivos/pastas sem autorização.
- **Nunca apagar** arquivos/tabelas/procedures/docs; marque como obsoleto.
- **Nunca gerar V2/final/novo/copy/backup/old/temp.**
- **Sempre procurar primeiro:** existe? → atualize; não existe? → crie.
- Pense como **Arquiteto Enterprise**, nunca como Programador.
- Legado (`legacy/`) é somente leitura — conhecimento, não implementação.

---

## 3. Estrutura do Projeto (Monorepo Canônico)

```
AtendimentoOfflineAlpha/
├── apps/                 # Apps canônicas (domínios isolados)
│   ├── portal/           # Portal Enterprise (launcher oficial, único frontend canônico)
│   ├── saude/            # Domínio Saúde (HIS)
│   ├── financeiro/  rh/  crm/  analytic/  social/  chat/  wiki/
├── backend/              # Backend canônico único
│   ├── modules/          # iam, portal, saude, ... (isolados)
│   ├── gateway/          # API Gateway
│   ├── dispatcher/       # Dispatcher canônico
│   ├── sdk/  contracts/
├── packages/             # Compartilhados
│   ├── ui/   auth/  contexto/  eventos/  sdk/  runtime/  shared/
├── database/
│   ├── schema/           # Dump20260606.sql (FREEZE — banco congelado)
│   ├── procedures/  views/  migrations/  seeds/  ledger/
├── workflow/             # Workflows por domínio (N8N)
├── runtime/              # offline-first: sync-engine, cache, workers, queue
├── dashboards/  dispositivos/ (tv/totem/kiosk/mobile)  integracoes/
├── ia/                   # Copilots, Agents, RAG
├── docs/canonical/       # MD-*, MAP-*, BR-*, FRONT-*, ADR-*, LIVRO-*
├── legacy/               # Código congelado (somente leitura)
```

**Regras da árvore:** proibido `src/` alternativo, `v2`, `backend2`, `apps` paralelos, misturar legado com canônico.

---

## 4. Modelo de Domínio Canônico (Entidades Raiz)

```sql
saas_entidade(id_saas_entidade, nome_fantasia, razao_social, cnpj, logo_url, cor_primaria, cor_secundaria, ativo)
  └─ pessoa(id_pessoa, nome, data_nascimento, sexo, cpf, rg, telefone, email, endereco)  -- RAIZ
       └─ usuario(id_usuario, id_pessoa, login, senha_hash, ativo)
            └─ sessao_usuario(id_sessao_usuario, id_usuario, id_saas_entidade, token, refresh_token, ativo)

contexto_operacional(id_contexto, id_saas_entidade, tipo[UNIDADE|LOCAL|SETOR|SALA|PAINEL|GUICHE], id_referencia, nome, codigo)
aplicacao(id_aplicacao, id_saas_entidade, nome, codigo, rota, icone, ativo)
evento(id_evento, id_sessao_usuario, id_aplicacao, id_contexto, tipo, categoria, acao, payload, resultado, data_hora, ip_origem)
auditoria(id_auditoria, id_evento, id_usuario, acao, tabela, id_registro, dados_antigos, dados_novos, data_hora, ip_origem)
```

### Domínio Assistencial (HIS) — Sequência Obrigatória
```
Pessoa → Senha → FFA (Ficha de Atendimento) → GPAT (Protocolo) → Atendimento → Triagem → Execução → Farmácia → Faturamento
```
Tabelas: `senha(id_senha, id_pessoa, id_unidade, numero, tipo, prioridade, status)`,
`ffa(id_ffa, id_senha, id_pessoa, id_unidade, id_local, id_usuario_criacao, status)`,
`gpat(id_gpat, id_ffa, codigo, status)`.

### Proibições de Modelo
- Não criar `paciente_v2`, `cliente_novo`, `usuario_alt`.
- Não criar `sp_novo`, `sp_revisado`, `sp_v3`.
- Toda entidade nova segue o modelo canônico de auditoria e gera evento.

---

## 5. Módulos / Domínios (Classificação)

| Domínio | Papel |
|---------|-------|
| CORE | Plataforma, Runtime, Dispatcher, Kernel, HIS, CRM, RH, Finance |
| IAM | Identidade, Auth, Permissões, Contexto |
| PORTAL | App Registry, Dashboard, Shell, UX (layout estilo Windows-8 / tiles) |
| WORKFLOW | N8N, Automação, Legados |
| KERNEL | Runtime, Sync, Edge, Offline-First |
| SOCIAL / CHAT | Comunicação, colaboração, tempo real |
| WIKI | Documentação, conhecimento |
| ANALYTICS | Dados, métricas, KPIs, BI |

> Se for **APP** específica de tenant: NUNCA subir para CORE. Use extensão via AppRegistry/SDK.

---

## 6. Padrões de Código

- **React:** apenas projeção. Renderiza, envia comandos, consome API via `packages/sdk`. Sem regra de negócio, sem validação de permissão, sem acesso a banco. Respeita `packages/ui` (Design System canônico).
- **Node/Backend:** gateway stateless. Valida sessão/contexto, roteia ao Dispatcher. Não decide regra nem acessa tabelas direto.
- **SP:** única escrita. Uma responsabilidade por procedure, classificada (Dispatcher/Orquestrador/Executor/...).
- **Apps:** cada domínio é App isolada em `apps/[dominio]/` com `app.tsx`, `routes.ts`, `manifest.ts`, `pages/`, `widgets/`, `services/`, `hooks/`, `types/`, `api/`. Comunicação entre Apps só via API/SDK.
- **Runtime:** Sync Engine, Heartbeat, Workers, Fila, Single Writer, Idempotência, Cache (invalidado por evento), Locks.
- **Versionamento:** MAJOR.MINOR.PATCH com changelog. CI/CD: Lint → Testes → Build → Validação de contrato → Auditoria → Homolog → Produção.

---

## 7. Convenções de Documentação

- `docs/canonical/MD-*.md` (leis), `MAP-*.md` (arquitetura), `BR-*.md` (regras de negócio),
  `FRONT-*.md` (UX), `ADR-*.md` (decisões), `LIVRO-*` (constituição completa).
- Todo documento declara **Status** (RASCUNHO, EM EVOLUÇÃO, CANÔNICO, FREEZE, AUDITADO...)
  e **Relacionamentos** (Depende de / Relacionado com / Usado por / Estende / Substitui).
- Alteração arquitetural exige ADR + aprovação + atualização de MDs/MAPs afetados.

---

## 8. Glossário de Leis-Chave (MD-110)

- **LEI 01** Portal é a Porta · **LEI 02** Apps Executam · **LEI 03** IA Auxilia Não Decide
- **LEI 05** Regra na SP · **LEI 06** Toda App no Registry · **LEI 07** Toda Integração com IAM
- **LEI 09** Expansão Sem Ilhas · **LEI 11** Authorization is Decision · **LEI 13** Senha é entrada do HIS
- **LEI 14** Multi-Tenant Transversal · **LEI 15** Evento é Rastro Oficial · **LEI 21** Banco é Fonte da Verdade
- **LEI 17** Frontend é Janela · **LEI 18** Backend é Porteiro · **LEI 19** Dispatcher Orquestra · **LEI 22** APIs Stateless

---

## 9. Instrução para IAs (cole como primeiro prompt)

> Este é um projeto de longa duração. Leia TODOS os arquivos anexados antes de
> responder. Considere estes documentos como a fonte da verdade. Nunca invente
> tabelas, campos, APIs, regras ou arquitetura. Sempre respeite a arquitetura
> definida. Se faltar informação, pergunte antes de gerar código. Durante toda
> a conversa, responda utilizando este contexto.

Após a leitura, peça o resumo interno:
> Resuma tudo o que entendeu: arquitetura, banco, módulos, padrões de código,
> convenções, regras de negócio e fluxo do sistema. Esse resumo será o contexto
> permanente desta conversa.

---

**Última atualização:** 2026-07-08 — derivado de `000-CONSTITUICAO-PLATAFORMA.md`,
`000-CONSTITUICAO-IA.md`, `MD-110-Canonical-Laws.md`, `MD-CONSOLIDADO-001`,
`MODELO_DOMINIO_CANONICO.md`.
