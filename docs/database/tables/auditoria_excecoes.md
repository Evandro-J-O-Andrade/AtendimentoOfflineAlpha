# auditoria_excecoes

Objetivo: Registrar exceções negadas ou tratadas no sistema para análise de negócios.
Descrição: Tabela que registra casos de exceções no fluxo de atendimento, como negativas de autorização ou situações não previstas, com motivo e responsável pelo registro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da exceção, chave primária auto incrementada. |
| id_ffa | bigint | NOT NULL | - | Referência à FFA (Ficha de Atendimento) onde a exceção ocorreu. |
| id_paciente | bigint | NOT NULL | - | Referência ao paciente associado à exceção. |
| motivo | varchar(255) | NOT NULL | - | Descrição do motivo da exceção registrada. |
| chamado_por | varchar(200) | Nullable | - | Identificação de quem solicitou/registrou a exceção. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da criação do registro de exceção. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com FFA (id_ffa) - inferido
- N:1 com paciente (id_paciente) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: FFA, paciente, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Registrada quando ocorre uma exceção no fluxo assistencial
- Usada para controle de casos especiais ou negativas de autorização
- Permite acompanhamento e análise de exceções
- Base para relatórios de compliance e gestão de riscos