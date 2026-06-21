# MD-035 — Security Trust Architecture

## Status

Documento Canônico da Arquitetura de Segurança e Confiança da Plataforma Enterprise.

---

## Objetivo

Consolidar todos os pilares de segurança da plataforma.

Zero Trust como foundation.

Isolamento total por tenant.

Proteção contra exposição de dados sensíveis no frontend.

---

## Lei Fundamental

```text
Confiança não é dada.

Confiança é verificada.

Verificada é contínua.

Contínua é automática.
```

---

## Security Architecture Layers

```text
Identity Layer
Browser Security Layer
API Security Layer
Network Layer
Data Layer
Application Layer
Platform Layer
Compliance Layer
```

---

## Zero Trust Implementation

 Princípios:

```text
Never Trust
Always Verify
Least Privilege
Assume Breach
Verify Explicitly
Continuous Monitoring
```

### Verificações em Tempo Real

```text
JWT validation every request
Token expiration check
Permission resolution per action
Context validation
Rate limiting
Anomaly detection
Behavior analysis
Device fingerprint verification
Session rotation validation
```

---

## Identity

### JWT HttpOnly

```text
JWT armazenado em cookie HttpOnly
JWT nunca acessível via JavaScript
JWT com claims mínimos obrigatórios
JWT com expiração curta (15min)
Claims: id_sessao, id_usuario, id_tenant, id_perfil
```

### Refresh Token HttpOnly

```text
Refresh token armazenado em cookie HttpOnly Secure
Refresh token com rotação obrigatória
Refresh token vinculado a sessão e device
Expiração longa (7 dias) com rotação contínua
Nunca retornado em responses
Nunca armazenado em localStorage
```

### Session Rotation

```text
Nova sessão gerada a cada refresh
Sessão anterior invalidada imediatamente
Correlação por execucao_uuid
Rotação transparente ao usuário
Revogação em cascade se suspeita
```

### Device Fingerprint

```text
Canvas fingerprint
WebGL fingerprint
Audio fingerprint
Font enumeration
Timezone
Language
Screen resolution
Hardware concurrency
Touch support
Platform signature
Hash composto para identificação única
Device trust score por sessão
```

```json
{
  "fingerprint_hash": "SHA256",
  "trust_score": 0-100,
  "components": {
    "canvas": "hash",
    "webgl": "vendor+renderer",
    "audio": "hash",
    "fonts": "list_hash",
    "screen": "w,h,depth",
    "timezone_offset": "integer"
  },
  "is_known": true,
  "risk_level": "LOW|MEDIUM|HIGH"
}
```

---

## Browser Security

### CSP (Content Security Policy)

```text
default-src 'self'
script-src 'self' 'nonce-{random}'
style-src 'self' 'nonce-{random}'
img-src 'self' data: https:
connect-src 'self' https://api.empresa.com
font-src 'self'
object-src 'none'
base-uri 'self'
form-action 'self'
frame-ancestors 'none'
upgrade-insecure-requests
report-uri /api/csp-report
```

### XSS Protection

```text
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Textos escapados em toda saída
JSON com content-type application/json
Input sanitization no backend
Output encoding contextual
CSP como defesa em profundidade
```

### CSRF Protection

```text
Anti-forgery token por sessão
Token validado em todo POST/PUT/DELETE
SameSite Strict em cookies de sessão
Double submit cookie pattern
Origin header validation
Referer header validation
Custom header X-CSRF-Token
```

### HSTS

```text
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
Forçar HTTPS em toda comunicação
Redirecionamento 301 para HTTPS
Certificate transparency
TLS 1.3 obrigatório
Cipher suites seguros
```

### SameSite Strict

```text
SameSite=Strict em todos cookies de sessão
SameSite=None apenas para cookies de integração externa com Secure flag
Cookie Secure flag sempre ativo
Cookie Domain restrito ao tenant
Cookie Path restrito à aplicação
```

---

## API Security

### API Gateway

```text
Toda requisição passa pelo API Gateway
Rate limiting por tenant, usuário, endpoint
Circuit breaker para serviços externos
Request/response validation
Schema enforcement (JSON Schema)
GraphQL query depth limiting
REST endpoint versionamento
Throttling por plano
```

### Rate Limit

```text
Global: 1000 req/min por tenant
Por usuário: 100 req/min
Por endpoint crítico: 10 req/min
Burst allowance: 2x limite por 30s
Excesso retorna 429 com Retry-After
Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
Distributed rate limit via Redis
```

### WAF (Web Application Firewall)

```text
OWASP Top 10 proteção
SQL injection blocking
XSS blocking
Command injection blocking
Path traversal blocking
File inclusion blocking
Bot detection
Anomaly scoring
IP reputation blocking
Geolocation blocking
```

### IP Reputation

```text
Score por IP baseado em histórico
Whitelist de IPs confiáveis por tenant
Blacklist dinâmica de IPs maliciosos
Geo-blocking configurável
Tor exit nodes bloqueados
VPN/Proxy detection
Behavioral analysis por IP
Real-time threat intelligence feeds
```

