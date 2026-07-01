# fila_senha

Objetivo: Gerenciar as senhas de atendimento do sistema.

Descrição: Tabela central que representa as senhas de atendimento no sistema. Cada senha identifica um paciente esperando atendimento e possui status de andamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da senha, chave primária auto incrementada |
| id_senha | bigint | NOT NULL | - | Identificador da senha (possivelmente uma sequência ou código externo) |
| status | varchar(50) | DEFAULT | 'AGUARDANDO' | Status atual da senha: aguardando, em atendimento, etc |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação da senha |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: uk_fila_senha_id_senha (id_senha) - índice único garantindo senhas únicas
- Estrangeiras: -

## Índices
- idx_fs_senha (id_senha)

## Constraints
- UNIQUE KEY uk_fila_senha_id_senha (id_senha)

## Relacionamentos e Cardinalidade
- fila_senha.id_senha → [tabela de senhas]: N:1 ou 1:1 dependendo da implementação

## Dependências
- Tabelas que dependem desta: fila_evento, fila_retorno
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Paciente chega e senha é gerada (id_senha)
2. Registro criado com status 'AGUARDANDO'
3. Quando chamado: evento registrado em fila_evento
4. Para retorno: registro criado em fila_retorno
5. Senha única garantida pelo índice uk_fila_senha_id_senha