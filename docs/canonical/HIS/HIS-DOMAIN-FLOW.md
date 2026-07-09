# HIS-DOMAIN-FLOW

> Parte da Lei Canônica HIS (`HIS-CANONICAL-LAWS.md`).
> Foco: fluxo operacional canônico e transitividade obrigatória.
> Detalhe completo em `MD-105 — HIS Canonical Flow` e `BR-003`.

---

## Lei fundamental

```text
No HIS, a SENHA é a entidade de entrada operacional.
O PACIENTE não entra no fluxo operacional; a SENHA entra e referencia o paciente.
```

---

## Fluxo canônico

```text
Senha
  ↓
Fila
  ↓
Triagem
  ↓
FFA (Fluxo de Fluxo Assistencial)
  ↓
Atendimento
  ↓
Execução Clínica
  ↓
Farmácia
  ↓
Faturamento
```

> Ordem validada em `MD-105` (Fluxo Canônico) e `BR-003` (REGRA-003-01..26).
> Observação legada validada: FFA pode existir sem exames/procedimentos/medicação;
> diagnóstico e prescrição NÃO encerram a FFA; médico tem autonomia de abrir/salvar/
> fechar/reabrir.

---

## Transitividade obrigatória

```text
Senha → Fila           : obrigatório (senha deve estar em uma fila)
Fila → FFA             : obrigatório (FFA movimenta senhas)
FFA → Atendimento      : obrigatório (atendimento nasce do FFA)
Atendimento → Triagem  : obrigatório (todo atendimento tem triagem)
Triagem → Execução     : obrigatório (execução nasce da triagem)
Execução → Farmácia    : condicional (se houver prescrição)
Execução → Faturamento : obrigatório (após conclusão)
```

---

## Fluxos alternativos

### Retorno
```text
Alta → Retorno (nova senha) → Fila → FFA → Atendimento (continuidade)
```

### Não comparecimento
```text
Senha gerada → Paciente não comparece → Status: não atendida
             → Evento registrado → Contador atualizado
```
Regra legada validada (`LHIS-047`): reentrada dentro de janela (30–60 min) volta ao
fim da fila sem furar; fora da janela = nova senha.

---

## Proibido no fluxo

```text
Criar atendimento sem senha
Pular triagem (salvo regra específica documentada)
Finalizar atendimento sem execução registrada
Faturar sem atendimento vinculado
Alterar status de senha sem registrar evento
Deletar senha ou atendimento (apenas soft delete + auditoria)
```

---

## Responsabilidades

```text
Plataforma: manter fluxo canônico, garantir transitividade, registrar eventos,
             garantir integridade referencial, auditar mudanças de estado.

Desenvolvedor: seguir ordem canônica, não criar atalhos, emitir eventos em cada
             transição, respeitar status, usar SPs canônicas.
```

---

## Métricas derivadas (não regra, mas observáveis)

```text
Tempo médio de espera (senha → atendimento)
Tempo médio de atendimento
Taxa de não comparecimento / evasão / retorno
Throughput por unidade/local
Taxa de finalização / fila média por local
```
