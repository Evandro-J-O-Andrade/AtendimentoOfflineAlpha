# MD-TOTEM-004 — Fluxo Ponta a Ponta

## Status
Documento Canônico de Domínio.
Define o fluxo ponta a ponta do domínio Totem.

---

## Classificação
```text
Tipo: Domain Flow
Camada: Application Layer
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Propósito

Definir o fluxo canônico ponta a ponta do domínio Totem, desde a interface do usuário até a persistência no banco.

---

## Princípio fundamental

```text
Fluxo canônico é único.
Toda ação passa pela espinha dorsal.
Nenhuma exceção.
```

---

## Fluxo 1 — Gerar Senha (COMMAND)

```text
React TotemSenha.tsx
    ↓
useTotemSenha.gerarSenha()
    ↓
TotemApi.gerarSenha(payload)
    ↓
POST /totem/gerar-senha
    ↓
TotemController.gerarSenha()
    ↓
TotemService.gerarSenha()
    ↓
DispatcherService.dispatch('totem', 'gerar_senha', payload)
    ↓
sp_master_dispatcher
    ↓
Executor Totem.gerar_senha
    ↓
sp_totem_gerar_senha
    ↓
senha_sequencia (número)
    ↓
senha (registro)
    ↓
totem_evento (evento)
    ↓
sp_ledger_evento_log (auditoria)
    ↓
Response: TotemSenhaResponse
    ↓
React exibe senha + imprime ticket
```

**Critério de sucesso:**
- Senha criada no banco
- Evento registrado
- Ledger registrado
- Frontend recebe número
- Impressão validada

---

## Fluxo 2 — Listar Opções (QUERY)

```text
React TotemSenha.tsx
    ↓
useTotemSenha.carregarDados()
    ↓
TotemApi.listarOpcoes()
    ↓
GET /totem/opcoes
    ↓
TotemController.listarOpcoes()
    ↓
TotemService.listarOpcoes()
    ↓
DispatcherService.dispatch('totem', 'opcoes_get', params)
    ↓
Executor Totem.opcoes_get
    ↓
Query totem_senha_opcao
    ↓
Response: TotemOpcao[]
    ↓
React renderiza botões
```

**Critério de sucesso:**
- Opções carregadas
- Agrupadas por lane
- Botões renderizados

---

## Fluxo 3 — Plantão Médico (QUERY)

```text
React TotemSenha.tsx
    ↓
useTotemSenha.carregarDados()
    ↓
TotemApi.buscarPlantaoMedico()
    ↓
GET /totem/plantao-medico
    ↓
TotemController.buscarPlantaoMedico()
    ↓
TotemService.buscarPlantaoMedico()
    ↓
DispatcherService.dispatch('totem', 'plantao_medico_get', params)
    ↓
Executor Totem.plantao_medico_get
    ↓
Consulta fonte canônica de escala
    ↓
Response: TotemPlantaoItem[]
    ↓
React renderiza plantão
```

**Critério de sucesso:**
- Plantão carregado
- Médicos e especialidades exibidos

---

## Fluxo 4 — Feedback (COMMAND)

```text
React TotemSatisfacao.tsx
    ↓
useTotemFeedback.registrarFeedback()
    ↓
TotemApi.registrarFeedback()
    ↓
POST /totem/feedback
    ↓
TotemController.registrarFeedback()
    ↓
TotemService.registrarFeedback()
    ↓
DispatcherService.dispatch('totem', 'feedback_create', payload)
    ↓
Executor Totem.feedback_create
    ↓
totem_feedback (insert)
    ↓
sp_ledger_evento_log (auditoria)
    ↓
Response: TotemFeedbackResponse
    ↓
React exibe confirmação
```

**Critério de sucesso:**
- Feedback registrado
- Auditoria realizada
- Confirmação exibida

---

## Matriz de fluxo

| Fluxo | Tipo | Endpoint | Capability | Executor | SP | Critério de sucesso |
|-------|------|----------|------------|----------|----|---------------------|
| Gerar Senha | COMMAND | POST /totem/gerar-senha | TOTEM_SENHA_GERAR | totem.gerar_senha | sp_totem_gerar_senha | Senha criada + evento + ledger |
| Listar Opções | QUERY | GET /totem/opcoes | TOTEM_OPCOES_READ | totem.opcoes_get | totem_senha_opcao | Opções carregadas |
| Plantão Médico | QUERY | GET /totem/plantao-medico | TOTEM_PLANTAO_READ | totem.plantao_medico_get | fonte canônica | Plantão carregado |
| Ler Feedback | QUERY | GET /totem/feedback | TOTEM_FEEDBACK_READ | totem.feedback_get | totem_feedback | Feedbacks listados |
| Criar Feedback | COMMAND | POST /totem/feedback | TOTEM_FEEDBACK_CREATE | totem.feedback_create | totem_feedback | Feedback criado + ledger |

---

## Regras de fluxo

1. Todo fluxo COMMAND valida sessão + permissão + contexto
2. Todo fluxo COMMAND registra auditoria no ledger
3. Todo fluxo QUERY valida sessão + permissão
4. Erros retornam contrato padronizado
5. Nenhum fluxo acessa banco diretamente

---

## Critério de encerramento do GATE

O domínio Totem sai de materialização quando:

```text
✓ POST /totem/gerar-senha → 200
✓ Senha criada no banco
✓ Evento registrado
✓ Ledger registrado
✓ Frontend recebe número
✓ Impressão validada
✓ GET /totem/opcoes → 200
✓ GET /totem/plantao-medico → 200
✓ POST /totem/feedback → 200
✓ Todos os fluxos passam pelo Dispatcher
✓ Nenhuma regra de negócio no frontend
```

---

## Referências

- `MD-TOTEM-000` — Conceito do domínio
- `MD-TOTEM-001` — Contrato API
- `MD-TOTEM-002` — Capability Registry
- `MD-TOTEM-003` — Executor Mapping
- `MAP-005-Portal-Architecture.md` — Portal Runtime
- `MD-103-Dispatcher-Execution-Model.md` — Dispatcher Execution Model
