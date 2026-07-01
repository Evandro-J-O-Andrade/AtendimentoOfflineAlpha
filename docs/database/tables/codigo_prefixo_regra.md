# codigo_prefixo_regra

Objetivo: Definir regras de prefixos de códigos por tipo e unidade.
Descrição: Tabela que estabelece regras para prefixos de códigos, vinculando tipos (GPAT, LAB, FARM_PRODUTO, etc.) a prefixos específicos de unidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_regra | bigint | NOT NULL | - | Identificador único da regra, chave primária auto incrementada. |
| tipo | varchar(30) | NOT NULL | - | Tipo de código (ex: GPAT, LAB, FARM_PRODUTO, PDV). |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde a regra aplica. |
| id_local_operacional | bigint | Nullable | - | Referência ao local operacional (opcional). |
| prefixo5 | char(5) | NOT NULL | - | Prefixo de 5 dígitos para códigos do tipo. |
| ativo | tinyint(1) | NOT NULL | '1' | Indicador se a regra está ativa. |
| observacao | varchar(255) | Nullable | - | Observação sobre a regra. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação da regra. |
| atualizado_em | datetime | Nullable | - | Timestamp da última atualização. |
| id_entidade | bigint unsigned | Nullable | - | Referência à entidade (opcional). |

## Índices
- PRIMARY KEY (id_regra)
- UNIQUE KEY uk_prefixo_tipo_ctx (tipo, id_unidade, id_local_operacional)
- KEY ix_prefixo_tipo (tipo)
- KEY ix_prefixo_prefixo (prefixo5)
- KEY fk_codigo_prefixo_regra_unidade (id_unidade)

## Constraints
- PRIMARY KEY: id_regra
- UNIQUE: uk_prefixo_tipo_ctx (tipo, id_unidade, id_local_operacional)
- FOREIGN KEY: fk_codigo_prefixo_regra_unidade (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade)
- N:1 com saas_entidade (id_entidade) - opcional

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: unidade, saas_entidade (opcional)

## Fluxo de utilização dentro do sistema
- Define prefixo por tipo de código e escopo
- Tipos incluem: GPAT (atendimento), LAB, produtos farmacêcnicos, PDV
- Usada para geração automática de códigos pelo sistema
- Regras duplicadas dentro do mesmo contexto são impedidas