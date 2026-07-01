# remocao

Objetivo: Gerenciar remoções de pacientes entre unidades ou locais, com controle de status, veículos e condutores.

Descrição: Tabela que controla o processo de remoção de pacientes entre unidades ou para outros locais, permitindo acompanhamento do status (solicitada, autorizada, em trânsito, concluída, cancelada) e gestão de recursos como viaturas e condutores.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_remocao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da remoção |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade solicitante da remoção |
| id_senha | bigint | YES | NULL | Referência ao id da senha de atendimento associada |
| id_ffa | bigint | YES | NULL | Referência ao id da ficha de atendimento assistido |
| origem | varchar(150) | YES | NULL | Local de origem da remoção |
| destino | varchar(150) | YES | NULL | Local de destino da remoção |
| motivo | varchar(255) | YES | NULL | Motivo da remoção do paciente |
| status | enum('SOLICITADA','AUTORIZADA','EM_TRANSITO','CONCLUIDA','CANCELADA') | NOT NULL | 'SOLICITADA' | Status da remoção: SOLICITADA, AUTORIZADA, EM_TRANSITO, CONCLUIDA ou CANCELADA |
| id_viatura | bigint | YES | NULL | Referência ao id da viatura utilizada na remoção |
| condutor_interno | varchar(150) | YES | NULL | Nome do condutor interno da viatura |
| condutor_externo | varchar(150) | YES | NULL | Nome do condutor externo (terceirizado) |
| protocolo_cross | varchar(50) | YES | NULL | Número do protocolo de integração externa |
| id_usuario_solicitante | bigint | NOT NULL | - | Referência ao id do usuário que solicitou a remoção |
| criado_em | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação do registro da remoção |
| atualizado_em | datetime | - | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a remoção foi solicitada |

## Chaves
- Primária: id_remocao
- Únicas: -
- Estrangeiras: fk_rem_user (id_usuario_solicitante → usuario.id_usuario) - identifica o usuário solicitante; fk_rem_viatura (id_viatura → viatura.id_viatura) - vincula a remoção à viatura; fk_remocao_unidade (id_unidade → unidade.id_unidade) - vincula a remoção à unidade

## Índices
- PRIMARY KEY (id_remocao)
- KEY idx_rem_status (status)
- KEY fk_rem_unidade (id_unidade)
- KEY fk_rem_viatura (id_viatura)
- KEY fk_rem_user (id_usuario_solicitante)

## Constraints
- CONSTRAINT fk_rem_user FOREIGN KEY (id_usuario_solicitante) REFERENCES usuario (id_usuario)
- CONSTRAINT fk_rem_viatura FOREIGN KEY (id_viatura) REFERENCES viatura (id_viatura)
- CONSTRAINT fk_remocao_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (uma unidade pode solicitar várias remoções)
- N:1 com usuario (um usuário pode solicitar várias remoções)
- N:1 com viatura (uma viatura pode ser usada em várias remoções)

## Dependências
- Tabelas que dependem desta: remocao_evento, remocao_logistica
| Esta tabela depende de: usuario, viatura, unidade

## Fluxo de utilização dentro do sistema
- Criado quando uma remoção de paciente é solicitada
- Acompanhamento do status até conclusão
- Vinculado a viatura e condutor para logística
- Eventos são registrados em remocao_evento