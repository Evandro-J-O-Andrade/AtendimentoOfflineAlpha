# prescricao_itens

Objetivo: Gerenciar itens de prescrição médica de forma simplificada, suportando diferentes tipos como medicamentos, dietas, cuidados e oxigenoterapia.

Descrição: Tabela que representa itens de prescrição médica com tipos específicos como medicamentos, dietas, cuidados de enfermagem, oxigenoterapia e soluções EV. Permite controle de status (ativo, suspenso, concluído), frequência horária e observações de enfermagem.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Chave primária da tabela, identificador único do item da prescrição |
| id_atendimento | bigint | NOT NULL | - | Referência ao id do atendimento ao qual o item está vinculado |
| id_usuario_prescritor | bigint | NOT NULL | - | Referência ao id do usuário que criou a prescrição |
| tipo_item | enum('MEDICAMENTO','DIETA','CUIDADO','OXIGENOTERAPIA','SOLUCAO_EV') | YES | NULL | Tipo do item prescrito: MEDICAMENTO, DIETA, CUIDADO, OXIGENOTERAPIA ou SOLUCAO_EV |
| descricao | varchar(255) | NOT NULL | - | Descrição do item prescrito |
| posologia_detalhada | text | YES | NULL | Posologia detalhada com instruções completas |
| frequencia_horario | varchar(100) | YES | NULL | Frequência e horários de aplicação do medicamento |
| via_administracao | varchar(50) | YES | NULL | Via de administração do medicamento |
| observacao_enfermagem | text | YES | NULL | Observações específicas para a enfermagem |
| data_inicio | datetime | - | CURRENT_TIMESTAMP | Data e hora de início da prescrição |
| data_suspensao | datetime | YES | NULL | Data e hora de suspensão da prescrição, se aplicável |
| status | enum('ATIVO','SUSPENSO','CONCLUIDO') | - | 'ATIVO' | Status do item: ATIVO, SUSPENSO ou CONCLUIDO |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o item foi prescrito |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)
- KEY idx_presc_tipo (id_atendimento, tipo_item)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter vários itens de prescrição)
- N:1 com usuario (um usuário prescritor pode criar vários itens)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, usuario

## Fluxo de utilização dentro do sistema
- Usado para registrar prescrições simples durante atendimentos
- Permite suspender e reativar itens conforme necessidade clínica
- Diferente de prescricao_continua, é usado para prescrições específicas e pontuais
- Integrado com o fluxo de enfermagem para aplicação dos medicamentos