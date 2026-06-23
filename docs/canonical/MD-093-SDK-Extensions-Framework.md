# MD-093 — SDK & Extensions Framework

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Fornecer SDKs, extensões e pontos de integração padronizados para desenvolvedores e tenants.

---

## Princípio Fundamental

```text
Integração não é reinventar a roda.
Integração é usar o canônico.
Quanto mais padrão, mais rápido e seguro.
```

---

## SDKs Oficiais

### Frontend

```text
JavaScript / TypeScript (navegador e Node)
React components
Angular components
Vue components
Mobile (React Native / Flutter via wrappers)
PWA helpers
```

### Backend

```text
Node.js / TypeScript
Python
C# / .NET
Java / Spring
Go
```

### Mobile

```text
iOS (Swift)
Android (Kotlin)
React Native
Flutter (Dart)
```

### CLI

```text
Comandos para scaffolding
Deploy e gestão de versão
Testes locais
Gerenciamento de configuração
Logs e debug
```

---

## Extensões

### Frontend Extensions

```text
Shell plugins (blocos no Portal)
Widgets para dashboards
Componentes de Design System customizados (tenant)
Hooks e providers customizados
Rotas customizadas (dentro do shell)
Themes customizados
```

### Backend Extensions

```text
Handlers customizados no Dispatcher
Middlewares de autenticação/autorização
Integrações via webhook handlers
Custom Events no Event Store
Storage providers customizados
```

### Agent Extensions

```text
Tools customizadas para agentes
Prompt templates customizados
Memory providers
Orchestration steps
Observabilidade customizada
```

### Integration Extensions

```text
Connectors (apps de terceiro)
Transformers de payload
Adapters de protocolo
Certificados e credenciais gerenciadas
Retry policies customizadas
```

---

## Estrutura de Pacote

```
sdk/
  js/
  python/
  csharp/
  java/
  go/
  swift/
  kotlin/

extensions/
  frontend-widget/
  backend-handler/
  agent-tool/
  integration-connector/
```

---

## Integrações

```text
MD-092 Developer-Platform
MD-091 Enterprise-API-Platform
MD-094 White-Label-Architecture
MD-095 Multi-Brand-Architecture
MD-020 Portal-Core-Architecture
MD-013 Frontend-Shell
MD-014 Design-System
MD-004 Dispatcher
MD-081 AI-Copilot-Framework
MD-082 Agent-Marketplace
```

---

## Regras

1. SDK oficial é a única forma suportada de integração canônica.
2. Versões do SDK seguem semver rigoroso.
3. Breaking changes em SDK geram nova versão major.
4. Tenant pode estender via framework, não por hack.
5. Extensões customizadas não sobrescrevem kernel.
6. CLI oficial é mantida pela plataforma.
7. Exemplos e testes são entregues junto com cada release.
8. Deprecated APIs/features têm prazo de migração documentado.

---

## Lei

```text
Extensão sem padrão é dívida técnica.
Padrão sem extensão é rigidez.
Framework equilibra os dois.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Manter SDKs oficiais
Documentar extensões
Versionar com clareza
Garantir backward compatibility
Prover exemplos e testes
Gerenciar breaking changes
```

Desenvolvedores são responsáveis por:

```text
Usar SDK oficial
Seguir contratos publicados
Atualizar versões conforme deprecation
Contribuir com exemplos quando possível
Reportar bugs e melhorias
```

---

## Métricas

```text
Linguagens suportadas
Downloads por SDK por mês
Versões ativas em produção
Taxa de atualização
Issues e bugs reportados
Tempo de resposta para correções
Extensões publicadas por tenants
Adoção de extensões
Satisfação dos desenvolvedores
```
