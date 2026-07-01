# ADR-001 — Pessoa como Entidade Raiz

## Status
ACEITO

## Contexto

Em sistemas legados de saúde, é comum que "Paciente" seja a entidade central.

Isso funciona para um sistema hospitalar fechado.

Mas a FCA/Midas é uma plataforma multi-tenant, multi-aplicativo, multi-dispositivo.

Paciente é insuficiente porque:

- é específico do domínio assistencial;
- não representa colaboradores, leads, usuários do sistema;
- não suporta outros Apps (CRM, RH, Financeiro).

## Decisão

```text
PESSOA é a entidade raiz da plataforma.
```

Todo ser humano ou jurídico que interaja com a plataforma é uma Pessoa.

Paciente é uma projeção de Pessoa no contexto assistencial.

Colaborador é uma projeção de Pessoa no contexto RH.

Lead é uma projeção de Pessoa no contexto CRM.

## Consequências

- Toda identidade pertence a uma Pessoa.
- Uma Pessoa pode existir em múltiplos Tenants.
- Contexto define a projeção, não a entidade.
- Tabelas operacionais (senha, atendimento, prescrição) referenciam Pessoa.

## Alternativas Consideradas

```text
ALTERNATIVA A: Paciente como entidade raiz
  → Rejeitada. Específica do HIS. Não suporta CRM, RH, Financeiro.

ALTERNATIVA B: Usuário como entidade raiz
  → Rejeitada. Usuário é credencial de acesso. Não representa a pessoa física.

ALTERNATIVA C: Pessoa com múltiplas entidades filhas
  → Aceita. Paciente, Colaborador, Lead como projeções.
```

## Relacionamentos

- MD-CANONICO-IA-003 (Lei da Evolução do Core)
- LC-PER-001 (Pessoa é Raiz)
- MAP-001 (Enterprise Domain Architecture)

---

ADR-001 — Pessoa como Entidade Raiz

**Aceito em 2026-06-29.**
