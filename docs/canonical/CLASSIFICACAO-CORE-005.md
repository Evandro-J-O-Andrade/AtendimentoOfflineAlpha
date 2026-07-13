# CLASSIFICACAO-CORE-005

## Metodologia

```text
REUSE     → objeto existente reutilizável sem alteração
ADAPT     → objeto existente que precisa ajuste mínimo
EXTEND    → nova capacidade sobre domínio existente
MERGE     → unificação de objetos existentes
PROPOSE   → criação nova sem correspondente
```

---

## sp_auth_permissions_evaluate

### Fontes analisadas

| Fonte | Situação |
|-------|----------|
| `sp_auth_menu_get` | Existe no dump; contém subconsulta de permissões por perfil/local/entidade |
| `sp_sessao_assert` | Existe no dump; valida sessão ativa/não expirada |
| `sp_auth_permissions_evaluate` | AUSENTE no dump; PROPOSTA no Banco Vivo |
| `permissao`, `perfil_permissao`, `permissao_local` | Existem; REUSE |
| `sessao_usuario` | Existe; REUSE |
| Backend `PermissionService` | Consome `sp_auth_permissions_evaluate` via CALL |

### Análise por domínio

#### Auth

```text
sp_auth_permissions_evaluate
    ↓
sessao_usuario
    ↓
perfil_permissao
    ↓
permissao
```

Nenhuma dessas tabelas/SPs é nova. A lógica de avaliação já existe espalhada em:

- `sp_auth_menu_get` (consulta de permissões + local)
- `sp_sessao_assert` (validação de sessão)
- `sp_auth_permissions_evaluate` (proposta — ausente)

#### Permissão

A permissão no banco é modelada como:

```text
permissao (codigo, ativo, id_entidade)
    ↓
perfil_permissao (id_perfil, id_permissao, id_entidade)
    ↓
permissao_local (id_permissao, id_local) [gap: sem CREATE TABLE explícito]
```

A avaliação de "esta sessão pode executar esta capability?" não existe como SP canônica única. Ela é feita de forma ad-hoc por cada domínio.

#### Runtime

O backend já referencia `sp_auth_permissions_evaluate`:

```typescript
// PermissionService.ts
CALL sp_auth_permissions_evaluate(?, @permissions)
```

Portanto a capacidade **já foi proposta pelo Runtime**, mas não existe no banco.

---

## Classificação

```text
EXTEND do domínio Auth/Permission
```

### Justificativa

- **REUSE**: Não. Não existe SP canônica única avaliando permissão por capability. As peças existem, mas não a função agregada.
- **ADAPT**: Não. `sp_auth_permissions_evaluate` não existe no dump; não há o que adaptar diretamente. As SPs próximas (`sp_auth_menu_get`, `sp_sessao_assert`) são ADAPT/REUSE como componentes, mas não como solução final.
- **MERGE**: Não. Não há duas SPs de avaliação para unificar.
- **PROPOSE**: Não totalmente. A capacidade de avaliação já existe de forma difusa nas SPs atuais e no backend. Não é uma capability nova do zero; é uma **extensão** do domínio existente.
- **EXTEND**: Sim. O domínio Auth/Permission já possui tabelas (`permissao`, `perfil_permissao`) e SPs (`sp_auth_menu_get`). A nova SP estende esse domínio para expor uma **avaliação canônica de capability**, que é exatamente o que o contrato do backend e o ADR-CORE-005 exigem.

---

## Representação final

```text
Domínio Auth/Permission existente
    ↓
EXTEND
    ↓
sp_auth_permissions_evaluate
```

---

## Relação com a governança

```text
REUSE   → permissao, perfil_permissao, sessao_usuario
ADAPT   → sp_auth_menu_get (extrai subconsulta como referência)
EXTEND  → sp_auth_permissions_evaluate (nova SP sobre domínio existente)
PROPOSE → capability como conceito canônico (já em andamento no Registry)
```

---

## Conclusão

CORE-005 não é PROPOSE puro. É **EXTEND de Auth/Permission** porque:

1. A tabela `permissao` já existe.
2. A tabela `perfil_permissao` já existe.
3. O backend já chama `sp_auth_permissions_evaluate`.
4. O ADR-CORE-005 define a evolução, não a criação do zero.
5. A única ausência real é a SP canônica de avaliação.

Isso confirma a classificação anterior, mas agora com rastreabilidade metodológica completa.
