# paciente_cns_evento

Objetivo: Registrar eventos relacionados às alterações no CNS do paciente (auditoria).
Descrição: Tabela de auditoria que registra todas as mudanças e eventos relacionados ao CNS do paciente, como validação, atualização, erro de validação ou exclusão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento (chave primária, auto incremento) |
| id_paciente_cns | bigint | NOT NULL | - | ID do registro de CNS ao qual o evento está vinculado |
| id_sessao_usuario | bigint | NOT NULL | - | ID da sessão do usuário que realizou a ação |
| evento | varchar(40) | NOT NULL | - | Tipo do evento: VALIDACAO, ALTERACAO, ERRO, EXCLUSAO, etc. |
| detalhe | varchar(255) | YES | NULL | Detalhes adicionais sobre o evento |
| payload_json | json | YES | NULL | Payload adicional em formato JSON |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do evento |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o evento pertence |

## Chaves
- Primária: id_evento
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id_evento)
- KEY ix_pcns_evt (id_paciente_cns)
- KEY ix_pcns_evt_tipo (evento)

## Constraints
- PRIMARY KEY: id_evento

## Relacionamentos e Cardinalidade
- N:1 com paciente_cns: Muitos eventos pertencem a um registro de CNS
- N:1 com sessao_usuario: Muitos eventos são criados por uma sessão de usuário

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para auditar todas as alterações no registro de CNS do paciente. Cada vez que um CNS é validado, alterado ou removeido, um evento é registrado aqui com o usuário responsável. Permite rastrear a história de mudanças e identificar problemas de validação.