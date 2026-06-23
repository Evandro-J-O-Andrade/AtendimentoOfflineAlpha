# MD-083 — Prompt Governance

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Governar prompts corporativos com versionamento, aprovação, auditoria, testes e rollback.

---

## Princípio Fundamental

```text
Prompt não é texto.

Prompt é ativo intelectual da empresa.

Prompt define comportamento da IA.

Prompt deve ser tratado como código,
documento e estratégia simultaneamente.
```

---

## Recursos

### Versionamento

```text
Cada alteração gera nova versão
Histórico completo de alterações
Diff entre versões
Rollback programável
Branch para experimentação
Merge com aprovação
```

### Aprovação

```text
Workflow de aprovação por papel
Aprovadores: Negócio + IA + Segurança
Bloqueio de deploy sem aprovação
Gate obrigatório para produção
Aprovação por tenant e por escopo
```

### Auditoria

```text
Quem criou
Quem alterou
Quem aprovou
Quando
De onde (tenant, app, agente)
Qual modelo de IA usado
Quais dados foram enviados
Qual foi a resposta
```

### Testes

```text
Testes unitários de prompt
Testes de comportamento esperado
Testes de segurança (injection, vazamento)
Testes de desempenho (latência, custo)
Testes de viés e toxicidade
Testes de consistência entre versões
```

### Rollback

```text
Rollback automático por regra
Rollback manual por aprovador
Janela de rollback configurável
Comparação de métricas pós-rollback
Notificação a stakeholders
```

---

## Componentes

### Prompt Template

```text
Nome
Descrição
Versão
Categoria
Tags
Status (draft, testing, approved, deprecated)
Owner
Aprovadores
Modelo alvo
Parâmetros
Contexto de uso (app, agente, canal)
```

### Política de Uso

```text
Proibidos
  └── Dados sensíveis sem mascaramento
  └── Instruções fora do escopo do tenant
  └── Prompts não versionados
  └── Modificações sem aprovação

Obrigatórios
  └── Mascaramento de dados sensíveis
  └── Contexto multi-tenant isolado
  └── Rastreabilidade completa
  └── Consentimento do usuário quando aplicável
```

### Biblioteca

```text
Prompts padrões por domínio
Prompts customizados por tenant
Prompts compartilhados por indústria
Prompts aprovados pela plataforma
Prompts experimentais
```

---

## Integrações

```text
MD-081 AI-Copilot-Framework
MD-082 Agent-Marketplace
MD-084 Knowledge-Graph
MD-027 AI-Orchestration-Platform
MD-057 Enterprise-Agent-Platform
MD-034 IAM
MD-035 Security-Trust-Architecture
MD-025 Event-Store
MD-039 Analytics-Data-Intelligence
```

---

## Regras

1. Prompt critico nunca vai para produção sem aprovação.
2. Toda execução gera log com prompt, input, output e modelo.
3. Versionamento é obrigatório e imutável.
4. Testes de segurança são obrigatórios antes de aprovação.
5. Rollback deve ser mais rápido que deploy de correção.
6. Biblioteca central facilita reuso e governança.
7. Tenants customizam sem quebrar o canônico.

---

## Lei

```text
Prompt não é texto solto.

Prompt é patrimônio intelectual

governado, versionado e auditado.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Framework de governança
Workflow de aprovação
Sandbox de testes
Versionamento canônico
Auditoria central
Biblioteca de prompts
```

Usuários são responsáveis por:

```text
Seguir processo de aprovação
Não compartilhar prompts sensíveis
Reportar comportamentos suspeitos
Usar biblioteca quando disponível
```

---

## Métricas

```text
Prompts canônicos
Prompts customizados por tenant
Versões aprovadas por mês
Taxa de aprovação
Taxa de rollback
Tempo de aprovação
Cobertura de testes por prompt
Incidentes por prompt mal governado
Consumo de tokens por prompt
```
