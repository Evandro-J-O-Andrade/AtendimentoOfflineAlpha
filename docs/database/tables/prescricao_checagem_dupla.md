# prescricao_checagem_dupla

Objetivo: Registrar a checagem dupla de segurança em prescrições médicas, associando um testemunha ao ato de verificação.

Descrição: Esta tabela implementa o mecanismo de dupla checagem (double-check) para prescrições, uma prática de segurança do paciente onde um segundo profissional atua como testemunha da verificação da prescrição. Permite rastrear quem realizou a verificação dupla, quando ocorreu, e em qual entidade ocorreu o evento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_dupla_checagem | bigint | NOT NULL | - | Chave primária da tabela, identificador único do registro de checagem dupla |
| id_checagem_principal | bigint | NOT NULL | - | Referência ao id da checagem principal na tabela prescricao_checagem |
| id_usuario_testemunha | bigint | NOT NULL | - | Referência ao id do usuário que atuou como testemunha na checagem dupla |
| data_hora | datetime | - | CURRENT_TIMESTAMP | Data e hora do registro da checagem dupla |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde ocorreu a checagem |

## Chaves
- Primária: id_dupla_checagem
- Únicas: -
- Estrangeiras: fk_dupla_principal (id_checagem_principal → prescricao_checagem.id_checagem) - vincula a checagem dupla à checagem principal original; fk_dupla_testemunha (id_usuario_testemunha → usuario.id_usuario) - identifica o usuário testemunha que realizou a verificação dupla

## Índices
- PRIMARY KEY (id_dupla_checagem)
- KEY fk_dupla_principal (id_checagem_principal)
- KEY fk_dupla_testemunha (id_usuario_testemunha)

## Constraints
- CONSTRAINT fk_dupla_principal FOREIGN KEY (id_checagem_principal) REFERENCES prescricao_checagem (id_checagem)
- CONSTRAINT fk_dupla_testemunha FOREIGN KEY (id_usuario_testemunha) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com prescricao_checagem (uma checagem principal pode ter zero ou uma checagem dupla associada)
- N:1 com usuario (um usuário testemunha pode participar de várias checagens duplas)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: prescricao_checagem, usuario

## Fluxo de utilização dentro do sistema
- Registrado após a verificação de uma prescrição médica
- Vinculado ao evento de checagem principal (prescricao_checagem)
- Associado ao usuário testemunha que realizou a verificação dupla
- Utilizado para auditoria e compliance de segurança do paciente