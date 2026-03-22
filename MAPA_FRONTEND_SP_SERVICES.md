# Mapa de Integração Frontend ↔ Stored Procedures

## Visão Geral do Fluxo

```
┌─────────────────┐
│  LoginForm.jsx  │ ──post──> sp_auth_login
└────────┬────────┘
         │ retorna token + id_sessao_usuario
         ▼
┌──────────────────────────────────────┐
│  UserService.getUser()               │ ──getUser──> sp_master_query_dispatcher → USUARIO
│  PermissionService.getPermissoes()   │ ──getUser──> sp_master_query_dispatcher → PERMISSAO_USUARIO
└──────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    DASHBOARD / INTERFACE PRINCIPAL                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────┐    ┌──────────────────┐    ┌───────────────┐  │
│  │ Triagem.jsx      │    │ FilaEspera.jsx   │    │ Paciente.jsx │  │
│  │ ─────────────    │    │ ─────────────    │    │ ──────────── │  │
│  │ getUser          │    │ getUser          │    │ request      │  │
│  │ TRIAGEM          │    │ FILA_ESPERA      │    │ PACIENTE     │  │
│  └──────────────────┘    └──────────────────┘    └───────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  FluxoAtendimento.jsx (AssistencialService)                  │   │
│  │  ──────────────────────────────────────────────────────────  │   │
│  │  request  ──> sp_master_assistencial (tipo: request)        │   │
│  │  post     ──> sp_master_assistencial (tipo: post)           │   │
│  │  push     ──> sp_master_assistencial (tipo: push)           │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 1. Autenticação

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `LoginForm.jsx` | `sp_auth_login` | post | `{ login, senha, id_unidade, id_local }` |

**Retorno:**
```json
{
  "token": "jwt_token_aqui",
  "id_sessao_usuario": 123,
  "id_usuario": 456,
  "id_unidade": 1
}
```

---

## 2. Dados do Usuário

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `UserService.js` | `sp_master_query_dispatcher` | getUser | `{ id_sessao }` |

**Módulo:** `USUARIO`

**Retorno:**
```json
{
  "id_usuario": 456,
  "nome": "Dr. João Silva",
  "login": "joao.silva",
  "especialidade": "Clínico Geral",
  "id_unidade": 1,
  "local_ativo": "Recepção"
}
```

---

## 3. Permissões

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `PermissionService.js` | `sp_master_query_dispatcher` | getUser | `{ id_usuario_alvo }` |

**Módulo:** `PERMISSAO_USUARIO`

**Retorno:**
```json
[
  { "id": 1, "codigo": "TRIAGEM_INICIAR", "nome": "Iniciar Triagem" },
  { "id": 2, "codigo": "PACIENTE_CADASTRAR", "nome": "Cadastrar Paciente" }
]
```

---

## 4. Paciente

### Busca por Nome/CPF

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `PacienteService.js` | `sp_master_query_dispatcher` | request | `{ nome?, cpf? }` |

**Módulo:** `PACIENTE`

**Payload exemplo:**
```json
{ "nome": "Maria" }
```

**Retorno:**
```json
[
  { "id": 1, "nome": "Maria da Silva", "cpf": "123.456.789-00", "nascimento": "1990-05-15" }
]
```

### Timeline do Paciente

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `PacienteService.js` | `sp_master_query_dispatcher` | request | `{ id_ffa }` |

**Módulo:** `PACIENTE_TIMELINE`

**Payload:**
```json
{ "id_ffa": 123 }
```

**Retorno:**
```json
{
  "id_ffa": 123,
  "paciente": "Maria da Silva",
  "status_atual": "EM_ATENDIMENTO",
  "abertura_ficha": "2026-03-21T10:30:00",
  "triagem": {
    "classificacao": "URGENTE",
    "cor": "VERMELHO",
    "pa": "120/80",
    "temp": "36.5",
    "queixa": "Dor no peito"
  },
  "eventos": [
    { "data": "2026-03-21T10:30:00", "tipo": "CHEGADA", "descricao": "Paciente chegou à recepção" },
    { "data": "2026-03-21T10:45:00", "tipo": "TRIAGEM", "descricao": "Triagem realizada" }
  ]
}
```

---

## 5. Triagem e Fila

### Triagem (pacientes aguardando)

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `FilaService.js` | `sp_master_query_dispatcher` | getUser | `{}` |

**Módulo:** `TRIAGEM`

**Retorno:**
```json
[
  { "id_ffa": 123, "paciente": "Maria da Silva", "hora_chegada": "10:30", "tempo_espera_min": 15 }
]
```

### Fila de Espera (aguardando médico)

| Arquivo | SP | Ação | Payload |
|---------|-----|------|---------|
| `FilaService.js` | `sp_master_query_dispatcher` | getUser | `{}` |

**Módulo:** `FILA_ESPERA`

**Retorno:**
```json
[
  { "id_ffa": 123, "paciente": "Maria da Silva", "status": "AGUARDANDO", "espera_minutos": 30 }
]
```

---

## 6. Fluxo Assistencial

| Arquivo | SP | Ação | Descrição |
|---------|-----|------|-----------|
| `AssistencialService.js` | `sp_master_assistencial` | request | Indicar intenção (ex: RX, exame) |
| `AssistencialService.js` | `sp_master_assistencial` | post | Confirmar/registrar |
| `AssistencialService.js` | `sp_master_assistencial` | push | Persistir e propagar fluxo |

### Request (solicitação)
```json
{
  "id_ffa": 123,
  "tipo_solicitacao": "RX_TORAX",
  "urgente": true,
  "observacao": "Suspeita de pneumonia"
}
```

### Post (registro)
```json
{
  "id_ffa": 123,
  "tipo_solicitacao": "EXAME_SANGUE",
  "detalhes": { "exames": ["hemograma", "glicemia"] }
}
```

### Push (atualização de status)
```json
{
  "id_ffa": 123,
  "status": "EM_ATENDIMENTO",
  "resultado": { "diagnostico": "Gripe", "prescricao": "..." }
}
```

---

## Resumo: Arquivos e Suas SPs

| Frontend Module | SP chamada | Tipo de ação | Uso |
|-----------------|------------|--------------|-----|
| `LoginForm.jsx` | `sp_auth_login` | post | Autenticação |
| `UserService.js` | `sp_master_query_dispatcher → USUARIO` | getUser | Info usuário logado |
| `PermissionService.js` | `sp_master_query_dispatcher → PERMISSAO_USUARIO` | getUser | Lista permissões |
| `PacienteService.js` | `sp_master_query_dispatcher → PACIENTE` | request | Busca paciente |
| `PacienteTimeline.jsx` | `sp_master_query_dispatcher → PACIENTE_TIMELINE` | request | Histórico paciente |
| `Triagem.jsx` | `sp_master_query_dispatcher → TRIAGEM` | getUser | Pacientes triagem |
| `FilaEspera.jsx` | `sp_master_query_dispatcher → FILA_ESPERA` | getUser | Pacientes espera |
| `FluxoAtendimento.jsx` | `sp_master_assistencial` | request/post/push | Ações médicas |

---

## Como Usar os Serviços

```javascript
// 1. Login
import { apiPost } from '../api/api';

const loginResult = await apiPost('/auth/login', { 
  login: 'joao.silva', 
  senha: '123456',
  id_unidade: 1,
  id_local: 1
});

// Salva token e id_sessao
localStorage.setItem('token_his', loginResult.token);
localStorage.setItem('id_sessao', loginResult.id_sessao_usuario);

// 2. Busca dados do usuário
import { UserService } from '../services';

const id_sessao = localStorage.getItem('id_sessao');
const usuario = await UserService.getUser(id_sessao);

// 3. Busca pacientes
import { PacienteService } from '../services';

const pacientes = await PacienteService.buscarPaciente(id_sessao, { nome: 'Maria' });

// 4. Timeline
const timeline = await PacienteService.getTimelinePaciente(id_sessao, id_ffa);

// 5. Fila de triagem
import { FilaService } from '../services';

const filaTriagem = await FilaService.getFilaTriagem(id_sessao);

// 6. Ações assistenciais
import { AssistencialService } from '../services';

await AssistencialService.salvarEvolucao(id_sessao, {
  id_ffa: 123,
  texto: 'Paciente apresenta melhora...'
});
```
