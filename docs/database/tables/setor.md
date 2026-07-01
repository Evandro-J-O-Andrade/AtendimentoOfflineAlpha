# setor

**Objetivo:** Cadastro de setores organizacionais

**Descrição:** A tabela `setor` armazena dados relacionados a cadastro de setores organizacionais. Contém 8 colunas, com chave primária em `id_setor` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_setor | INT | Não | NULL | Campo numérico inteiro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| nome | VARCHAR(100) | Não | NULL | Nome ou descrição do item |
| tipo | ENUM('PRONTO_SOCORRO','OBSERVACAO','INTERNACAO','UTI_ADULTO','UTI_PEDIATRICA','CENTRO_CIRURGICO') | Não | NULL | Classificação ou tipo do registro |
| ramal | VARCHAR(10) | Sim | NULL | Campo de texto de comprimento variável |
| responsavel_id | BIGINT | Sim | NULL | Identificador único da linha na tabela setor |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_setor`
- **Estrangeiras:**
  - fk_setor_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- fk_setor_unidade: `id_unidade`

## Constraints

- FOREIGN KEY `fk_setor_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- PRIMARY KEY em (`id_setor`)

## Relacionamentos e Cardinalidade

- **setor -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `setor` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Cadastro hierárquico de setores organizacionais para alocação de recursos e definição de fluxos assistenciais por área.
