# MD-026 — Security Zero Trust

## Status

Documento Canônico da Segurança Corporativa da Plataforma Enterprise.

---

## Objetivo

Definir o modelo oficial de segurança da plataforma SaaS Enterprise Multi-Tenant.

A segurança é transversal.

Nenhuma aplicação pode implementar modelo próprio de autenticação, autorização ou proteção.

---

## Lei Fundamental

```text
Não existe confiança implícita.

Toda requisição deve provar:

Quem é.
Onde está.
O que pode fazer.
Para qual tenant está operando.
```

---

## Princípio Zero Trust

Toda operação deve validar:

```text
Identidade
Sessão
Tenant
Escopo
Permissão
Dispositivo
Origem
Integridade
```

antes de executar qualquer ação.

---

## Camadas de Segurança

## Camada 1 — Identity

Responsável por:

```text
Login
Usuário
Sessão
Perfis
Permissões
MFA
```

Motor:

```text
Auth Core
```

Regras:

1. Identidade pertence ao Auth Core.
2. Nenhuma App cria identidade própria.
3. Login, logout, sessão e MFA são centralizados.
4. Perfis e permissões são resolvidos por política.
5. Toda tentativa de identidade gera evento auditável.

---

## Camada 2 — Session Governance

Toda sessão possui:

```json
{
  "id_sessao": "",
  "id_usuario": "",
  "id_tenant": "",
  "device_fingerprint": "",
  "ip": "",
  "user_agent": "",
  "created_at": "",
  "expires_at": ""
}
```

Regras:

1. Sessão é canônica.
2. App não cria sessão própria.
3. Sessão vincula usuário, tenant, dispositivo, IP e contexto.
4. Sessão expira por inatividade e por tempo máximo.
5. Logout invalida sessão.
6. Troca suspeita de dispositivo força revalidação.
7. Toda mudança de sessão gera evento.

---

## Camada 3 — JWT Enterprise

Tokens nunca podem conter dados sensíveis.

Permitido:

```json
{
  "sub": "123",
  "tenant": "10",
  "session": "999"
}
```

Proibido:

```text
CPF
Senha
Email
Permissões completas
Dados financeiros
Dados clínicos
```

Regras:

1. JWT contém apenas identificadores mínimos.
2. JWT não contém segredos.
3. JWT não contém permissões completas.
4. JWT não contém dados sensíveis.
5. JWT deve estar vinculado a sessão ativa.
6. JWT deve expirar.
7. JWT deve ser invalidado em logout e incidente.

---

## HttpOnly Security

Obrigatório:

```text
HttpOnly Cookie
Secure Cookie
SameSite Strict
```

Proibido:

```text
localStorage
sessionStorage
```

para armazenar tokens.

Regras:

1. JavaScript nunca lê o token.
2. Token nunca é retornado em payload JSON.
3. Token nunca é enviado em query string.
4. Cookie deve ser Secure.
5. Cookie deve ser HttpOnly.
6. Cookie deve usar SameSite Strict quando aplicável.

---

## Refresh Token

Modelo obrigatório:

```text
Access Token
15 minutos

Refresh Token
7 dias
```

Rotação obrigatória.

Regras:

1. Access Token tem vida curta.
2. Refresh Token fica em cookie HttpOnly.
3. Refresh Token é rotacionado.
4. Refresh Token antigo é invalidado após uso.
5. Refresh Token é vinculado a sessão e dispositivo.
6. Rotação suspeita gera evento de segurança.

---

## Device Fingerprint

Toda sessão gera fingerprint.

Componentes:

```text
User Agent
Device
Timezone
Idioma
Resolução
Plataforma
```

Mudanças suspeitas:

```text
Forçam revalidação
```

Regras:

1. Device fingerprint é parte da sessão.
2. Mudança relevante exige revalidação.
3. Dispositivo desconhecido pode exigir MFA.
4. Dispositivo bloqueado não renova sessão.
5. Fingerprint não substitui autenticação.

---

## Google Security Layer

Integrações permitidas:

```text
Google reCAPTCHA Enterprise
Google Safe Browsing
Google Threat Intelligence
```

Aplicações:

```text
Login
Reset de senha
Cadastro
APIs públicas
```

Regras:

1. Google protege risco, não autorização de negócio.
2. Login deve passar por avaliação de risco.
3. APIs públicas devem ter proteção anti-bot.
4. Tentativas suspeitas geram evento de segurança.
5. Erros não revelam existência de usuário.

---

## Proteção Contra DevTools

Objetivo:

```text
Mesmo com F12 aberto,
nenhum dado sensível pode ser exposto.
```

## Frontend Nunca Recebe

```text
Hash de senha
JWT interno
Secrets
Connection strings
Credenciais
Chaves API
Tokens de integração
```

Proibido como controle de segurança:

```text
Bloquear F12
Bloquear botão direito
Bloquear DevTools
Confiar em ofuscação
```

Regra:

```text
Se o navegador recebeu, o usuário pode ver.
Se o usuário não pode ver, o navegador não recebe.
```

---

## Multi-Tenant Isolation

Obrigatório:

```text
Tenant A nunca vê Tenant B
```

Validação em:

```text
Frontend
Gateway
Dispatcher
SP
Banco
```

Regras:

1. Tenant é validado em toda camada.
2. `id_tenant` ou `id_saas_entidade` deve estar na sessão.
3. Toda SP valida tenant antes da execução.
4. Eventos, auditoria, cache e filas são segregados por tenant.
5. Super Admin só acessa outros tenants por permissão explícita.
6. Falha de tenant isolation é incidente crítico.

---

## Dispatcher Security

Toda chamada:

