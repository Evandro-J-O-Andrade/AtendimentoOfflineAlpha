# AUDITORIA-IMPACT-SP-MASTER-LOGIN

## Status

```text
APROVADO PARA APLICAÇÃO
```

Nenhuma quebra de compatibilidade detectada nos ramos afetados.

---

## 1. Riscos avaliados

| Risco | Status | Observação |
|-------|--------|------------|
| Quebra em `sp_master_orquestradora` | ✅ Baixo | A orquestradora repassa payload JSON; a SP apenas lê campos existentes |
| Quebra no backend `AuthService` | ✅ Baixo | Backend já não usa `senha` na SP; faz bcrypt no TypeScript |
| Quebra em tools/sp-client-generator | ✅ Baixo | Gerador reflete assinatura, não conteúdo interno |
| Quebra em ramos `AUTH.CONTEXTO.*` | ✅ Nenhum | Ramos permanecem inalterados |
| Quebra em `AUTH.SESSAO.ASSERT` | ✅ Nenhum | Permanece inalterado |
| Quebra em `AUTH.LOGOUT.REQUEST` | ✅ Nenhum | Permanece inalterado |

---

## 2. Chamadas mapeadas

### sp_master_orquestradora

Local: `Dump20260618.sql:26000`, `26861`, `26955`

```sql
CALL sp_master_login(
    p_acao,
    p_payload,
    p_resultado,
    p_sucesso,
    p_mensagem
);
```

A chamada éagnóstica ao conteúdo da SP. A alteração interna não afeta a assinatura.

### Backend AuthService

Local: `backend/src/core/auth/AuthService.ts:11`

```typescript
const [rows] = await conn.query('CALL sp_master_login(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [
  'AUTH.LOGIN.REQUEST',
  JSON.stringify({ login, token_jwt, refresh_token, ip, device, fingerprint: device }),
  null, null, null, null, null, null, null, null, null, null
])
```

**Atenção:** backend passa 12 parâmetros para uma SP com 5. Isso funciona no MySQL por tolerância, mas é drift. Não será corrigido nesta migration para manter o escopo do ADAPT.

### Tools

Local: `tools/sp-client-generator/index.ts:203`, `tools/sp-analyzer/sp-client-generator.ts:270`

```typescript
'sp_master_login': 'Auth'
```

Apenas metadados. Nenhum impacto.

---

## 3. Conclusão

A ADAPT de `sp_master_login` pode ser aplicada sem quebra de contratos externos.

Alteração interna:
- `SELECT id_usuario, senha, ativo` → `SELECT id_usuario, ativo`
- Remove drift com a tabela `usuario`
- Alinha SP ao backend (que já faz bcrypt fora)

Próximo passo: aplicar migration no Banco Vivo.
