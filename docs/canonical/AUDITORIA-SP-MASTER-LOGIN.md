# AUDITORIA-SP-MASTER-LOGIN

## Status

```text
REAUDITORIA NECESSÁRIA
```

`sp_master_login` instalada no Banco Vivo difere do dump canônico `Dump20260618.sql` e do backend atual. Nenhuma alteração será proposta até a classificação final por domínio.

---

## 1. Dump canônico

Fonte: `database/dump/Dump20260618.sql:25668`

Assinatura:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_login`(
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
SQL SECURITY INVOKER
proc: BEGIN
```

Ação `AUTH.LOGIN.REQUEST` no dump:

```sql
SELECT id_usuario, senha, ativo
INTO v_id_usuario, v_senha_hash, v_ativo
FROM usuario
WHERE login = v_login
LIMIT 1;
```

**Problema do dump:** referencia coluna `senha`, que não existe na tabela `usuario` do Banco Vivo atual (`usuario.senha_hash` é a coluna real). O backend atual também não usa `senha` na consulta; ele consulta `usuario` e faz `bcrypt.compare` no TypeScript antes de chamar a SP.

```text
Classificação dump: ADAPT / BUG
```

---

## 2. Banco Vivo atual

Instância: `pronto_atendimento` em `localhost:3306`, MySQL 8.0.44

Assinatura real (`SHOW CREATE PROCEDURE sp_master_login`):

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_login`(
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
SQL SECURITY INVOKER
proc: BEGIN
```

Ação `AUTH.LOGIN.REQUEST` no banco:

```sql
SELECT id_usuario, senha, ativo
INTO v_id_usuario, v_senha_hash, v_ativo
FROM usuario
WHERE login = v_login
LIMIT 1;
```

Coluna real da tabela `usuario`:

```text
id_usuario
id_pessoa
id_entidade
login
senha_hash
ativo
tentativas_login
bloqueado_ate
ultimo_login
ultimo_ip
criado_em
atualizado_em
```

```text
Classificação Banco Vivo: ADAPT / DRIFT
```

---

## 3. Backend

Fonte: `backend/src/core/auth/AuthService.ts:56-82`

Fluxo:

```text
authenticate(username, password, ip, device)
    ↓
SELECT id_usuario, senha, ativo FROM usuario WHERE login = ?
    ↓
bcrypt.compare(password, user.senha)
    ↓
login() → CALL sp_master_login('AUTH.LOGIN.REQUEST', payload, ...)
```

Observação: o backend NÃO valida senha dentro de `sp_master_login`. Ele faz a verificação bcrypt no TypeScript e, após sucesso, chama a SP para criar a sessão.

```text
Classificação backend: REUSE com checagem externa
```

---

## 4. Matriz de divergência

| Aspecto | Dump canônico | Banco Vivo atual | Backend |
|---------|---------------|------------------|---------|
| Senha dentro da SP | `SELECT senha` | `SELECT senha` | Não usa senha na SP |
| Validação de senha | Dentro da SP | Dentro da SP | No TypeScript (`bcrypt`) |
| Coluna `senha` | Referenciada | Referenciada (inválida) | Não referenciada |
| Coluna `senha_hash` | Não usada | Correta na tabela | Usada no backend |

Conclusão:

```text
Backend = realidade operacional
Dump = documento divergente
Banco Vivo = drift do dump
```

---

## 5. Classificação sugerida

### sp_master_login

```text
ADAPT
```

Motivo:

- A SP existe e é REUSE como ponto de entrada de sessão;
- Ela precisa ser ajustada para refletir o comportamento real do backend (sem validação de senha);
- O dump canônico está inconsistente com a tabela `usuario` e com o backend.

### Ação necessária

NÃO alterar `sp_master_login` diretamente sem registrar o drift nos MDs.

Fluxo correto:

```text
Banco Vivo
    ↓
MDs do banco
    ↓
SPs existentes
    ↓
REUSE / ADAPT / EXTEND / MERGE / PROPOSE
```

---

## 6. Opções

### Opção A — ADAPT do dump

Alinhar `sp_master_login` ao backend:

- Remover leitura de `senha` da SP;
- Manter apenas criação de sessão;
- Registrar que backend é a autoridade de autenticação.

Prós:
- SP reflete arquitetura real.
- Elimina drift perigoso.

Contras:
- Altera comportamento documentado no dump.

---

### Opção B — REUSE do Banco Vivo

Manter `sp_master_login` como está e corrigir apenas a coluna:

- Trocar `senha` por `senha_hash` na SP sem remover validação;
- Recriar validação legada na SP.

Prós:
- Menor mudança aparente.

Contras:
- Mantém regra de negócio duplicada (backend + SP);
- Reintroduce validação que o backend já removeu;
- Viola separação backend/SP.

---

### Opção C — PROPOSE nova master de autenticação

Criar `sp_master_auth` para login e deixar `sp_master_login` para sessão.

Prós:
- Separa autenticação de sessão.

Contras:
- Cria SP adicional sem necessidade agora.

---

## 7. Decisão recomendada

```text
Opção A — ADAPT
```

A sp_master_login deve:

1. Não validar senha;
2. Apenas criar/retornar sessão;
3. Ser chamada APÓS backend validar credenciais.

Isso mantém:

```text
Backend = autenticação
SP = materialização de sessão
```

---

## 8. Próximos passos

1. Registrar drift em `DECISION-LOG.md` ou documento equivalente.
2. Corrigir `sp_master_login` no Banco Vivo via migration ADAPT.
3. Re-executar testes funcionais do CORE-005.
4. Fechar GATE-CORE-005.

---

## Rastreabilidade

| Artefato | Localização |
|----------|-------------|
| Dump canônico | `database/dump/Dump20260618.sql:25668` |
| Banco Vivo | `pronto_atendimento.sp_master_login` |
| Backend | `backend/src/core/auth/AuthService.ts` |
| SP CORE-005 | `database/migrations/proposed/MD-CORE-005-sp_auth_permissions_evaluate.sql` |
| ADR CORE-005 | `docs/canonical/ADR-CORE-005-PERMISSION-EVALUATE.md` |
| GATE CORE-005 | `docs/canonical/GATE-CORE-005.md` |
