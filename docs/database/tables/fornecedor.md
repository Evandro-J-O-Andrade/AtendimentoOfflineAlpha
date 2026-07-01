# fornecedor

Objetivo: Gerenciar os fornecedores do sistema.

Descrição: Tabela que armazena os fornecedores de produtos e serviços para o hospital/sistema, mantendo razão social, nome fantasia, CNPJ e informações de contato. Utilizada no gerenciamento de compras e estoque.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fornecedor | bigint | NOT NULL | - | Identificador único do fornecedor, chave primária auto incrementada |
| razao_social | varchar(255) | NOT NULL | - | Razão social completa do fornecedor |
| nome_fantasia | varchar(255) | DEFAULT NULL | - | Nome comercial/fantasia do fornecedor |
| cnpj | varchar(20) | DEFAULT NULL | - | CNPJ do fornecedor para identificação fiscal |
| contato | varchar(255) | DEFAULT NULL | - | Informações de contato do fornecedor (telefone, email, etc) |
| ativo | tinyint | DEFAULT | '1' | Indicador se o fornecedor está ativo (1=ativo, 0=inativo) |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do cadastro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_fornecedor
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- fornecedor é referenciado por tabelas de entrada de estoque, pedidos e compras

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Fornecedor é cadastrado com razão social obrigatória
2. nome_fantasia é opcional para identificação comercial
3. CNPJ pode ser armazenado para validação fiscal
4. contato guarda telefone, email ou pessoa de contato
5. Campo ativo permite inativação sem exclusão
6. id_entidade vincula o fornecedor à organização