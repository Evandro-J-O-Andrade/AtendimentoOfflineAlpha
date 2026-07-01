# totem_evento

**Objetivo:** Gestão de totens de autoatendimento

**Descrição:** A tabela `totem_evento` armazena dados relacionados a gestão de totens de autoatendimento. Contém 7 colunas, com chave primária em `id_totem_evento` e relaciona-se com outras tabelas via chaves estrangeiras (id_totem -> totem(id_totem)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_totem_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_totem | BIGINT | Não | NULL | Dados do totem de autoatendimento |
| evento | ENUM('ONLINE','OFFLINE','EMITIU_SENHA','ERRO','SENHA_GERADA','SENHA_CHAMADA','SENHA_ATENDIDA','SENHA_CANCELADA','SENHA_REAUTUADA') | Não | NULL | Registro de evento ou ocorrência |
| detalhe | TEXT | Sim | NULL | Detalhes complementares do registro |
| ip_acesso | VARCHAR(45) | Sim | NULL | Campo de texto de comprimento variável |
| criado_em | DATETIME | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_totem_evento`
- **Estrangeiras:**
  - fk_te_totem: `id_totem` -> `totem` (`id_totem`)

## Índices

- idx_te_totem: `id_totem`

## Constraints

- FOREIGN KEY `fk_te_totem` em (`id_totem`) referencia `totem` (`id_totem`)
- PRIMARY KEY em (`id_totem_evento`)

## Relacionamentos e Cardinalidade

- **totem_evento -> totem:** Relacionamento 1:N via `id_totem` referenciando `totem`(`id_totem`)

## Dependências

- **Depende de:** `totem`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `totem_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia totens de autoatendimento, incluindo eventos, feedback e configuração de opções de senha, suportando fluxo de recepção.
