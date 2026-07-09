# HIS-CANONICAL-LAWS

> Camada: Leis Canônicas de Domínio (HIS/PA/UBS/Clínica/Hospital)
> Natureza: Verdades imutáveis do domínio assistencial.
> Relação: Consolida e separa regras de domínio de decisões de implementação.
> Não confundir com `CORE-003` (Portal Metadata) — aquele é técnico/portal; este é domínio.

---

## 0. Princípio de separação

```text
LEIS CANÔNICAS HIS   → o que o domínio É (imutável)
        ↓
MAPs / BRs           → como o domínio é modelado/regrado
        ↓
CORE                  → como a plataforma entrega capacidade
        ↓
Código                 → materialização
```

Este documento NÃO prescreve tabelas, SPs ou contratos. Aponta para os documentos
canônicos detalhados (BR-003, MD-105, MD-138, MD-139, MAP-011) e extrai apenas as
leis permanentes.

Proveniência: regras marcadas `[TXT]` vieram do conhecimento histórico (TXT legado)
e foram validadas contra BR-003 / MD-105 / MD-138 / MD-139. Regras marcadas
`[BR-003]` / `[MD-105]` etc. já estão nesses documentos canônicos.

---

## 1. Identidade

```text
LHIS-001 — Pessoa é a raiz da identidade.                [TXT][BR-003]
LHIS-002 — Usuário NÃO é entidade raiz; é acesso.        [TXT][BR-003]
LHIS-003 — Paciente, funcionário, médico são especializações/contextos de Pessoa. [TXT][BR-003]
LHIS-004 — Paciente longitudinal; Senha é entrada operacional. [MD-105][BR-003]
LHIS-005 — Paciente não inicia fluxo; a Senha inicia.   [MD-105][BR-003 REGRA-003-02]
```

Detalhe: `BR-003` (REGRA-003-01..04) e `MD-105` (Princípio Fundamental).

---

## 2. Fluxo operacional

```text
LHIS-010 — Senha é o núcleo operacional assistencial.    [BR-003 LC-005][MD-105 Lei Suprema]
LHIS-011 — Fluxo canônico:                               [MD-105]
           Senha → Fila → Triagem → FFA → Atendimento → Execução → Faturamento
LHIS-012 — Toda transição de estado gera evento.         [BR-003 REGRA-003-43..46][MD-105]
LHIS-013 — Transitividade obrigatória; não pular etapas. [MD-105 Regras de Transição]
LHIS-014 — Não existe DELETE físico de senha/atendimento. [MD-105 Proibido][MD-138]
```

Vide `HIS-DOMAIN-FLOW.md` para o detalhamento das camadas e `MD-105`.

---

## 3. Dados clínicos e registros

```text
LHIS-020 — Registro clínico é histórico; não é sobrescrito. [MD-138 MD-138-001]
LHIS-021 — Correções geram eventos, não overwrite:        [MD-138][MD-139]
           retificação / cancelamento / substituição / revogação
LHIS-022 — Motivo é obrigatório em cancelamento/retificação. [MD-139 MD-139-001]
LHIS-023 — Versão corrente é derivada; o original é retido.  [MD-138][MD-139]
```

Vide `MD-138` (Immutable Clinical Records) e `MD-139` (Retification/Revocation).

---

## 4. Arquitetura de persistência

```text
LHIS-030 — SP = escrita oficial.                          [BR-003 LC-007][TXT]
LHIS-031 — Function = cálculo.                            [TXT]
LHIS-032 — View = leitura.                                [TXT]
LHIS-033 — Trigger NÃO contém regra de negócio.           [TXT][BR-003 LC-007]
LHIS-034 — Toda SP operacional recebe p_id_sessao_usuario, [TXT]
           valida sessão/contexto, registra evento semântico
           (*_eventos) + auditoria_evento.
LHIS-035 — Banco é fonte da verdade; frontend segue o banco. [TXT][BR-003 LC-007]
```

---

## 5. Operação assistencial (regras de comportamento)

```text
LHIS-040 — Chamadas e decisões operacionais são SEMPRE manuais. [TXT]
LHIS-041 — Painéis/totens de painel são SOMENTE LEITURA.       [TXT]
LHIS-042 — Totem de senha e totem de satisfação são os únicos [TXT]
           interativos para o paciente.
LHIS-043 — Local/Sala "NÃO DEFINIDA" é silencioso:             [TXT]
           não aparece em painel/TTS, mas permite execução e é auditado.
LHIS-044 — Manchester mantém cor REAL; cor efetiva por tempo  [TXT]
           só em VIEW/ordenação (duas bolinhas).
LHIS-045 — Barcode/protocolos usam o número humano (Code128), [TXT]
           por sequência determinística sem colisão.
LHIS-046 — Agendamento é módulo genérico e NÃO manda no PA.    [TXT]
LHIS-047 — NAO_COMPARECEU: reentrada dentro de janela          [TXT]
           (30–60 min) volta ao fim da fila (sem furar);
           fora da janela = nova senha.
```

---

## 6. Auditoria e multitenancy

```text
LHIS-050 — Toda ação crítica gera evento; timeline imutável. [BR-003 REGRA-003-43..46]
LHIS-051 — Acesso a prontuário sempre registrado.            [BR-003 REGRA-003-45]
LHIS-052 — Todos os dados escopados por tenant;             [BR-003 REGRA-003-40..42]
           tenant_id obrigatório; sem consulta global.
LHIS-053 — Nenhuma circulação de dados fora do tenant.       [BR-003 REGRA-003-50]
```

---

## 7. Proibido (consolidado)

```text
LHIS-060 — Deleção direta de senha/prontuário.              [BR-003 REGRA-003-47][MD-138]
LHIS-061 — Atualização de prontuário sem versão/evento.      [BR-003 REGRA-003-48][MD-139]
LHIS-062 — Acesso a prontuário sem permissão.                [BR-003 REGRA-003-49]
LHIS-063 — Criar atendimento sem senha.                     [MD-105 Proibido]
LHIS-064 — Faturar sem atendimento vinculado.               [MD-105 Proibido]
LHIS-065 — Trigger com regra de negócio / fluxo.            [LHIS-033]
```

---

## 8. Integrações canônicas

| Documento | Conteúdo detalhado |
|-----------|--------------------|
| BR-003 — HIS Clinical Rules | Regras REGRA-003-01..50 + leis base LC-005/006/007/012 |
| MD-105 — HIS Canonical Flow | Fluxo canônico, camadas, transitividade |
| MD-138 — Immutable Clinical Records | Imutabilidade de registros |
| MD-139 — Clinical Retification/Revocation | Cancelar/retificar/substituir |
| MAP-011 — HIS Domain Architecture | Arquitetura de domínio HIS |
| MAP-003 — Pharmacy Clinical Execution | Execução farmacêutica |
| CORE-LEGACY-REUSE-MATRIX | Reuso de conhecimento legado → plataforma |

> CORE-003 (Portal Metadata) é técnico e vive em `docs/canonical/CORE/CORE-003-PORTAL-METADATA.md`.
> Este arquivo não prescreve Portal, Auth, Context nem Contracts — apenas o domínio HIS.
