# HIS-EVENT-MODEL

> Parte da Lei Canônica HIS (`HIS-CANONICAL-LAWS.md`).
> Foco: modelo de eventos, imutabilidade e auditoria do domínio assistencial.
> Detalhe em `MD-138` (Immutable Clinical Records), `MD-139` (Retification/Revocation),
> `BR-003` (Auditoria) e `MD-137` (Clinical Audit Architecture).

---

## Leis do modelo de eventos

```text
LHIS-012 — Toda transição de estado gera evento.
LHIS-020 — Registro clínico é histórico; não é sobrescrito.
LHIS-021 — Correções são eventos: retificação / cancelamento / substituição / revogação.
LHIS-022 — Motivo é obrigatório em cancelamento/retificação.
LHIS-023 — Versão corrente é derivada; o original é retido.
LHIS-034 — Toda SP operacional registra evento semântico (*_eventos) + auditoria_evento,
           amarrado a p_id_sessao_usuario (sessão/contexto: sistema+unidade+local).
LHIS-050 — Toda ação crítica gera evento; timeline imutável.
LHIS-051 — Acesso a prontuário sempre registrado.
```

---

## Ciclo de vida do registro

```text
Create
 ├── Evento: RegistroCriado
 └── State: Active

Update (correção)
 ├── Evento: RegistroRetificado
 ├── Payload: antes/depois
 └── State: Active (desreferencia antigo)

Cancel
 ├── Evento: RegistroCancelado
 ├── Motivo: obrigatório
 └── State: Cancelled (retém evento)

Replace
 ├── Evento: RegistroSubstituido
 ├── Link para novo
 └── State: Replaced (original retido)
```

> Modelo canônico: `MD-139 — Clinical Retification and Revocation Model`.

---

## Eventos obrigatórios por domínio

### Senha
```text
SenhaCriada · SenhaChamada · SenhaPriorizada · SenhaTransferida
SenhaAusente · SenhaCancelada · SenhaConcluida
```

### Atendimento / FFA
```text
FFAAberta · TriagemRegistrada · AtendimentoIniciado · PrescricaoEmitida
MedicamentoDispensado · AtendimentoConcluido
```

### Trilhas de auditoria
```text
senha_eventos        — eventos de senha/fila
fila_operacional_evento — eventos de fila operacional
eventos clínicos     — evolução/execução assistencial
auditoria_evento     — auditoria geral amarrada à sessão
```

> Regra legada validada: "Local/Sala NÃO DEFINIDA" é silencioso — não gera evento de
> painel/TTS, mas continua registrado em auditoria.

---

## Imutabilidade

```text
MD-138-001 — Nenhum registro clínico é deletado.
             Alterações são eventos de retificação.
             Histórico é verdade. Versão corrente é derivada.
```

Consequência proibida (`LHIS-060/061`):
```text
DELETE físico de senha/prontuário
UPDATE de prontuário sem versão/evento
```

---

## Integridade de eventos

```text
Evento é facto, não intent.
Evento tem autor (sessão/contexto) e timestamp.
Evento de correção carrega payload antes/depois.
Timeline de eventos é a fonte da verdade do estado.
```

---

## Integrações canônicas

| Documento | Conteúdo |
|-----------|----------|
| MD-138 | Immutable Clinical Records |
| MD-139 | Clinical Retification and Revocation Model |
| MD-137 | Clinical Audit Architecture |
| BR-003 | HIS Clinical Rules (Auditoria REGRA-003-43..46) |
| MAP-011 | HIS Domain Architecture |
