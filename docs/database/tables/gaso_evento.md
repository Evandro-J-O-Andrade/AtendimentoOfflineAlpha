# gaso_evento

Objetivo: Registrar eventos das solicitações de gasoterapia.

Descrição: Tabela de auditoria que armazena os eventos ocorridos nas solicitações de gasoterapia (gases medicinais), como abertura, atualização, entrega, mantendo histórico das ações realizadas pelos usuários no processo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gaso_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada |
| id_gaso | bigint | NOT NULL | - | Referência à solicitação de gasoterapia |
| evento | varchar(80) | NOT NULL | - | Tipo de evento ocorrido (ex: ABERTURA, ATUALIZACAO, ENTREGA) |
| detalhe | text | DEFAULT NULL | - | Detalhes complementares sobre o evento |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário que realizou o evento |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que realizou o evento |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gaso_evento
- Únicas: -
- Estrangeiras: fk_ge_gaso (id_gaso → gaso_solicitacao.id_gaso); fk_ge_user (id_usuario → usuario.id_usuario)

## Índices
- idx_ge_gaso (id_gaso)
- fk_ge_user (id_usuario)
- idx_ge_sessao (id_sessao_usuario)

## Constraints
- CONSTRAINT fk_ge_gaso FOREIGN KEY (id_gaso) REFERENCES gaso_solicitacao (id_gaso)
- CONSTRAINT fk_ge_user FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- gaso_evento.id_gaso → gaso_solicitacao (id_gaso): N:1 (vários eventos podem referenciar a mesma solicitação)
- gaso_evento.id_usuario → usuario (id_usuario): N:1 (vários eventos podem ser realizados pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: gaso_solicitacao, usuario

## Fluxo de utilização dentro do sistema
1. Solicitação de gasoterapia é criada em gaso_solicitacao
2. Eventos são registrados ao longo do processo (ABERTURA, ATUALIZACAO, ENTREGA)
3. id_usuario e id_sessao_usuario rastreiam quem realizou cada ação
4. Detalhes fornecem contexto sobre a mudança
5. Histórico é mantido para auditoria completa