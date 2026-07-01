# assistencia_social_evento

Objetivo: Registrar eventos ocorridos durante atendimentos de assistência social, permitindo o histórico de ações e interações.

Descrição: Esta tabela mantém o histórico de eventos relacionados aos atendimentos de assistência social, registrando o tipo de evento, detalhes, e informações de auditoria completas com sessão e usuário responsável.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento de assistência social |
| id_as | bigint | NOT NULL | - | Chave estrangeira que referencia o atendimento de assistência social, vinculada à tabela assistencia_social_atendimento |
| id_sessao_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia a sessão do usuário no momento do evento |
| tipo | varchar(50) | NOT NULL | - | Tipo do evento ocorrido (ex: ENCAMINHAMENTO, ORIENTACAO, ENTREGA, VISITA) |
| detalhe | text | YES | NULL | Detalhes completos sobre o evento ocorrido |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que registrou o evento |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_evento
- Únicas: Nenhuma
- Estrangeiras: fk_as_evento_as - id_as → assistencia_social_atendimento(id_as) - Vincula o evento ao atendimento; fk_as_evento_sessao - id_sessao_usuario → sessao_usuario(id_sessao_usuario) - Vincula o evento à sessão; fk_as_evento_usuario - id_usuario → usuario(id_usuario) - Vincula o evento ao usuário

## Índices
- idx_as_evento_as (KEY) - Índice composto por id_as e criado_em para busca por atendimento
- idx_as_evento_sessao (KEY) - Índice composto por id_sessao_usuario e criado_em
- idx_as_evento_usuario (KEY) - Índice composto por id_usuario e criado_em

## Constraints
- fk_as_evento_as - FOREIGN KEY - Restringe id_as à tabela assistencia_social_atendimento(id_as)
- fk_as_evento_sessao - FOREIGN KEY - Restringe id_sessao_usuario à tabela sessao_usuario(id_sessao_usuario)
- fk_as_evento_usuario - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com assistencia_social_atendimento - Cada evento está associado a um atendimento de assistência social
- N:1 com sessao_usuario - Cada evento tem uma sessão de usuário associada
- N:1 com usuario - Cada evento é registrado por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencia_social_evento)
- Tabelas das quais esta depende: assistencia_social_atendimento, sessao_usuario, usuario

## Fluxo de utilização dentro do sistema
- Registro de eventos durante atendimento de assistência social
- Tipos de eventos variados (encaminhamento, orientação, entrega, visita, etc.)
- Detalhes completos do evento no campo detalhe
- Auditoria completa com sessão e usuário que realizou o registro
- Índices compostos para busca eficiente por atendimento, sessão ou usuário