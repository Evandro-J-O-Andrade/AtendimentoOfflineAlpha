# codigo_externo_vinculo

Objetivo: Vincular códigos universais a identificadores externos com rastreio de criação.
Descrição: Tabela que mantém vínculos entre códigos universais e códigos de sistemas externos com controle de quem e quando criou o vínculo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_vinculo | bigint | NOT NULL | - | Identificador único do vínculo, chave primária auto incrementada. |
| tipo | varchar(30) | NOT NULL | - | Tipo de vínculo (ex: PACIENTE, PRODUTO, FUNCIONARIO). |
| sistema_externo | varchar(50) | NOT NULL | - | Nome do sistema externo de origem. |
| codigo_externo | varchar(80) | NOT NULL | - | Código no sistema externo. |
| id_codigo_universal | bigint | NOT NULL | - | Referência ao código universal interno. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão que realizou o vínculo. |
| observacao | varchar(255) | Nullable | - | Observação sobre o vínculo realizado. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do vínculo. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o vínculo pertence. |

## Chaves
- Primária: id_vinculo
- Únicas: uk_vinculo (tipo, sistema_externo, codigo_externo)
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_vinculo)
- UNIQUE KEY uk_vinculo (tipo, sistema_externo, codigo_externo)
- KEY ix_vinculo_codigo (id_codigo_universal)

## Constraints
- PRIMARY KEY: id_vinculo
- UNIQUE: uk_vinculo (tipo, sistema_externo, codigo_externo)

## Relacionamentos e Cardinalidade
- N:1 com codigo_universal (id_codigo_universal) - inferido
- N:1 com sessao_usuario (id_sessao_usuario) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: codigo_universal, sessao_usuario, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Criada quando há vínculo manual entre sistemas
- Tipo identifica categoria do código externo
- Constraint única impede vínculos duplicados
- Integrada a processos de migração e integração de dados
- Permite rastrear origem de dados externos