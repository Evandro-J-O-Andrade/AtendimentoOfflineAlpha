# FRONT-031 — HIS Operational Experience

## Status

Documento Canônico de Frontend.
Define a experiência operacional do HIS.

---

## Objetivo

Definir a experiência operacional do HIS com foco no fluxo da senha.

---

## Lei Canônica

```text
Paciente não entra no fluxo.

Quem entra no fluxo é a Senha.
```

---

## Fluxo

```text
Senha
↓
Fila
↓
FFA
↓
Atendimento
↓
Execução Clínica
↓
Farmácia
↓
Faturamento
```

---

## Workspaces

```text
Recepção

Triagem

Médico

Enfermagem

Observação

Internação

Regulação
```

---

## Lei

```text
Toda tela do HIS deve mostrar
o estado atual da senha.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-001 — MD-110 | Canonicais |
| FRONT-032 — Queue Panel | Painéis |