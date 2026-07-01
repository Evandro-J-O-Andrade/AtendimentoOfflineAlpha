# tabela_tuss

**Objetivo:** Tabela TUSS de procedimentos e materiais

**Descrição:** A tabela `tabela_tuss` armazena dados relacionados a tabela tuss de procedimentos e materiais. Contém 5 colunas, com chave primária em `codigo_tuss`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| codigo_tuss | VARCHAR(20) | Não | NULL | Código de identificação do item |
| descricao | TEXT | Não | NULL | Descrição textual do item |
| valor_honorario | DECIMAL(10,2) | Sim | NULL | Valor numérico ou monetário |
| valor_custo_operacional | DECIMAL(10,2) | Sim | NULL | Valor numérico ou monetário |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `codigo_tuss`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- PRIMARY KEY em (`codigo_tuss`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tabela_tuss` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.
