# cat_regra_item

Objetivo: Definir regras e códigos SIGTAP para notificações de acidente de trabalho.
Descrição: Tabela que mantém itens de regras para CAT, incluindo códigos SIGTAP e descrições para padronização de notificações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cat_regra | bigint | NOT NULL | - | Identificador único da regra, chave primária auto incrementada. |
| codigo_sigtap | varchar(30) | Nullable | - | Código SIGTAP relacionado à regra. |
| descricao | varchar(255) | Nullable | - | Descrição da regra ou item de notificação. |
| ativo | tinyint(1) | NOT NULL | '1' | Indicador se a regra está ativa. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação da regra. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a regra pertence. |

## Chaves
- Primária: id_cat_regra
- Únicas: uk_cat_regra_sigtap (codigo_sigtap)
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_cat_regra)
- UNIQUE KEY uk_cat_regra_sigtap (codigo_sigtap)

## Constraints
- PRIMARY KEY: id_cat_regra
- UNIQUE: uk_cat_regra_sigtap (codigo_sigtap)

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: saas_entidade

## Fluxo de utilização dentro do sistema
- Usada para definir códigos padrão para categorias de CAT
- Permite padronização de notificações por tipo de acidente
- Código SIGTAP integrado ao sistema de faturamento SUS
- Regra ativa controla disponibilidade para novas notificações