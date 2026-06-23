# MAP-013 — RH Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de recursos humanos.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

---

## Objetivo
Definir arquitetura completa do RH com foco em escalas e produtividade.

---

## Bounded Contexts

### Colaborador Context
```text
Colaborador
Dados pessoais
Cargo
Departamento
Salário
```

### Escala Context
```text
Escala
Plantão
Horário
Equipe
```

### Treinamento Context
```text
Treinamento
Material
Certificado
Participantes
```

### Avaliação Context
```text
Avaliação
Critérios
Notas
Feedback
```

---

## Agregados

### Colaborador Aggregate
```text
colaborador_id
tenant_id
organization_id
unit_id
cargo_id
nome
status
```

### Escala Aggregate
```text
escala_id
colaborador_id
data
horario_inicio
horario_fim
setor
```

---

## Eventos Oficiais

### ColaboradorAdmitido
### ColaboradorDesligado
### EscalaCriada
### TreinamentoConcluido
### AvaliacaoRealizada

---

## Stored Procedures

### sp_colaborador_admitir
### sp_escala_criar
### sp_treinamento_inscrever
### sp_avaliacao_registrar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-037 — Employee 360 | 360° |
| FRONT-037 — RH Experience | UX |
| FRONT-052 — Employee 360 | Employee 360 |