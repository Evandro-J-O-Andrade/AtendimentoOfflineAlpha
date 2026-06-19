# MD-010 — Security

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a segurança como camada transversal obrigatória para toda a plataforma, com isolamento multi-tenant e validação em todas as fronteiras.

---

## Princípio Fundamental

```text
Nenhuma solicitação entra sem identidade verificada.
Nenhuma ação sai sem auditoria registrada.
Nenhum dado de tenant é misturado com outro tenant.
```

---

## Pilares De Segurança

### Identidade E Autenticação

```text
JWT Obrigatório
Refresh Token Rotativo
Sessão Vinculada A Tenant + Contexto
Validação A Cada Requisição
```

### Autorização

```text
Perfil + Permissão + Contexto = Acesso
Verificação No Dispatcher
Validação Por SP
Nunca Apenas No Frontend
```

### Isolamento Multi-Tenant

```text
Cada tenant Isolado Fisicamente
Cada tenant Isolado Logicamente
Cada tenant Isolado Na Auditoria
Cada tenant Isolado Na Configuração
```

### Proteção De Dados

```text
Criptografia Em Trânsito (TLS 1.3+)
Criptografia Em Repouso
Dados Sensíveis Sempre Criptografados
Chaves Gerenciadas Por Tenant Quando Aplicável
```

### Auditoria E Rastreabilidade

```text
Event Store Canônica
Log De Segurança Separado
Imutabilidade De Registros
Rastreamento De Sessão Completo
```

---

## Regras De Autenticação

1. Login gera JWT com claims mínimos.
2. JWT contém: id_sessao, id_usuario, id_tenant, id_perfil.
3. Refresh Token é armazenado criptografado e vinculado à sessão.
4. Sessão expira por inatividade e por tempo máximo.
5. Logout invalida sessão e refresh token.
6. Credenciais NUNCA retornam ao frontend.
7. Senha segue política de força e rotação.
8. MFA pode ser habilitado por tenant.

### JWT Claims Padrão

```json
{
  "sub": "id_usuario",
  "sessao": "id_sessao",
  "tenant": "id_tenant",
  "perfil": "id_perfil",
  "contexto": {
    "unidade": "id_unidade",
    "local": "id_local"
  },
  "iat": "timestamp",
  "exp": "timestamp"
}
```

---

## Regras De Autorização

1. Toda ação passa pelo Dispatcher.
2. Dispatcher valida sessão ativa.
3. Dispatcher valida contexto operacional.
4. Dispatcher executa sp_permissao_assert.
5. SP valida permissão específica para ação.
6. Nenhuma ação executa sem validação dupla: sessão + permissão.
7. Permissões são granulares por ação de domínio.

### Cadeia De Validação

```text
JWT
  ↓
Sessão Ativa?
  ↓
Contexto Válido?
  ↓
Perfil Tem Permissão?
  ↓
sp_permissao_assert
  ↓
Execução Permitida
```

---

## Isolamento Multi-Tenant

### Regras

1. Cada tenant define próprias unidades, locais, usuários, perfis.
2. Nenhuma query cruza dados de tenants diferentes.
3. Todas as SPs recebem id_tenant como parâmetro.
4. Índices de banco incluem id_tenant sempre.
5. Views e relatórios filtram por tenant explicitamente.
6. Cache é segregado por tenant.
7. Arquivos e documentos são isolados por tenant.

### Verificação Obrigatória

Toda stored procedure inicia com:

```sql
DECLARE @id_tenant INT = ?;
-- validação de tenant proprietário do recurso
```

---

## Proteção De Aplicações E Endpoints

### Frontend

```text
HTTPS Obrigatório
Cabeçalhos De Segurança Configurados
Content Security Policy (CSP)
Cookies HttpOnly E Secure
Armazenamento Local Proibido Para Tokens
Refresh Token Apenas Em Cookie HttpOnly
```

### Backend

```text
TLS 1.3 Obrigatório
Rate Limiting Por Tenant E Por Usuário
Validação De Payload Em Toda Entrada
Sanitização De Dados De Entrada
Proteção Contra SQL Injection (somente SPs)
Proteção Contra XSS
Proteção Contra CSRF
```

### API

```text
Autenticação Em Toda Rota
Autorização Granular
Throttling Configurado
Log De Acesso Completo
Bloqueio De IP Suspeito
Validação De Origem (CORS)
```

