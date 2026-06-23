# MAP-015 — Pharmacy Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio farmacêutico.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Crítica
Obrigatoriedade: Saúde
```

---

## Objetivo
Definir arquitetura completa da farmácia com foco em segurança e rastreabilidade.

---

## Bounded Contexts

### Dispensação Context
```text
Dispensação
Medicamento
Dosagem
Quantidade
Horário
```

### Estoque Context
```text
Produto
Saldo
Mínimo
Máximo
Unidade
```

### Lote Context
```text
Lote
Medicamento
Validade
Quantidade
Entradas/Saídas
```

### Controlado Context
```text
Medicamento Controlado
Receita
Validação
Rastreio
```

---

## Agregados

### Dispensacao Aggregate
```text
dispensacao_id
atendimento_id
medicamento_id
quantidade
dosagem
prescritor
validade
```

### Lote Aggregate
```text
lote_id
medicamento_id
numero
validade
quantidade_inicial
quantidade_atual
```

---

## Eventos Oficiais

### MedicamentoDispensado
### EstoqueAtualizado
### LoteCadastrado
### ValidadeVencida
### MedicamentoControladoLiberado

---

## Stored Procedures

### sp_dispensacao_registrar
### sp_estoque_atualizar
### sp_lote_cadastrar
### sp_validade_alertar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MAP-011 — HIS Domain | HIS |
| FRONT-034 — Pharmacy Experience | UX |
| FRONT-062 — Event Visualization | Eventos |