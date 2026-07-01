# alerta

Objetivo: Registrar alertas clínicos, operacionais e administrativos gerados no sistema, com controle de status, severidade e origem.

Descrição: Esta tabela centraliza os alertas do sistema, permitindo a identificação de situações críticas ou informativas relacionadas a FFAs, pacientes, unidades e locais operacionais, com mecanismo de rastreamento de origens e status de resolução.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_alerta | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do alerta |
| codigo | varchar(60) | NOT NULL | - | Código identificador do tipo de alerta para categorização |
| titulo | varchar(160) | NOT NULL | - | Título curto do alerta para identificação rápida |
| mensagem | text | YES | NULL | Texto completo da mensagem do alerta com detalhes da situação |
| gpat | varchar(30) | YES | NULL | Código GPAT (Grupo de Programação de Atividades e Tarefas) associado ao alerta |
| id_ffa | bigint | YES | NULL | Chave estrangeira que referencia a FFA (Ficha de Atendimento) associada ao alerta |
| id_paciente | bigint | YES | NULL | Chave estrangeira que referencia o paciente associado ao alerta |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde o alerta foi gerado |
| id_local_operacional | bigint | YES | NULL | Chave estrangeira que referencia o local operacional onde o alerta ocorreu |
| severidade | enum('INFO','ATENCAO','ALTA') | NOT NULL | 'ATENCAO' | Nível de severidade do alerta: informativo, atenção ou alta prioridade |
| status | enum('ABERTO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') | NOT NULL | 'ABERTO' | Status atual do alerta: aberto, lido, em atendimento, resolvido ou cancelado |
| entidade_origem | varchar(30) | YES | NULL | Nome da entidade/tabela que originou o alerta |
| id_origem | bigint | YES | NULL | Identificador do registro que originou o alerta |
| id_sessao_usuario_origem | bigint | YES | NULL | Identificador da sessão do usuário que gerou o alerta |
| id_usuario_origem | bigint | YES | NULL | Identificador do usuário que gerou o alerta |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do alerta |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp automático de atualização do alerta |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o alerta pertence |

## Chaves
- Primária: id_alerta
- Únicas: Nenhuma
- Estrangeiras: fk_alerta_paciente - id_paciente → paciente(id) - Vincula o alerta ao paciente; fk_alerta_usuario - id_usuario_origem → usuario(id_usuario) - Vincula o alerta ao usuário que originou |

## Índices
- idx_alerta_codigo_status (KEY) - Índice composto por codigo e status para busca por tipo e estado
- idx_alerta_unidade_local (KEY) - Índice composto por id_unidade, id_local_operacional e status
- idx_alerta_gpat (KEY) - Índice para busca por código GPAT
- idx_alerta_paciente (KEY) - Índice para busca por paciente
- idx_alerta_ffa (KEY) - Índice para busca por FFA
- fk_alerta_sessao (KEY) - Índice para busca por sessão
- fk_alerta_usuario (KEY) - Índice para busca por usuário

## Constraints
- fk_alerta_paciente - FOREIGN KEY - Restringe id_paciente à tabela paciente(id)
- fk_alerta_usuario - FOREIGN KEY - Restringe id_usuario_origem à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com paciente - Cada alerta pode estar associado a um paciente (opcional)
- N:1 com usuario - Cada alerta pode ter um usuário origem (opcional)
- N:1 com unidade - Cada alerta tem uma unidade associada
- N:1 com local_operacional - Cada alerta pode ter um local específico (opcional)

## Dependências
- Tabelas que dependem desta: alerta_consumo, alerta_destinatario (ambas via id_alerta)
- Tabelas das quais esta depende: paciente, usuario

## Fluxo de utilização dentro do sistema
- Geração automática de alertas clínicos, operacionais e administrativos
- Classificação por severidade (INFO, ATENCAO, ALTA) para priorização
- Rastreamento de status desde criação até resolução
- Vinculação opcional a FFA, paciente e unidade para contexto clínico
- Auditoria de origem com usuário, sessão e timestamp
- Índices otimizados para busca por código, status, unidade e paciente
- Destinação de alertas via tabela alerta_destinatario para notificação