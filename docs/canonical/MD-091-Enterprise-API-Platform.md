# MD-091 — Enterprise API Platform

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a plataforma de APIs da empresa, garantindo acesso seguro, escalável e governado a todos os serviços e dados.

---

## Princípio Fundamental

```text
Nenhum dado ou serviço é acessado diretamente.
Toda interação passa pela API Platform.
Toda API é versionada, documentada e governada.
```

---

## Princípios

1. APIs são a interface pública da plataforma.
2. Toda API é versionada (sem breaking changes sem migração).
3. Segurança é obrigatória (OAuth2, mTLS, rate limit).
4. Descoberta é via Developer Portal.
5. Métricas e SLA são públicos.
6. APIs são primeiro-class citizens na arquitetura.
7. Consumidores internos e externos seguem os mesmos contratos.

---

## Componentes

### API Gateway

```text
Roteamento
Load balancing
Rate limiting
Circuit breaker
Cache
Auth (JWT/OAuth2)
Logging
Monitoring
Mascaramento de payload
```

### Developer Portal

```text
Catálogo de APIs
Documentação interativa (OpenAPI)
Sandbox de testes
SDKs por linguagem
Status e健康 métricas
Planos de acesso por tenant
Suporte e comunidade
```

### Contratos

```text
OpenAPI 3.0
Schema Registry
Versionamento semântico
Deprecation policy
Changelog obrigatório
Backward compatibility garantida
```

### Segurança

```text
OAuth2 / OpenID Connect
mTLS para B2B
API Keys para parceiros
Rate limiting por tenant/usuário
Quotas por plano
WAF (Web Application Firewall)
DDoS protection
Auditoria completa
```

### Monitoramento

```text
Latência (P50, P95, P99)
Taxa de erro
Taxa de sucesso
Volume de requisições
Dashboard por API
Alertas PagerDuty/Slack
Trace distribuído (OpenTelemetry)
```

---

## Camadas de API

### APIs Internas

```text
Comunicação entre microserviços
Autenticação interna (service mesh)
Alta performance
Protocolo gRPC/HTTP2
```

### APIs Externas

```text
Parceiros e integradores
OAuth2 + mTLS
Rate limiting rigoroso
Documentação pública controlada
Sandbox separado
```

### APIs Públicas

```text
Partners
Desenvolvedores externos
Documentação aberta
Freemium ou pago
Self-service onboarding
```

---

## Integrações

```text
MD-019 App-Registry-Canonico
MD-014 App-Registry
MD-034 IAM
MD-038 Integration-Hub
MD-025 Event-Store
MD-039 Analytics-Data-Intelligence
MD-035 Security-Trust-Architecture
MD-013 Frontend-Shell
```

---

## Regras

1. Toda nova API nasce no Developer Portal catalogada.
2. Versionamento é obrigatório antes do primeiro deploy.
3. Breaking changes geram nova versão, não overwrite.
4. Toda API tem documentação OpenAPI completa.
5. Sandbox é obrigatório para APIs novas.
6. Métricas são públicas para o tenant dono.
7. Deprecated APIs têm prazo mínimo de 6 meses antes da remoção.
8. Rate limiting é configurável por tenant e por usuário.

---

## Lei

```text
API não é endpoint solto.
API é contrato público da plataforma.
Quebrar contrato é quebrar confiança.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Gateway e Developer Portal
Versionamento e contratos
Segurança e rate limiting
Monitoramento e métricas
Documentação oficial
SDKs mantidos
```

Desenvolvedores são responsáveis por:

```text
Documentar suas APIs
Seguir contratos publicados
Manter backward compatibility
Reportar mudanças com antecedência
Testar no sandbox antes de publicar
```

---

## Métricas

```text
APIscatalogadas
Versões ativas
Requisições por dia
Latência P95
Taxa de erro
Uptime por API
Desenvolvedores ativos
SDKs mais usados
Deprecations pendentes
```
