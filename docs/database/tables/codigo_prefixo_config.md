# codigo_prefixo_config

Objetivo: Configurar prefixos de códigos para diferentes domínios e escopos.
Descrição: Tabela que define prefixos de 5 dígitos para geração automática de códigos em domínios como LAB, FARMACIA, ESTOQUE, FATURAMENTO, RH e PATRIMONIO.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prefixo | bigint | NOT NULL | - | Identificador único da configuração, chave primária auto incrementada. |
| dominio | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | NOT NULL | - | Domínio do código: LAB, FARMACIA, ESTOQUE, FATURAMENTO, RH, PATRIMONIO ou OUTRO. |
| prefixo_5 | char(5) | NOT NULL | - | Prefixo de 5 caracteres para códigos do domínio. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o prefixo aplica. |
| id_local_operacional | bigint | Nullable | - | Referência ao local operacional (opcional). |
| id_laboratorio | bigint | Nullable | - | Referência ao laboratório (opcional). |
| ativo | tinyint | NOT NULL | '1' | Indicador se o prefixo está ativo. |
| observacao | varchar(255) | Nullable | - | Observação sobre a configuração do prefixo. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação da configuração. |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp da última atualização. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Chaves
- Primária: id_prefixo
- Únicas: uk_prefixo_escopo (dominio, prefixo_5, id_unidade, id_local_operacional, id_laboratorio)
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_prefixo)
- UNIQUE KEY uk_prefixo_escopo (dominio, prefixo_5, id_unidade, id_local_operacional, id_laboratorio)
- KEY idx_prefixo_lookup (dominio, ativo, id_unidade, id_local_operacional, id_laboratorio)

## Constraints
- PRIMARY KEY: id_prefixo
- UNIQUE: uk_prefixo_escopo (dominio, prefixo_5, id_unidade, id_local_operacional, id_laboratorio)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade)
- N:1 com saas_entidade (id_entidade)
- Referenciada por codigo_universal para geração de códigos

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: unidade, saas_entidade

## Fluxo de utilização dentro do sistema
- Usada para determinar prefixo de códigos automaticamente
- Domínio + escopo (unidade/local) definem sequência de código
- Permite códigos únicos por unidade para mesmo domínio
- Configuração ativa controla quais prefixos estão em uso
- Integrada ao processo de geração de código_universal