```text
Frontend
↓
Dispatcher
↓
Auth
↓
ACL
↓
Tenant Validation
↓
Executor
```

Regras:

1. Dispatcher é a porta oficial de ação.
2. Nenhuma App chama executor diretamente.
3. Nenhuma App chama SP diretamente.
4. Dispatcher valida identidade, sessão, tenant, escopo e ACL.
5. Toda tentativa gera evento.
6. Bypass do Dispatcher é proibido.

---

## ACL Dinâmico

Modelo:

```text
Usuário
↓
Apps
↓
Permissões
↓
Escopo
```

Exemplo:

```json
{
  "app": "FINANCEIRO",
  "acao": "PAGAMENTO_APROVAR",
  "permitido": true
}
```

Regras:

1. ACL é resolvida em runtime.
2. ACL considera usuário, app, ação, tenant, contexto e dispositivo.
3. ACL não é hardcoded em App.
4. ACL negativa deve gerar evento.
5. ACL positiva deve ser auditável.
6. ACL não substitui validação de SP.

---

## Webhook Security

Todo webhook deve possuir:

```text
Signature
Timestamp
Nonce
Replay Protection
```

## Obrigatório

Validação:

```text
SHA256
HMAC
RSA
```

dependendo da integração.

Regras:

1. Webhook aberto é proibido.
2. Assinatura deve ser validada antes do processamento.
3. Timestamp deve expirar.
4. Nonce deve impedir replay.
5. Origem deve ser conhecida ou allowlisted quando aplicável.
6. Payload inválido não executa ação.
7. Todo webhook gera evento de segurança.

---

## N8N Security

Fluxos N8N nunca executam diretamente.

Sempre:

```text
N8N
↓
Webhook Seguro
↓
Dispatcher
↓
SP
↓
Evento
```

Regras:

1. N8N não acessa banco diretamente.
2. N8N não recebe credenciais sensíveis.
3. Todo workflow possui owner.
4. Todo workflow possui tenant.
5. Todo workflow possui auditoria.
6. Todo workflow possui versionamento.
7. Todo workflow respeita permissões.
8. Webhook de N8N segue Webhook Security.

---

## API Security

Todas APIs:

```text
HTTPS obrigatório
TLS 1.3
Rate Limit
WAF
Audit Trail
```

Regras:

1. Toda API exige HTTPS.
2. Toda API exige autenticação quando aplicável.
3. Toda API valida tenant e contexto.
4. Toda API possui rate limit.
5. Toda API possui auditoria.
6. Toda API deve evitar vazamento de dados internos em erro.

---

## Auditoria Obrigatória

Toda tentativa gera evento.

Exemplos:

```text
LOGIN_SUCESSO
LOGIN_FALHA
TOKEN_RENOVADO
PERMISSAO_NEGADA
WEBHOOK_RECEBIDO
TENANT_INVALIDO
```

Obrigatório registrar:

```text
Quem
Quando
Onde
Tenant
Sessão
IP
Dispositivo
Resultado
UUID
```

Regras:

1. Auditoria é append-only.
2. Auditoria não pode ser alterada.
3. Auditoria não pode ser excluída.
4. Auditoria deve preservar tenant.
5. Auditoria deve registrar sucesso e falha.
6. Auditoria alimenta Security Analytics.

---

## Security Analytics

Portal deve possuir dashboard de:

```text
Sessões Ativas
Falhas de Login
Tentativas Bloqueadas
Webhooks
Tokens
Integrações
N8N
Uso por Tenant
```

Regras:

1. Security Analytics deriva do Event Store.
2. Super Admin vê a plataforma inteira.
3. Tenant Admin vê apenas seu tenant.
4. Usuário comum vê apenas seu contexto.
5. Incidentes críticos geram alerta de governança.

---

## Proibições

Proibido:

```text
Token em localStorage

Senha sem hash

JWT eterno

API sem HTTPS

Webhook sem assinatura

Permissão hardcoded

Acesso sem contexto

Acesso sem tenant

Dados sensíveis no frontend

Bypass do Dispatcher

Bypass de Auditoria

Bypass de Tenant

App com autenticação própria

SQL direto em App

Credenciais no Frontend

API Keys no Frontend

Tokens de IA no Frontend

Connection Strings no Frontend

Confiar em bloqueio de DevTools como segurança
```

---

## Integração Com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, perfil, permissão e tenant.
- **MD-003 (Operational Context)**: contexto operacional obrigatório.
- **MD-004 (Dispatcher)**: validação e entrada oficial de ações.
- **MD-005 (Event Store)**: auditoria e eventos de segurança.
- **MD-010 (Security)**: base canônica anterior de segurança.
- **MD-016 (Auditoria)**: rastreabilidade e imutabilidade.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-019 / MD-023 (App Registry / Action Registry)**: apps e ações registradas.
- **MD-025 (Event Store Core)**: imutabilidade histórica.
- **MD-034 (Identity Access Management)**: usuários, apps, escopos, perfis dinâmicos e permissões.
- **MD-033 (Analytics Governance)**: Security Analytics e dashboards de risco.

---

## Próximo MD recomendado

```text
MD-034-Identity-Access-Management.md
```

Ele define o novo modelo de usuários, apps, escopos, tenants, perfis dinâmicos e permissões do Portal Enterprise sem depender de cargos fixos como `Gestor HIS` ou `Gestor CRM`.

---

## Lei Canônica

```text
Toda operação deve ser autenticada.

Toda autenticação deve ser autorizada.

Toda autorização deve ser auditada.

Toda auditoria deve ser rastreável.

Sem rastreabilidade não existe operação.
```

---