---

## Tenant Isolation

### Isolamento Total

```text
Físico: bancos separados ou schemas isolados
Lógico: RLS (Row Level Security) em todas tabelas
Cache: namespaces segregados por tenant
Files: storage paths isolados por tenant
APIs: tokens com tenant claim obrigatório
Scheduler: jobs segregados por tenant
Queue: filas separadas por tenant
Logs: acesso restrito por tenant
```

### Regras

1. Toda query inclui `id_tenant` na cláusula WHERE.
2. Índices sempre incluem `id_tenant`.
3. Views sempre filtram por `id_tenant`.
4. Nenhuma operação cross-tenant é permitida sem autorização explícita da plataforma.
5. Cache keys incluem `tenant:{id_tenant}:` prefixo.
6. Storage paths seguem padrão `/tenants/{id_tenant}/...`.
7. Eventos sempre carregam `id_tenant`.

```sql
-- Toda stored procedure inicia com:
DECLARE @id_tenant INT = ?;
IF NOT EXISTS (SELECT 1 FROM sys.tenants WHERE id = @id_tenant)
BEGIN
    RAISERROR('Tenant inválido', 16, 1);
    RETURN;
END
```

---

## Auditoria

### Event Store

Registro imutável de eventos:

```text
Toda ação gera evento imutável
Evento carrega: sessão, tenant, usuário, ação, timestamp, payload, resultado
Eventos são append-only
Eventos são replicados para cofre imutável
Indexados por domínio, tenant, sessão e tempo
Consultas sempre respeitam id_tenant
```

### Security Ledger

Registro de auditoria de segurança:

```text
Todos os eventos de autenticação
Todos os eventos de autorização
Todos os eventos de mudança de permissão
Todos os eventos de acesso a dado sensível
Todos os eventos de integração externa
Imutabilidade garantida por hash chain
Retenção mínima de 7 anos (LGPD compliance)
Acesso restrito a administradores de segurança
Exportação em formato auditável (PDF/A, CSV com checksum)
```

---

## F12 Protection Philosophy

### Princípio Fundamental

```text
Mesmo vendo F12,
não existe dado sensível exposto.
```

### O que NUNCA existe no frontend

```text
Senha (nem hash, nem parcial)
Refresh token
Access token secreto
API keys
Secrets de integração
ACL interna
Permissões granulares brutas
Chaves de criptografia
Connection strings
Credenciais de banco
Tokens de serviço
Cookies HttpOnly (por definição do browser)
```

### O que PODE existir no frontend (desde que protegido)

```text
ID de sessão (desde que JWT curto e não reversível)
Nome de usuário (dado público do contexto)
ID do tenant (contexto necessário)
ID do perfil (contexto necessário)
Roles/roles display names (não ACL lógica)
Configurações de UI não sensíveis
URLs públicas de assets
```

### Verificações

```text
1. Todo dado sensível deve vir do backend via API autenticada.
2. Todo dado sensível deve ser transient na memória (não persistido no browser storage).
3. Nunca usar localStorage/sessionStorage para tokens.
4. Cookies HttpOnly Secure SameSite Strict são obrigatórios para sessão.
5. CSP bloqueia inline scripts e eval.
6. Sanitização de toda saída no frontend.
7. Validação double-side: frontend valida formato, backend valida regras.
```

### Regra Fundamental

```text
F12 pode ver o HTML.
F12 não pode ver o segredo.
Segredo nunca sai do backend.
```

---

## Security Controls

### Identity & Access

```text
JWT HttpOnly
Refresh tokens HttpOnly
Session rotation obrigatória
Device fingerprint obrigatório
MFA (TOTP, WebAuthn, FIDO2)
Risk scoring dinâmico
Behavior analysis
Session binding (tenant + device + contexto)
```

### Network Security

```text
HTTPS mandatory
TLS 1.3
Certificate pinning para apps nativas
IP allowlisting configurável
Rate limiting distribuído
DDoS protection (cloud provider + application layer)
WAF com regras customizadas
Private network access para serviços internos
```

### Data Security

```text
Encryption at-rest (AES-256)
Encryption in-transit (TLS 1.3)
Field level encryption para dados sensíveis
PII masking em logs e não-produtivo
Audit trails separados por criticidade
Data classification automática
Data retention policies automáticas
Key rotation automática (KMS)
```

---

## Risk Scoring

Score de risco por ação:

```text
LOW
MEDIUM
HIGH
CRITICAL
```

### Fatores de Risco

```text
User behavior pattern
Location anomaly (país, região)
Device trust score
Time pattern (horário incomum)
Permission escalation attempt
Dado sensível acessado
External integration triggered
New device registration
Multiple failed logins
Token reuse attempt
```

---

## Threat Protection

Detecta:

