# MD-TOTEM-001 — Contrato API Canônico

## Status
Documento Canônico de Domínio.
Define o contrato de API do domínio Totem.

---

## Classificação
```text
Tipo: Domain Contract
Camada: Application Layer
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Propósito

Definir os contratos de API do domínio Totem, garantindo que o frontend consuma capacidades canônicas através de endpoints estáveis.

---

## Princípio fundamental

```text
Frontend não acessa banco.
Frontend não decide regra.
Frontend consome API do domínio.
API reflete o contrato do domínio.
```

---

## Endpoints canônicos

### GET /totem/opcoes

Lista opções de atendimento disponíveis para o totem.

**Autenticação:** Obrigatória  
**Contexto:** Obrigatório  
**Permissão:** `TOTEM_OPCOES_READ`

**Request:**
```
GET /totem/opcoes
Query:
  - id_unidade: number (obrigatório)
  - id_local_operacional: number (obrigatório)
```

**Response 200:**
```json
{
  "opcoes": [
    {
      "id_opcao": 1,
      "codigo": "CLINICO",
      "label": "Clínico",
      "lane": "ADULTO",
      "tipo_atendimento": "CLINICO",
      "prefixo": "C",
      "ordem": 1,
      "ativo": true
    }
  ]
}
```

**Response 401:**
```json
{
  "error": "SESSAO_INVALIDA",
  "message": "Sessão inválida ou expirada"
}
```

---

### GET /totem/plantao-medico

Lista plantão médico do dia.

**Autenticação:** Obrigatória  
**Contexto:** Obrigatório  
**Permissão:** `TOTEM_PLANTAO_READ`

**Request:**
```
GET /totem/plantao-medico
Query:
  - id_unidade: number (obrigatório)
  - data: string (opcional, formato ISO)
```

**Response 200:**
```json
{
  "plantao": [
    {
      "especialidade": "CLINICO",
      "medico_nome": "Dr. João Silva",
      "crm": "123456"
    }
  ]
}
```

---

### POST /totem/gerar-senha

Gera nova senha de atendimento.

**Autenticação:** Obrigatória  
**Contexto:** Obrigatório  
**Permissão:** `TOTEM_SENHA_GERAR`

**Request:**
```json
{
  "id_opcao": 1,
  "id_unidade": 1,
  "id_local_operacional": 1,
  "id_paciente": null
}
```

**Response 200:**
```json
{
  "id_senha": 123,
  "numero_senha": "C001",
  "tipo_atendimento": "CLINICO",
  "prefixo": "C",
  "uuid_transacao": "550e8400-e29b-41d4-a716-446655440000",
  "mensagem": "Senha gerada com sucesso: C001"
}
```

**Response 400:**
```json
{
  "error": "OPCAO_INVALIDA",
  "message": "Opção não encontrada"
}
```

**Response 401:**
```json
{
  "error": "SESSAO_INVALIDA",
  "message": "Sessão inválida"
}
```

---

### GET /totem/feedback

Lista feedbacks de atendimento (opcional).

**Autenticação:** Obrigatória  
**Contexto:** Obrigatório  
**Permissão:** `TOTEM_FEEDBACK_READ`

**Request:**
```
GET /totem/feedback
Query:
  - id_senha: number (opcional)
```

**Response 200:**
```json
{
  "feedbacks": [
    {
      "id_feedback": 1,
      "id_senha": 123,
      "origem": "TOTEM",
      "nota": 5,
      "comentario": "Atendimento rápido",
      "data_hora": "2026-07-29T04:00:00.000Z"
    }
  ]
}
```

---

### POST /totem/feedback

Registra feedback de atendimento.

**Autenticação:** Obrigatória  
**Contexto:** Obrigatório  
**Permissão:** `TOTEM_FEEDBACK_CREATE`

**Request:**
```json
{
  "id_senha": 123,
  "origem": "TOTEM",
  "nota": 5,
  "comentario": "Atendimento rápido"
}
```

**Response 200:**
```json
{
  "id_feedback": 1,
  "mensagem": "Feedback registrado"
}
```

---

## Contratos TypeScript

### TotemOpcao
```typescript
export interface TotemOpcao {
  id_opcao: number;
  codigo: string;
  label: string;
  lane: string;
  tipo_atendimento: string;
  prefixo: string;
  ordem: number;
  ativo: number;
}
```

### TotemPlantaoItem
```typescript
export interface TotemPlantaoItem {
  especialidade: string;
  medico_nome: string;
  crm: string;
}
```

### TotemSenhaRequest
```typescript
export interface TotemSenhaRequest {
  id_opcao: number;
  id_unidade: number;
  id_local_operacional: number;
  id_paciente?: number | null;
}
```

### TotemSenhaResponse
```typescript
export interface TotemSenhaResponse {
  id_senha: number;
  numero_senha: string;
  tipo_atendimento: string;
  prefixo: string;
  uuid_transacao: string;
  mensagem: string;
}
```

### TotemFeedbackRequest
```typescript
export interface TotemFeedbackRequest {
  id_senha: number;
  origem: string;
  nota: number;
  comentario?: string;
}
```

### TotemFeedbackResponse
```typescript
export interface TotemFeedbackResponse {
  id_feedback: number;
  mensagem: string;
}
```

---

## Regras de contrato

1. **Imutabilidade**: endpoints não mudam sem versão
2. **Padronização**: todos retornam `{ success, data, error, trace }`
3. **Auditoria**: todo request gera evento no ledger
4. **Contexto**: todo request valida sessão + tenant + unidade + local
5. **Permissão**: todo request valida capability antes de executar

---

## Referências

- `MD-TOTEM-000` — Conceito do domínio
- `MD-105-HIS-Canonical-Flow.md` — Fluxo canônico de senha
- `FRONT-CATALOG.md` — Matriz de contratos
- `packages/contracts/src/totem/TotemContracts.ts` — Implementação atual