---

## Segurança Do Dispatcher

1. Dispatcher é a única porta de entrada de ações.
2. Dispatcher valida JWT em toda requisição.
3. Dispatcher valida sessão antes de rotear.
4. Dispatcher valida permissão antes de executar.
5. Dispatcher registra toda tentativa (sucesso ou falha).
6. Payload é validado contra schema canônico.
7. Dispatcher NUNCA executa SQL direto.

---

## Segurança Das Stored Procedures

### SPs De Validação Obrigatórias

sp_sessao_assert:
  - Valida sessão ativa
  - Valida tenant da sessão
  - Valida usuário da sessão
  - Retorna dados autorizados

sp_permissao_assert:
  - Valida permissão do perfil
  - Valida ação solicitada
  - Valida contexto operacional
  - Retorna autorização

sp_guardiao_runtime_final:
  - Valida ambiente de execução
  - Valida tenant ativo
  - Valida Unidade/local permitidos
  - Aplica regras de segurança finais

### Regras De Implementação De SPs

1. Toda SP deve receber id_sessao como primeiro parâmetro.
2. Toda SP deve receber id_tenant como segundo parâmetro.
3. Toda SP deve chamar sp_sessao_assert no início.
4. Toda SP deve chamar sp_permissao_assert antes da ação principal.
5. Toda SP deve gerar evento via sp_ evento_registrar no final.
6. SPs não devem receber IDs de sessão ou tenant do payload do frontend.
7. SPs confiam apenas no token JWT validado pelo Dispatcher.

---

## Segurança De Dados

### Classificação

```text
Público
Interno
Confidencial
Restrito
```

### Regras

1. Dados de saúde seguem regulamentação aplicável (LGPD, etc.).
2. Dados financeiros seguem regulamentação aplicável.
3. Registros de auditoria são imutáveis.
4. Backup é criptografado.
5. Acesso a dados sensíveis é logado.
6. Exclusão é lógica com rastro.
7. Exportação de dados requer justificativa e aprovação.
8. Dados de tenant não podem ser replicados para outro tenant.

---

## Segurança De Infraestrutura

```text
Ambientes separados: desenvolvimento, homologação, produção
Acesso a produção restrito a operações
Segredos em cofre de segredos (nunca em código)
Logs centralizados e monitorados
Alertas de segurança configurados
Backup automático com teste de restauração
Vulnerabilidades corrigidas em SLA definido
Pentest periódico
```

---

## Incidentes E Resposta

### Classificação

```text
P1 - Crítico: vazamento de dados, indisponibilidade total
P2 - Alto: acesso não autorizado confirmado, falha de segurança
P3 - Médio: tentativa de invasão, vulnerabilidade reportada
P4 - Baixo: falha de autenticação, alerta informativo
```

### Resposta Obrigatória

1. Registrar incidente no Event Store.
2. Isolar recurso afetado.
3. Notificar responsáveis.
4. Executar plano de resposta.
5. Documentar causa raiz.
6. Aplicar correção.
7. Comunicar stakeholders quando aplicável.

---

## Proibições

São proibidos:

```text
Tokens JWT no localStorage
Senhas em texto plano
Logs contendo senhas ou tokens
Acesso direto a banco sem validação de tenant
Queries cross-tenant
Autenticação bypassada por query parameter
Permissões hardcoded
Compartilhamento de sessão entre usuários
Testes com dados reais de produção
Remoção de logs de auditoria
Uso de HTTP fora de ambientes internos explícitos
Idempotência ignorada em ações financeiras
```

---

## Lei Da Segurança

```text
Nenhuma solicitação entra sem identidade.
Nenhuma ação sai sem rastro.
Nenhum dado de tenant alcança outro tenant.
```

---

## Responsabilidades

O Core De Segurança É Responsável Por:

```text
Políticas De Autenticação E Autorização
Gerenciamento De Tokens E Sessões
Implementação De Validações Multi-Tenant
Definição De Padrões De Criptografia
Configuração De Cabeçalhos De Segurança
Documentação De Procedimentos De Incidente
Revisão De Conformidade
```

Desenvolvimento De Aplicações É Responsável Por:

```text
Implementar Validação De Sessão Em Toda Requisição
Respeitar Isolamento De Tenant
Não Armazenar Segredos Em Código
Reportar Vulnerabilidades
Seguir Padrões De Segurança Documentados
