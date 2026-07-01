# permissao_local

**Objetivo:** Associar permissões a locais específicos para controle granular de acesso por localidade.

**Descrição:** Tabela de relacionamento N:N entre `permissao` e `local` que define onde cada permissão pode ser exercida. Permite que uma permissão só esteja disponível em determinados locais (ex: uma permissão de "Triagem" só pode ser usada no local de Triagem).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_permissao_local | bigint | NOT NULL | AUTO_INCREMENT | Chave primária da associação |
| id_permissao | bigint | NOT NULL | - | FK para permissao.id_permissao |
| id_local | bigint | NOT NULL | - | FK para local.id_local |
| id_entidade | bigint unsigned | NOT NULL | - | FK para saas_entidade.id_entidade |
| ativo | tinyint | YES | '1' | Flag de ativação da associação |

## Chaves
- **Primária:** id_permissao_local
- **Únicas:** uk_perm_local (id_permissao, id_local) - uma permissão só pode existir uma vez por local
- **Estrangeiras:**
  - fk_perm_loc_permissao → permissao(id_permissao)
  - fk_perm_loc_local → local(id_local)
  - fk_perm_loc_entidade → saas_entidade(id_entidade)

## Índices
- PRIMARY KEY (id_permissao_local)
- uk_perm_local (id_permissao, id_local) - unique constraint
- idx_perm_local_permissao (id_permissao)
- idx_perm_local_local (id_local)

## Constraints
- FOREIGN KEY fk_perm_loc_permissao (id_permissao) REFERENCES permissao(id_permissao)
- FOREIGN KEY fk_perm_loc_local (id_local) REFERENCES local(id_local)
- FOREIGN KEY fk_perm_loc_entidade (id_entidade) REFERENCES saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com permissao (uma permissão pode ter muitos locais)
- N:1 com local (um local pode ter muitas permissões)
- N:1 com saas_entidade

## Uso no Menu Dinâmico
Na SP `sp_auth_menu_get`, o JOIN com `permissao_local` filtra o menu:
```sql
LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
WHERE ... AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
```
- `pl.id_local IS NULL` - permissão disponível globalmente (em qualquer local)
- `pl.id_local = v_id_local` - permissão disponível apenas no local específico

## Fluxo de utilização
- Definido em administração: administrador associa permissões a locais
- Carregado no login: sistema verifica quais permissões estão disponíveis para o local do usuário
- Validação em tempo real: cada ação verifica se a permissão está habilitada para o contexto do local

## NOTA
Esta tabela **existe no dump SQL** (referenciada por sp_auth_menu_get) mas **não possui CREATE TABLE explícito** no dump principal. É uma tabela implícita necessária para o funcionamento do controle de menu por local. Deve ser criada se não existir.