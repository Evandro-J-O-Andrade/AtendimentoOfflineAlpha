# chamado_evento

Objetivo: Registrar eventos e histórico de mudanças em chamados do sistema.
Descrição: Tabela que audita todas as alterações e interações em chamados, mantendo histórico de status, atribuições e observações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_chamado_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada. |
| id_chamado | bigint | NOT NULL | - | Referência ao chamado ao qual o evento está vinculado. |
| evento | varchar(80) | NOT NULL | - | Tipo de evento ocorrido (ex: STATUS_MUDANCA, ATRIBUICAO, COMENTARIO). |
| detalhe | text | Nullable | - | Detalhes adicionais sobre o evento. |
| id_usuario | bigint | Nullable | - | Referência ao usuário que realizou a ação. |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp do evento. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o evento pertence. |

## Chaves
- Primária: id_chamado_evento
- Únicas: nenhuma
- Estrangeiras:
  - fk_chev_chamado: id_chamado → chamado (id_chamado)
  - fk_chev_user: id_usuario → usuario (id_usuario)

## Índices
- PRIMARY KEY (id_chamado_evento)
- KEY idx_chev_chamado (id_chamado)
- KEY fk_chev_user (id_usuario)

## Constraints
- PRIMARY KEY: id_chamado_evento
- FOREIGN KEY: fk_chev_chamado (id_chamado) REFERENCES chamado (id_chamado)
- FOREIGN KEY: fk_chev_user (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com chamado (id_chamado) - muitos eventos podem estar vinculados a um chamado
- N:1 com usuario (id_usuario) - optional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: chamado, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada mudança de status ou atribuição
- Permite auditoria completa do histórico de um chamado
- Usada para geração de timeline do chamado
- Cada evento pode ter detalhes específicos da operação realizada