# MAP-015 — Pharmacy Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio farmacêutico.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Crítica
Obrigatoriedade: Saúde
```

## Objetivo
Definir a arquitetura completa da Farmácia com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → Pharmacy → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-014 — Portal = Hub Corporativo
```text
Pharmacy é aplicação, não módulo isolado.
```

---

## Lei Canônica MAP-015-001
```text
Nenhuma dispensação sem rastreabilidade.
```

---

## Hierarquia de Domínios
```text
Pharmacy Domain
├── Dispensação Context
├── Estoque Context
├── Lote Context
└── Controlado Context
```

---

## Fluxo Farmacêutico Oficial
```text
Prescrição
↓
Validação
↓
Separação
↓
Dispensação
↓
Baixa
↓
Rastreio
```

---

## Bounded Contexts

### Dispensação Context
Responsável por: Dispensação, Medicamento, Dosagem, Quantidade, Horário
Agregado: Dispensacao

### Estoque Context
Responsável por: Produto, Saldo, Mínimo, Máximo, Unidade
Agregado: Estoque

### Lote Context
Responsável por: Lote, Medicamento, Validade, Quantidade, Entradas/Saídas
Agregado: Lote

### Controlado Context
Responsável por: Medicamento Controlado, Receita, Validação, Rastreio
Agregado: Controlado

---

## Agregados Principais

### Dispensacao Aggregate
```text
dispensacao_id (PK)
atendimento_id (FK)
medicamento_id (FK)
quantidade
dosagem
prescritor
validade
status
criado_em
```

### Lote Aggregate
```text
lote_id (PK)
medicamento_id (FK)
numero
validade
quantidade_inicial
quantidade_atual
status
criado_em
```

---

## Eventos Oficiais

### MedicamentoDispensado
Payload: {dispensacao_id, medicamento_id, quantidade, prescritor}

### EstoqueAtualizado
Payload: {estoque_id, quantidade_anterior, quantidade_nova}

### LoteCadastrado
Payload: {lote_id, medicamento_id, numero, validade}

### ValidadeVencida
Payload: {lote_id, medicamento_id, validade}

### MedicamentoControladoLiberado
Payload: {controle_id, receita_id, validado_por}

---

## Stored Procedures

### sp_dispensacao_registrar
Input: {atendimento_id, medicamento_id, quantidade, prescritor}
Output: {dispensacao_id, status}

### sp_estoque_atualizar
Input: {medicamento_id, quantidade}
Output: {estoque_id, quantidade_atual}

### sp_lote_cadastrar
Input: {medicamento_id, numero, validade, quantidade}
Output: {lote_id}

### sp_validade_alertar
Input: {lote_id, dias}
Output: {alerta, status}

---

## APIs Oficiais

### /api/v1/pharmacy/dispensacoes
POST - Registrar dispensação
GET - Listar dispensações

### /api/v1/pharmacy/estoques
GET - Consultar estoque

---

## Regras Arquiteturais

### Rastreabilidade Rule
Todo medicamento dispensado tem rastro completo.

### SP First Rule
Toda escrita passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-011 — HIS Domain | Prescrições |
| MAP-002 — Tenant | Hierarquia |
| FRONT-034 — Pharmacy Experience | UX |
| FRONT-062 — Event Visualization | Eventos |