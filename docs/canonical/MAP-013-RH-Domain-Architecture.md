# MAP-013 — RH Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de recursos humanos.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

## Objetivo
Definir a arquitetura completa do RH com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → RH → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-006 — Tenant First
```text
Toda operação executa dentro de Tenant → Organização → Unidade
```

---

## Hierarquia de Domínios
```text
RH Domain
├── Colaborador Context
├── Escala Context
├── Treinamento Context
└── Avaliação Context
```

---

## Fluxo RH Oficial
```text
Colaborador
↓
Contratação
↓
Escala
↓
Treinamento
↓
Avaliação
```

---

## Bounded Contexts

### Colaborador Context
Responsável por: Colaborador, Dados pessoais, Cargo, Departamento, Salário
Agregado: Colaborador

### Escala Context
Responsável por: Escala, Plantão, Horário, Equipe, Setor
Agregado: Escala

### Treinamento Context
Responsável por: Treinamento, Material, Certificado, Participantes
Agregado: Treinamento

### Avaliação Context
Responsável por: Avaliação, Critérios, Notas, Feedback
Agregado: Avaliacao

---

## Agregados Principais

### Colaborador Aggregate
```text
colaborador_id (PK)
tenant_id (FK)
organization_id (FK)
unit_id (FK)
cargo_id
nome
cpf
status
admissao
demissao
```

### Escala Aggregate
```text
escala_id (PK)
colaborador_id (FK)
data
horario_inicio
horario_fim
setor
status
criado_em
```

---

## Eventos Oficiais

### ColaboradorAdmitido
Payload: {colaborador_id, cargo_id, admissao, tenant_id}

### ColaboradorDesligado
Payload: {colaborador_id, demissao, motivo}

### EscalaCriada
Payload: {escala_id, colaborador_id, data, horario}

### TreinamentoConcluido
Payload: {treinamento_id, colaborador_id, nota, certificado}

### AvaliacaoRealizada
Payload: {avaliacao_id, colaborador_id, notas, feedback}

---

## Stored Procedures

### sp_colaborador_admitir
Input: {nome, cpf, cargo_id, unit_id, admissao}
Output: {colaborador_id, matricula}

### sp_escala_criar
Input: {colaborador_id, data, horario_ini, horario_fim}
Output: {escala_id, status}

### sp_treinamento_inscrever
Input: {colaborador_id, treinamento_id}
Output: {inscricao_id}

### sp_avaliacao_registrar
Input: {colaborador_id, criterios, notas}
Output: {avaliacao_id}

---

## APIs Oficiais

### /api/v1/rh/colaboradores
POST - Admitir colaborador
GET - Listar colaboradores

### /api/v1/rh/escalas
POST - Criar escala
GET - Consultar escala por data

---

## Regras Arquiteturais

### SP First Rule
Toda escrita passa por Stored Procedure.

### Identidade Única Rule
Colaborador possui uma única identidade corporativa.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant context |
| MAP-003 — Identity | Auth/Authorization |
| MD-037 — Employee 360 | 360° |
| FRONT-037 — RH Experience | UX |