# CONSTITUICAO-DA-PLATAFORMA

## Propósito

Documento estratégico que define a ordem de precedência, princípios e processos de governança da plataforma.

---

## 1. Princípios Fundamentais

1. **Banco como fonte da verdade** — O banco de dados é a única fonte canônica. O código adapta-se ao banco, nunca o contrário.
2. **Evolução incremental** — A plataforma evolui por incremento, nunca por reconstrução.
3. **Conservação arquitetural** — Nenhum componente existente é substituído, duplicado ou descartado sem análise arquitetural completa.
4. **Rastreabilidade total** — Toda implementação é rastreável de ponta a ponta.
5. **Materialização obrigatória** — Todo objeto proposto deve ser materializado em SQL antes da implementação.
6. **Zero trust** — Nenhuma camada confia na anterior; toda camada valida identidade, contexto e autorização.

---

## 2. Ordem de Precedência

Em caso de conflito entre documentos, prevalece a ordem abaixo:

1. **Constituição da Plataforma** (este documento)
2. **Leis Canônicas** (MD-CANONICO-IA-XXX)
3. **ADRs** (Arquitecture Decision Records)
4. **COREs** (Capabilities da plataforma)
5. **MAPs** (Arquitetura de domínios)
6. **BRs** (Regras de negócio)
7. **MDs de Domínio** (Modelos de domínio)
8. **Implementação** (Código, SQL, contratos, frontend)

Nenhuma implementação pode contradizer um documento de precedência superior.

---

## 3. Processo de Evolução

Toda nova implementação segue:

```
SCAN → REUSE → ADAPT → PROPOSE → SQL → IMPLEMENT → VALIDATE
```

Nenhuma etapa pode ser pulada.

---

## 4. Processo de Aprovação

1. **Dossiê de Engenharia** — obrigatório para todo CORE.
2. **ADRs** — obrigatórias para decisões arquiteturais.
3. **Gates de Engenharia** — GATE 0 a GATE 5; nenhuma fase é liberada sem aprovação.
4. **Aprovação do arquiteto** — obrigatória para:
   - novos COREs
   - alterações em COREs congelados
   - criação de objetos novos
   - breaking changes

---

## 5. Processo de Materialização

Todo objeto novo deve ser materializado:

```
Dump Canônico (somente leitura)
    ↓
Scripts SQL versionados
    ↓
Aplicação no banco
    ↓
Novo Dump gerado
    ↓
Atualização do inventário
```

Nunca editar o dump manualmente.

---

## 6. Critérios para Congelamento

Um CORE é congelado quando:
- dossiê aprovado
- ADRs aceitas
- SQL aplicado
- código implementado
- typecheck limpo
- testes aprovados
- E2E validado
- documentação atualizada
- auditoria de redundância executada

Após congelamento, mudanças são permitidas apenas para:
- bug
- performance
- segurança

Mudanças de contrato, fluxo ou semântica exigem descongelamento formal.

---

## 7. Critérios para Aceitação de Mudanças

Toda mudança deve:
- preservar a coerência arquitetural
- ser rastreável
- ser materializada
- ser testada
- ser documentada

Mudanças que quebrem compatibilidade exigem:
- justificativa técnica
- análise de impacto
- aprovação do arquiteto
- migração planejada

---

## 8. Auditorias Obrigatórias

Todo CORE deve passar por:
- **Performance** — índices, joins, N+1, cache, bundle
- **Segurança** — auth, authz, CSRF, replay, headers, cookies, logs
- **Operacional** — rollback, retry, fallback, recovery
- **Coerência** — banco ↔ MD ↔ ADR ↔ CORE ↔ código

---

## 9. Governança Documental

Todos os documentos canônicos devem:
- possuir status explícito (RASCUNHO, EM DESENVOLVIMENTO, COMPLETO, VALIDADO)
- ser registrados no catálogo da plataforma
- ser referenciados por ADR/CORE correspondente
- ser atualizados quando houver mudança

Documentos considerados RASCUNHO não podem ser usados como referência canônica.

---

## 10. Responsabilidades

| Papel | Responsabilidade |
|-------|------------------|
| Arquiteto | Aprovar dossiês, ADRs, COREs; manter roadmap; congelar/descongelar componentes |
| Engenheiro | Implementar seguindo dossiê; executar testes; manter documentação atualizada |
| Agente (Kilo) | Seguir esta constituição; não pular etapas; produzir evidências; gerar SQL materializado |

---

## 11. Aplicação

Esta constituição aplica-se a todo ecossistema da plataforma, incluindo:
- Backend
- Frontend
- Runtime
- Contracts
- Banco de dados
- Integrações
- Documentação

Qualquer exceção deve ser formalizada como ADR.

---

## 12. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-09 | Arquiteto | Constituição inicial |
