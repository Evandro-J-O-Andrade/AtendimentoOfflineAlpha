# runtime_contexto

Objetivo: Armazenar contextos de sessão runtime com informações de unidade, local, paciente e ficha assistida.

Descrição: Tabela que mantém o contexto de sessão do runtime, permitindo acompanhamento de sessões ativas com informações de unidade, local operacional, paciente e ficha assistida.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_runtime_contexto | bigint | NOT NULL | - | Chave primária da tabela, identificador único do contexto runtime |
| id_sessao_usuario | bigint | NOT NULL | - | Referência ao id da sessão do usuário ativa |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade do contexto |
| id_local_operacional | bigint | YES | NULL | Referência ao id do local operacional do contexto |
| id_paciente | bigint | YES | NULL | Referência ao id do paciente do contexto |
| id_ffa | bigint | YES | NULL | Referência ao id da ficha assistida do contexto |
| contexto_clinico | varchar(60) | YES | NULL | Contexto clínico da sessão (ex: TRIAGEM, CONSULTA) |
| estado_fluxo | varchar(60) | YES | NULL | Estado atual do fluxo na sessão |
| iniciado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de início do contexto de sessão |
| finalizado_em | datetime(6) | YES | NULL | Data e hora de finalização do contexto |
| ativo | tinyint(1) | - | '1' | Flag indicando se o contexto está ativo (1) ou finalizado (0) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o contexto ocorre |

## Chaves
- Primária: id_runtime_contexto
- Únicas: -
- Estrangeiras: fk_runtime_contexto_unidade (id_unidade → unidade.id_unidade) - vincula ao contexto de unidade; fk_runtime_sessao (id_sessao_usuario → sessao_usuario.id_sessao_usuario) - vincula à sessão |

## Índices
- PRIMARY KEY (id_runtime_contexto)
- KEY idx_runtime_sessao (id_sessao_usuario)
- KEY fk_runtime_contexto_unidade (id_unidade)

## Constraints
- CONSTRAINT fk_runtime_contexto_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- CONSTRAINT fk_runtime_sessao FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- N:1 com sessao_usuario (uma sessão pode ter um contexto)
- N:1 com unidade (uma unidade pode ter vários contextos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: sessao_usuario, unidade

## Fluxo de utilização dentro do sistema
- Criado quando uma sessão runtime é iniciada
- Permite rastrear contexto clínico e estado do fluxo
- Finalizado quando a sessão é encerrada
- Usado para recuperação de contexto em caso de interrupção