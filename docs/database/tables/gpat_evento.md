# gpat_evento

Objetivo: Registrar eventos dos atendimentos GPAT.

Descrição: Tabela de auditoria que armazena eventos ocorridos nos GPATs de atendimento, como alterações de status, inclusão de itens, dispensação. Mantém histórico de todas as ações no protocolo terapêutico.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gpat_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada |
| id_gpat | bigint | NOT NULL | - | Referência ao GPAT de atendimento ao qual o evento pertence |
| tipo_evento | varchar(50) | NOT NULL | - | Tipo de evento (ex: STATUS_CHANGE, ITEM_ADDED) |
| detalhes | text | DEFAULT NULL | - | Detalhes do evento |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário que realizou o evento |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que realizou o evento |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gpat_evento
- Únicas: -
- Estrangeiras: fk_gpat_evento_gpat (id_gpat → gpat_atendimento.id_gpat ON DELETE CASCADE); fk_gpat_evento_usuario (id_usuario → usuario.id_usuario)

## Índices
- idx_gpat_evento_gpat (id_gpat)
- idx_gpat_evento_tipo (tipo_evento)
- fk_gpat_evento_usuario (id_usuario)
- fk_gpat_evento_sessao (id_sessao_usuario)

## Constraints
- CONSTRAINT fk_gpat_evento_gpat FOREIGN KEY (id_gpat) REFERENCES gpat_atendimento (id_gpat) ON DELETE CASCADE
- CONSTRAINT fk_gpat_evento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- gpat_evento.id_gpat → gpat_atendimento (id_gpat): N:1 (vários eventos podem referenciar o mesmo GPAT)
- gpat_evento.id_usuario → usuario (id_usuario): N:1 (vários eventos podem ser feitos pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: gpat_atendimento, usuario

## Fluxo de utilização dentro do sistema
1. A cada ação no GPAT, um evento é registrado
2. tipo_evento classifica a ação realizada
3. detalhes fornecem contexto da mudança
4. Histórico é mantido para auditoria completa
5. ON DELETE CASCADE remove eventos se GPAT for excluído