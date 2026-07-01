# cliente

Objetivo: Armazenar informações de clientes do sistema (pacientes ou entidades terceiras).
Descrição: Tabela que mantém cadastro de clientes com documento, contato e status ativo, usada para identificação em atendimentos e operações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cliente | bigint | NOT NULL | - | Identificador único do cliente, chave primária auto incrementada. |
| nome | varchar(255) | NOT NULL | - | Nome completo ou razão social do cliente. |
| documento | varchar(30) | Nullable | - | Documento de identificação (CPF ou CNPJ). |
| telefone | varchar(30) | Nullable | - | Telefone principal do cliente. |
| email | varchar(150) | Nullable | - | Email de contato do cliente. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o cliente está ativo no sistema. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do registro. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o cliente pertence. |

## Chaves
- Primária: id_cliente
- Únicas: uk_cliente_doc (documento)
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_cliente)
- UNIQUE KEY uk_cliente_doc (documento)
- KEY idx_cliente_nome (nome)

## Constraints
- PRIMARY KEY: id_cliente
- UNIQUE: uk_cliente_doc (documento)

## Relacionamentos e Cardinalidade
- 1:N com saas_entidade (id_entidade) - muitos clientes podem pertencer a uma entidade
- 1:N com codigo_universal (id_cliente) - muitos códigos podem referenciar cliente

## Dependências
- Tabelas que dependem desta: codigo_universal
- Dependência desta tabela: saas_entidade

## Fluxo de utilização dentro do sistema
- Cadastrado para identificação de pacientes ou terceiros
- Documento único impede duplicidade de CPF/CNPJ
- Usado para geração de códigos internos via codigo_universal
- Integração com sistema de faturamento para cobranças
- Cliente inativo não aparece em novas seleções