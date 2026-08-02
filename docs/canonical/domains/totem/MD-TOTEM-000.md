# MD-TOTEM-000 — Conceito do Domínio Totem

## Status
Documento Canônico de Domínio.
Fundação do domínio Totem na plataforma FCA/MIDAS SaaS Enterprise.

---

## Classificação
```text
Tipo: Domain Foundation
Camada: Application Layer
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Propósito

Definir o Totem como container de domínio de autoatendimento, emissão de senhas e informações públicas da plataforma.

---

## Princípio fundamental

```text
Totem é um consumidor do Kernel.
Totem não possui regra de negócio própria.
Totem materializa capacidades existentes do domínio Senha/Fila/Painel.
```

---

## Objetivos do domínio

1. Oferecer autoatendimento ao paciente/visitante
2. Emitir senhas eletrônicas para atendimento
3. Exibir informações públicas e plantão médico
4. Coletar feedback de atendimento
5. Integrar-se ao ecossistema de displays/painéis da plataforma

---

## Relação com o Kernel

O Totem depende integralmente do Kernel Enterprise:

| Camada Kernel | Dependência |
|---------------|-------------|
| Auth Runtime | Autenticação de totem |
| Context Runtime | Contexto operacional |
| Workflow Runtime | Fluxo de autoatendimento |
| Navigation Runtime | Projeção touch |
| Authorization | Permissões de acesso |
| Capability | Descoberta de capacidades |
| Ledger Runtime | Auditoria de eventos |
| Event Runtime | Rastreabilidade |

---

## O que o Totem NÃO é

- ❌ Sistema de gestão de escala médica
- ❌ Fonte de regras clínicas
- ❌ Acesso a dados sensíveis do paciente
- ❌ Substituição do Portal Enterprise
- ❌ Exceção arquitetural

---

## Containerização

O Totem é um container gerenciável pelo Portal Enterprise, conforme `MD-110-Canonical-Laws.md`:

```text
Dispositivos (TV, Totem, Kiosk, Monitor) são containers gerenciáveis no Portal.
```

O Portal descobre e renderiza o Totem como capability, não como módulo hardcoded.

---

## Dispositivos canônicos

Conforme `DISPOSITIVOS_CANONICOS.md`:

- `totem_senha` — Emissão de senhas
- `totem_cadastro` — Cadastro de pacientes
- `totem_checkin` — Check-in de consultas
- `totem_satisfacao` — Pesquisa de satisfação

---

## Matriz de contratos

Conforme `FRONT-CATALOG.md`:

| Frontend | Auth | Context | Portal | Navigation | Integration | Workflow | Event | Ledger | Runtime |
|----------|------|---------|--------|------------|-------------|----------|-------|--------|---------|
| Totem | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |

---

## Estado atual

| Camada | Status |
|--------|--------|
| Documentação canônica | ✅ Este documento |
| Banco de dados | ✅ Domínio existente |
| Frontend | ✅ Esqueleto funcional |
| Backend API | ❌ Ausente |
| Dispatcher integration | ❌ Ausente |
| Validação ponta a ponta | ❌ Pendente |

---

## Próximos passos

1. `MD-TOTEM-001` — Contrato API canônico
2. `MD-TOTEM-002` — Capability Registry
3. `MD-TOTEM-003` — Executor Mapping
4. `MD-TOTEM-004` — Fluxo ponta a ponta

---

## Referências

- `MD-105-HIS-Canonical-Flow.md` — Camada 1 (Senha) e Camada 2 (Fila)
- `MD-110-Canonical-Laws.md` — Displays como containers
- `MAP-005-Portal-Architecture.md` — Portal como Runtime
- `FRONT-CATALOG.md` — Matriz de contratos
- `DISPOSITIVOS_CANONICOS.md` — Dispositivos canônicos
