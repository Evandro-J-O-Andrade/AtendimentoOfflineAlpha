# prontuario_evolucao

Objetivo: Registrar evoluções clínicas no prontuário do paciente durante atendimento, com controle de status e histórico de alterações.

Descrição: Tabela que armazena as evoluções clínicas registradas durante atendimentos, permitindo textos longos, controle de status (ativo, revisado, cancelado) e rastreamento de alterações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evolucao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da evolução |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento ao qual a evolução está vinculada |
| id_usuario | bigint | NOT NULL | - | Referência ao id do usuário que registrou a evolução |
| texto_evolucao | longtext | NOT NULL | - | Texto completo da evolução clínica do paciente |
| status | enum('ATIVO','REVISADO','CANCELADO') | - | 'ATIVO' | Status da evolução: ATIVO, REVISADO ou CANCELADO |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação do registro da evolução |
| alterado_em | datetime | - | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última alteração do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a evolução foi registrada |

## Chaves
- Primária: id_evolucao
- Únicas: -
- Estrangeiras: fk_evolucao_atendimento (id_atendimento → atendimento.id_atendimento) - vincula a evolução ao atendimento; fk_evolucao_usuario (id_usuario → usuario.id_usuario) - identifica o usuário que registrou a evolução

## Índices
- PRIMARY KEY (id_evolucao)
- KEY fk_evolucao_atendimento (id_atendimento)
- KEY fk_evolucao_usuario (id_usuario)

## Constraints
- CONSTRAINT fk_evolucao_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter várias evoluções)
- N:1 com usuario (um usuário pode registrar várias evoluções)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, usuario

## Fluxo de utilização dentro do sistema
- Registrado durante a atualização da evolução do paciente
- Permite revisão e cancelamento de evoluções
- Texto longo permite descrição completa do estado do paciente
- Atualização automática do campo alterado_em