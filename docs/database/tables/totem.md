# totem

**Objetivo:** Gestão de totens de autoatendimento

**Descrição:** A tabela `totem` armazena dados relacionados a gestão de totens de autoatendimento. Contém 8 colunas, com chave primária em `id_totem` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade)). Possui restrições de unicidade em: id_unidade, codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_totem | BIGINT | Não | NULL | Dados do totem de autoatendimento |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| codigo | VARCHAR(50) | Não | NULL | Código de identificação do item |
| descricao | VARCHAR(150) | Sim | NULL | Descrição textual do item |
| ip | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_totem`
- **Únicas:**
  - uk_totem: `id_unidade`, `codigo`
- **Estrangeiras:**
  - fk_totem_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- FOREIGN KEY `fk_totem_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- UNIQUE KEY `uk_totem` em (`id_unidade, codigo`)
- PRIMARY KEY em (`id_totem`)

## Relacionamentos e Cardinalidade

- **totem -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `totem` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia totens de autoatendimento, incluindo eventos, feedback e configuração de opções de senha, suportando fluxo de recepção.