```text
Brute force
Credential stuffing
Session hijacking
Token theft
Data exfiltration
Privilege escalation
Abuse patterns
Anomalous data access
Suspicious integration calls
Fake device fingerprint
```

### Resposta Automática

```text
Block IP temporariamente
Revoke session e refresh tokens
Force password reset com notificação
Enforce MFA temporariamente
Alert security team via canal seguro
Quarantine usuário para investigação
Rate limit reduzido para o tenant
Audit log especial gravado
Notificação ao tenant owner
Escalação para MD-040 quando compliance envolvida
```

---

## Compliance Engine

Monitora:

```text
LGPD
GDPR
SOC2
ISO27001
HIPAA
PCI_DSS
SOC 1/2/3
NIST
```

### Políticas Automáticas

```text
Data retention rules
Access logging completo
PII handling e anonimização
Audit requirements enforcement
Incident response automático
Data residency enforcement
Consent management (LGPD Article 7)
Right to erasure enforcement
Data portability enforcement
Breach notification automation
```

---

## Security Operations

### Security Center

Central de operações:

```text
Incidents
Alerts
Investigations
Remediations
Reports
Metrics
Threat intelligence
Compliance dashboard
```

### Response Orchestration

```text
Automated response (nível baixo/médio)
Human approval required (crítico)
Incident escalation por severidade
Forensics capture (memória, rede, disco)
Root cause analysis assistido por IA
Playbook-driven response
Post-incident review obrigatório
Remediation tracking
```

---

## Apps Registradas

```text
SECURITY_PLATFORM
TRUST_CENTER
RISK_MANAGER
COMPLIANCE_ENGINE
THREAT_DETECTION
INCIDENT_RESPONSE
SECURITY_ANALYTICS
AUDIT_CENTER
POLICY_MANAGER
CERTIFICATE_MANAGER
DEVICE_TRUST
SESSION_MANAGER
CSP_MONITOR
FINGERPRINT_VAULT
```

---

## Eventos Canônicos

Todos os eventos vão para Event Store.

### Eventos de Security

```text
LOGIN_SUCESSO
LOGIN_FALHA
LOGIN_SUSPEITO
MFA_SOLICITADO
MFA_APROVADO
MFA_REJEITADO
TOKEN_INVALIDO
TOKEN_REVOGADO
SESSAO_ROTACIONADA
TENTATIVA_INVASAO
WEBHOOK_SUSPEITO
DEVICE_DESCONHECIDO
LOCATION_ANOMALA
PERMISSAO_NEGADA
PERMISSAO_ALTERADA
DADO_SENSIVEL_ACESSADO
CONFIGURACAO_SEGURANCA_ALTERADA
```

### Eventos de Compliance

```text
POLITICA_VIOLADA
LGPD_ALERTA
AUDIT_INICIADO
AUDIT_CONCLUIDO
RETENCAO_APLICADA
ANONIMIZACAO_APLICADA
DADOS_EXPORTADOS
CONSENTIMENTO_REGISTRADO
DIREITO_ERASURE_SOLICITADO
BREACH_NOTIFICATION_TRIGGERED
```

---

## Integração com Outros MDs

- **MD-002 (Auth Core)**: base de autenticação.
- **MD-003 (Operational Context)**: contexto para decisões.
- **MD-004 (Dispatcher)**: roteamento de ações.
- **MD-005 (Event Store)**: eventos de segurança.
- **MD-010 (Security Core)**: base histórica.
- **MD-016 (Auditoria)**: auditoria de segurança.
- **MD-017 (MultiTenant)**: isolamento.
- **MD-020 (Portal Core)**: integração.
- **MD-025 (Event Store Core)**: eventos imutáveis.
- **MD-026 (Security Zero Trust)**: foundation.
- **MD-034 (IAM)**: identidade integrada.
- **MD-039 (Analytics Data Intelligence)**: threat analytics.

---

## Próximo MD recomendado

```text
MD-036 — Mobile PWA Architecture
```

Arquitetura mobile-first.

---

## Regras Canônicas

1. Security é transversal.
2. Portal Core é origem.
3. Zero Trust é foundation.
4. Todo acesso é verificado.
5. Todo token é validado.
6. Todo request tem contexto.
7. Security é event driven.
8. Security é IA assistida.
9. Security é compliance.
10. Security é automática.
11. Risk scoring é real time.
12. Threat detection é contínuo.
13. Response é automático.
14. Security integra com Analytics.
15. Security integra com Social.
16. Security integra com ITSM.
17. Security integra com IAM.
18. Security integra com Integration Hub.
19. Security tem dashboard.
20. Security tem alertas e forensics.
21. JWT é HttpOnly.
22. Refresh token é HttpOnly.
23. Session rotation é obrigatória.
24. Device fingerprint é obrigatório.
25. Nenhum dado sensível no frontend.
26. F12 não vê segredos.
27. Passwords nunca voltam ao frontend.
28. Secrets nunca tocam o frontend.
29. ACL nunca é exposta ao frontend.
30. Security é confiança.
