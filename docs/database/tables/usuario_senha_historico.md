# usuario_senha_historico

Objetivo: Registrar todo o histórico de alterações e eventos relacionados a senhas de usuários para auditoria e conformidade.
Descrição: Tabela de auditoria que armazena eventos de mudança, criação e reset de senhas de usuários, contendo motivo do evento, detalhes, identificação da sessão e do usuário executor. Permite rastrear todas as alterações de senha ocorridas no sistema para fins de segurança, compliance e investigação de incidentes.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_usuario_senha_hist | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o evento de histórico de senha |
| id_usuario | bigint | NO | NULL | Identificador do usuário cuja senha foi alterada |
| hash_formato | varchar(255) | NO | NULL | Hash do formato da senha (provavelmente armazenado para referência de formato, não a senha em si) |
| motivo | enum('CRIACAO','TROCA','RESET_TI','RESET_ADMIN','MIGRACAO') | NO | NULL | Motivo que gerou o evento de senha: criação, troca voluntária, reset por TI, reset por administrador ou migração |
| detalhe | varchar(4000) | YES | NULL | Descrição detalhada do evento de senha |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora em que o evento de senha ocorreu |
| id_sessao_usuario | bigint | YES | NULL | Identificador da sessão de usuário na qual a alteração foi realizada |
| id_usuario_executor | bigint | YES | NULL | Identificador do usuário (administrador ou TI) que executou a alteração ou reset |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este evento pertence |

## Chaves
- Primária: id_usuario_senha_hist
- Únicas: Nenhuma
- Estrangeiras: fk_ush_executor (id_usuario_executor -> usuario.id_usuario), fk_ush_usuario (id_usuario -> usuario.id_usuario)

## Índices
- idx_ush_usuario_data (id_usuario, criado_em)
- idx_ush_motivo (motivo, criado_em)
- fk_ush_sessao (id_sessao_usuario)
- fk_ush_executor (id_usuario_executor)

## Constraints
- fk_ush_executor: FOREIGN KEY (id_usuario_executor) REFERENCES usuario (id_usuario)
- fk_ush_usuario: FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos eventos históricos pertencem a um usuário)
- N:1 com usuario como executor (muitos eventos foram executados por um usuário administrador)

## Dependências
- Depende de: usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Toda vez que uma senha é criada, trocada ou resetada, um registro é inserido nesta tabela
- Usado para auditoria de segurança para rastrear quem alterou senhas de usuários
- O campo motivo classifica o tipo de evento (autoatendimento, reset administrativo, migração)
- Consultado em relatórios de conformidade e investigações de segurança
- Permite identificar padrões suspeitos de alteração de senhas
