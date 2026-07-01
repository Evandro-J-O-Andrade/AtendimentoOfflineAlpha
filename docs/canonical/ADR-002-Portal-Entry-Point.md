# ADR-002 — Portal como Ponto de Entrada Obrigatório

## Status
ACEITO

## Contexto

Em sistemas legados, cada módulo (HIS, CRM, RH) tem seu próprio login e URL.

Isso cria:

- ilhas de autenticação;
- experiências fragmentadas;
- duplicação de código de segurança;
- dificuldade de unificação de contexto.

A plataforma FCA/Midas precisa de uma experiência unificada.

## Decisão

```text
Toda aplicação inicia pelo Portal.
Nenhum módulo operacional é ponto de entrada.
```

Fluxo canônico:

```text
Login
↓
Portal
↓
Aplicação
↓
Contexto
↓
Dashboard
↓
Operação
```

## Consequências

- App Registry centraliza todas as aplicações.
- IAM centralizado no Portal.
- Contexto é escolhido após login, não antes.
- Nenhuma App tem URL de entrada direta.
- Design System é único para todo ecossistema.

## Alternativas Consideradas

```text
ALTERNATIVA A: Login direto por App
  → Rejeitada. Fragmenta experiência. Cria ilhas.

ALTERNATIVA B: Portal apenas como launcher
  → Rejeitada. É mais que launcher. É o orchestrator da experiência.

ALTERNATIVA C: Login no Portal, acesso direto após contexto
  → Aceita. Implementada via App Registry + Contexto.
```

## Relacionamentos

- MD-CANONICO-IA-003 (Lei da Evolução do Core)
- LC-PORTAL-001 (Portal como Launcher)
- LC-001 (Portal é a entrada)
- MAP-001 (Enterprise Domain Architecture)

---

ADR-002 — Portal como Ponto de Entrada Obrigatório

**Aceito em 2026-06-29.**
