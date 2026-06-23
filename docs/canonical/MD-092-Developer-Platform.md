# MD-092 — Developer Platform

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Capacitar desenvolvedores internos e externos a construir, publicar e monetizar na plataforma.

---

## Princípio Fundamental

```text
Plataforma não é só produto.
Plataforma é ecossistema de desenvolvimento.
Quem constrói junto, cresce junto.
```

---

## Componentes

### Onboarding

```text
Cadastro de desenvolvedor
KYC para parceiros externos
Ambiente de sandbox provisionado
Documentação guiada
Primeira Hello World API
```

### Workspace

```text
Projetos pessoais ou empresariais
Ambientes: dev, staging, production
Versionamento git integrado
CI/CD serverless
Feature flags
Ambientes isolados por tenant
```

### Ferramentas

```text
CLI oficial da plataforma
SDK por linguagem (JS, Python, C#, Java)
Clientes de API gerados
Test harness
Local simulator
Debug integrado
```

### Colaboração

```text
Times e organizações
Permissionamento de workspace
Pull requests com review
Issue tracking
CI/CD com aprovação
Ambientes compartilhados
Webhooks de evento
```

### Publicação

```text
Registro de app/agente/integração
Validação automática de segurança
Review por plataforma (para parceiros)
Deploy para Marketplace (opcional)
Telemetria e analytics opcionais
```

---

## Integrações

```text
MD-091 Enterprise-API-Platform
MD-093 SDK-Extensions-Framework
MD-075 Marketplace-Seller-Hub
MD-082 Agent-Marketplace
MD-019 App-Registry-Canonico
MD-014 App-Registry
MD-038 Integration-Hub
MD-025 Event-Store
```

---

## Regras

1. Desenvolvedor deve ter identidade verificada.
2. Sandbox tem limites claros (rate limit, storage, tempo).
3. Produção exige aprovação e billing ativo.
4. Nenhum código chega a produção sem CI/CD passar.
5. Parceiros passam por security review obrigatório.
6. Mercado interno (tenant) tem fluxo acelerado.
7. API Keys e credenciais são gerenciadas no Vault.

---

## Lei

```text
Desenvolvedor é parceiro da plataforma.
Plataforma fornece ferramentas, não só regras.
Ecossistema forte atrai ecossistema maior.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Infraestrutura de desenvolvimento
SDKs e ferramentas oficiais
Documentação completa
Sandbox provisionado
CI/CD gerenciado
Segurança e scanner de código
```

Desenvolvedores são responsáveis por:

```text
Seguir padrões e contratos
Testar antes de publicar
Manter suas publicações
Respeitar limites de uso
Reportar vulnerabilidades
```

---

## Métricas

```text
Desenvolvedores registrados
Apps/agentes publicados por desenvolvedor
Tempo de setup do primeiro projeto
Taxa de aprovação
Apps em produção
Apps no Marketplace
Adoção de SDKs
Velocidade média de deploy
Satisfação do desenvolvedor (DSAT)
```
