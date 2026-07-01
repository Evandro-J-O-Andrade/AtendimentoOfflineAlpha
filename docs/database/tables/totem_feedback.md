# totem_feedback

**Objetivo:** Gestão de totens de autoatendimento

**Descrição:** A tabela `totem_feedback` armazena dados relacionados a gestão de totens de autoatendimento. Contém 7 colunas, com chave primária em `id_feedback`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_feedback | BIGINT | Não | NULL | Feedback do usuário |
| id_senha | BIGINT | Sim | NULL | Senha ou hash de senha |
| origem | VARCHAR(50) | Sim | NULL | Campo de texto de comprimento variável |
| nota | INT | Sim | NULL | Campo numérico inteiro |
| comentario | TEXT | Sim | NULL | Campo de texto longo |
| data_hora | DATETIME | Sim | CURRENT_TIMESTAMP | Dados operacionais do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_feedback`

## Índices

- fk_totem_feedback_senhas: `id_senha`

## Constraints

- PRIMARY KEY em (`id_feedback`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `totem_feedback` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia totens de autoatendimento, incluindo eventos, feedback e configuração de opções de senha, suportando fluxo de recepção.
