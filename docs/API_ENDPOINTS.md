# API REST - Endpoints Padronizados

## Estrutura de Respostas

Todos os endpoints retornam JSON com a seguinte estrutura:

```json
{
  "ok": true|false,
  "data": { ... },
  "error": "mensagem de erro (apenas se ok=false)"
}
```

### Códigos HTTP
- **200 OK**: Sucesso
- **400 Bad Request**: JSON inválido ou campos obrigatórios ausentes
- **401 Unauthorized**: Credenciais inválidas ou token expirado
- **403 Forbidden**: Permissão insuficiente
- **500 Internal Server Error**: Erro no servidor

---

## Domínios de Endpoints

### 1. **SENHA** — Geração e Gerenciamento de Senhas

#### `POST /src/api/senha/gerar.php`
Gera uma nova senha (TOTEM ou RECEPÇÃO).

**Request:**
```json
{
  "origem": "TOTEM" | "RECEPCAO"
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "id_senha": 1,
    "numero": 101,
    "origem": "TOTEM",
    "data_hora": "2026-02-01 10:30:00"
  }
}
```

---

### 2. **ATENDIMENTO** — Abertura, Modificação e Finalização

#### `POST /src/api/atendimento/recepcao.php`
Abre um novo atendimento na recepção.

**Request:**
```json
{
  "nome_completo": "João Silva",
  "cpf": "123.456.789-00",
  "cns": "99999999999999",
  "data_nascimento": "1990-05-15",
  "sexo": "M",
  "tipo_atendimento": "CLINICO",
  "meio_chegada": "MEIOS_PROPRIOS",
  "prioridade": "NORMAL",
  "motivo_procura": "Dor de cabeça",
  "destino_inicial": "TRIAGEM",
  "id_local": 1,
  "id_especialidade": null,
  "id_usuario_logado": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "id_senha": 1,
    "id_atendimento": 10
  }
}
```

#### `POST /src/api/atendimento/abrir.php`
Abre um atendimento médico/triagem (compatível com dados anteriores).

**Request:**
```json
{
  "nome_completo": "Maria Silva",
  "tipo_atendimento": "CLINICO",
  "cpf": "123.456.789-00",
  "id_usuario_logado": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Atendimento aberto com sucesso."
  }
}
```

#### `POST /src/api/atendimento/finalizar.php`
Finaliza um atendimento com desfecho.

**Request:**
```json
{
  "id_atendimento": 10,
  "id_usuario": 1,
  "desfecho": "ALTA_MEDICA",
  "observacao": "Paciente recuperado"
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Atendimento finalizado com sucesso."
  }
}
```

#### `POST /src/api/atendimento/mudar_local.php`
Move um paciente de local/sala.

**Request:**
```json
{
  "id_atendimento": 10,
  "id_local": 2,
  "id_sala": 5,
  "id_usuario": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Local do paciente atualizado com sucesso."
  }
}
```

---

### 3. **TRIAGEM** — Registro de Dados Clínicos

#### `POST /src/api/triagem/registrar.php`
Registra dados de triagem (enfermagem).

**Request:**
```json
{
  "id_atendimento": 10,
  "id_risco": 2,
  "queixa": "Febre alta",
  "sinais_vitais": {
    "pa": "120/80",
    "fc": 85,
    "temperatura": 39.5
  },
  "observacoes": "Paciente com tosse persistente",
  "id_usuario": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Triagem registrada com sucesso."
  }
}
```

---

### 4. **FILA** — Gerenciamento de Chamadas

#### `GET /src/api/fila/geral.php`
Lista todos os pacientes na fila atual (requer autenticação).

**Response (200):**
```json
{
  "ok": true,
  "data": [
    {
      "id_ffa": 1,
      "numero_senha": 101,
      "status": "AGUARDANDO",
      "local": "Triagem",
      "horario_chegada": "2026-02-01 10:30:00"
    }
  ]
}
```

#### `POST /src/api/fila/chamar.php`
Chama manualmente um paciente para o painel (requer autenticação).

**Request:**
```json
{
  "id_ffa": 1,
  "usuario_chamador": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Paciente 1 chamado com sucesso"
  }
}
```

---

### 5. **INTERNAÇÃO** — Admissão e Alta de Internados

#### `POST /src/api/internacao/inicial.php`
Inicia uma internação hospitalar.

**Request:**
```json
{
  "id_atendimento": 10,
  "id_leito": 5,
  "id_usuario": 1,
  "data_prevista_alta": "2026-02-05",
  "observacoes": "Paciente estável"
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Paciente internado com sucesso."
  }
}
```

#### `POST /src/api/internacao/alta.php`
Registra alta de internação (liberando leito).

**Request:**
```json
{
  "id_internacao": 5,
  "id_usuario": 1
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Alta da internação registrada. Leito liberado."
  }
}
```

---

### 6. **USUÁRIO** — Autenticação e Gerenciamento

#### `POST /src/api/usuario/login.php`
Autentica um usuário.

**Request:**
```json
{
  "login": "joao.silva",
  "senha": "senha123"
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "token": "abc123def456...",
    "usuario": {
      "id_usuario": 1,
      "login": "joao.silva",
      "nome": "João Silva",
      "perfis": ["MEDICO", "TRIAGEM"]
    }
  }
}
```

#### `GET /src/api/usuario/listar.php`
Lista todos os usuários (requer ADMIN ou SUPORTE).

**Response (200):**
```json
{
  "ok": true,
  "data": [
    {
      "id_usuario": 1,
      "login": "joao.silva",
      "nome_completo": "João Silva",
      "ativo": true,
      "perfis": ["MEDICO"],
      "perfis_ids": [2]
    }
  ]
}
```

#### `POST /src/api/usuario/criar.php`
Cria um novo usuário.

**Request:**
```json
{
  "login": "maria.santos",
  "senha": "nova_senha_123",
  "nome": "Maria Santos",
  "cpf": "987.654.321-00",
  "id_perfil": 3
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "id_usuario": 5
  }
}
```

#### `POST /src/api/usuario/atualizar.php`
Atualiza dados de um usuário (requer ADMIN ou SUPORTE).

**Request:**
```json
{
  "id_usuario": 5,
  "login": "maria.santos",
  "ativo": true,
  "nome": "Maria Santos Silva",
  "id_perfis": [3, 4]
}
```

**Response (200):**
```json
{
  "ok": true,
  "data": {
    "mensagem": "Usuário atualizado com sucesso"
  }
}
```

---

## Autenticação

Os endpoints que requerem autenticação esperam o token no header:
```
Authorization: Bearer <token>
```

Alternativamente, o token pode ser passado como parâmetro GET:
```
?token=<token>
```

---

## Tratamento de Erros

Todos os erros retornam `ok: false` com uma mensagem descritiva:

```json
{
  "ok": false,
  "error": "Campos obrigatórios ausentes: id_atendimento"
}
```

---

## Transações

Endpoints que envolvem múltiplas operações (recepção, atualização de usuário, internação) utilizam `BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK` para garantir consistência. Em caso de erro, a transação é revertida automaticamente.

---

## Auditoria

Todas as operações que modificam dados críticos (abertura de FFA, chamadas, triagem) são registradas em tabelas de auditoria (`auditoria_ffa`, `auditoria_atendimento`, etc.) com:
- `tipo_evento`: tipo de operação
- `acao`: descrição da ação
- `usuario_id` ou `chamado_por`: quem executou
- `timestamp`: quando aconteceu

---

Última atualização: 2026-02-01
