# assistencia_social_atendimento

Objetivo: Registrar atendimentos de assistência social ao paciente, controlando status, motivo e relato da necessidade assistencial.

Descrição: Esta tabela armazena os atendimentos realizados pela equipe de assistência social, permitindo o registro do motivo do atendimento, relato da situação, status atual do atendimento e identificação do usuário responsável.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_as | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do atendimento de assistência social |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde o atendimento foi realizado |
| id_senha | bigint | YES | NULL | Identificador da senha de atendimento, quando aplicável |
| id_ffa | bigint | YES | NULL | Chave estrangeira que referencia a FFA (Ficha de Atendimento) associada ao atendimento social |
| status | enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | NOT NULL | 'ABERTO' | Status do atendimento social: aberto, em atendimento, finalizado ou cancelado |
| motivo | varchar(255) | YES | NULL | Motivo que levou ao atendimento de assistência social |
| relato | text | YES | NULL | Relato completo da situação do paciente ou da família |
| id_usuario_abertura | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que abriu o atendimento |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do atendimento |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp automático de atualização do atendimento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_as
- Únicas: Nenhuma
- Estrangeiras: fk_as_user - id_usuario_abertura → usuario(id_usuario) - Vincula o atendimento ao usuário que abriu

## Índices
- fk_as_unidade (KEY) - Índice para busca por unidade
- fk_as_user (KEY) - Índice para busca por usuário

## Constraints
- fk_as_user - FOREIGN KEY - Restringe id_usuario_abertura à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada atendimento social está associado a uma unidade
- N:1 com usuario - Cada atendimento social é aberto por um usuário
- N:1 com ffa - Cada atendimento pode estar vinculado a uma FFA (opcional)
- N:1 com senha - Cada atendimento pode ter uma senha associada (opcional)

## Dependências
- Tabelas que dependem desta: assistencia_social_evento (via id_as)
- Tabelas das quais esta depende: usuario

## Fluxo de utilização dentro do sistema
- Registro de atendimentos de assistência social ao paciente
- Controle de status para acompanhamento do andamento do atendimento
- Campo motivo e relato para documentação da necessidade assistencial
- Vinculação à unidade e usuário para contexto organizacional
- Eventos de auditoria via assistencia_social_evento
- Timestamp automático para controle de tempo de atendimento