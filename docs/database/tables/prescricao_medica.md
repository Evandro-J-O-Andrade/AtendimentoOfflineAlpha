# prescricao_medica

Objetivo: Registrar prescrições médicas individuais com medicamentos, doses, vias e frequências, vinculadas a atendimentos e médicos.

Descrição: Tabela que representa prescrições médicas simples vinculadas a atendimentos, com gerenciamento de status (ativa, suspensa, concluída) e controle completo de informações do medicamento prescrito.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Chave primária da tabela, identificador único da prescrição médica |
| id_atendimento | bigint | NOT NULL | - | Referência ao id do atendimento ao qual a prescrição está vinculada |
| id_usuario_medico | bigint | NOT NULL | - | Referência ao id do usuário médico que criou a prescrição |
| item_nome | varchar(255) | NOT NULL | - | Nome do medicamento ou item prescrito |
| dose | varchar(50) | YES | NULL | Dose do medicamento prescrita |
| via | enum('EV','IM','VO','SC','TOPICA','INALATORIA') | YES | NULL | Via de administração: EV (endovenosa), IM (intramuscular), VO (oral), SC (subcutânea), TOPICA (tópica), INALATORIA (inalatória) |
| frequencia | varchar(50) | YES | NULL | Frequência de aplicação do medicamento |
| status | enum('ATIVA','SUSPENSA','CONCLUIDA') | - | 'ATIVA' | Status da prescrição: ATIVA, SUSPENSA ou CONCLUIDA |
| data_prescricao | datetime | - | CURRENT_TIMESTAMP | Data e hora de criação da prescrição |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a prescrição foi criada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter várias prescrições médicas)
- N:1 com usuario (um médico pode criar várias prescrições)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, usuario

## Fluxo de utilização dentro do sistema
- Usada para prescrições médicas individuais durante atendimentos
- Permite controle de status para acompanhar tramitação
- Integra-se com o fluxo de dispensação farmacêutica
- Registra todas as informações necessárias para aplicação do medicamento