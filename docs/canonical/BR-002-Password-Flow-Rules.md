# BR-002 — Password Flow Rules

## Status
Documento de Regras de Negócio.
Regras do fluxo de senhas.

---

## Lei Canônica BR-002-001
```text
Paciente não inicia fluxo.
Senha inicia fluxo.
```

---

## Regras de Senha

### Criação
```text
REGRA-002-01: Senha criada com prioridade padrão
REGRA-002-02: Senha tem tipo (convênio, SUS, particular)
REGRA-002-03: Senha tem fila associada
REGRA-002-04: Senha tem origem (agendada, walk-in)
```

### Prioridade
```text
REGRA-002-05: Idoso = prioridade 1
REGRA-002-06: Grávida = prioridade 1
REGRA-002-07: Dor crônica = prioridade 2
REGRA-002-08: Comum = prioridade 3
REGRA-002-09: Prioridade máxima = 5
REGRA-002-10: Prioridade só alterada por autorizado
```

### Status
```text
REGRA-002-11: Pendente → Atendida → Concluída
REGRA-002-12: Pendente → Cancelada (motivo obrigatório)
REGRA-002-13: Rechamada máxima 3 vezes
REGRA-002-14: Ausência = cancelamento automático
```

---

## Regras de Fila

### Chamada
```text
REGRA-002-15: Ordem por prioridade+chegada
REGRA-002-16: Guichê tem fila fixa
REGRA-002-17: Profissional pode ter múltiplas filas
REGRA-002-18: Cada chamada gera evento
```

---

## Stored Procedures

### sp_senha_criar_com_regra
Aplica todas regras na criação

### sp_senha_chamar_com_regra
Valida regras de chamada

### sp_senha_priorizar_com_regra
Aplica regras de prioridade

---

## Integrações
| BR/MAP | Finalidade |
|--------|-----------|
| MAP-011 — HIS Domain | HIS |
| FRONT-032 — Queue Panel | UX |
| BR-001 — Auth | Auth |