# cat_acidente_trabalho_evento

Objetivo: Registrar eventos de mudança de estado em acidentes de trabalho.
Descrição: Tabela que audita mudanças de status na CAT (acidente de trabalho), incluindo criação, alteração, mudança de status e exportação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada. |
| id_cat | bigint | NOT NULL | - | Referência à CAT (acidente de trabalho) afetada pelo evento. |
| tipo_evento | enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','EXPORTACAO','ERRO') | NOT NULL | - | Tipo: criação, alteração, mudança de status, exportação ou erro. |
| status_anterior | varchar(30) | Nullable | - | Status anterior antes da mudança. |
| status_novo | varchar(30) | Nullable | - | Novo status após a mudança. |
| detalhes | text | Nullable | - | Detalhes adicionais sobre o evento. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a ação. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que realizou a ação. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o evento pertence. |

## Chaves
- Primária: id_evento
- Únicas: nenhuma
- Estrangeiras:
  - fk_cate_cat: id_cat → cat_acidente_trabalho (id) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_evento)
- KEY idx_cate_cat (id_cat)
- KEY fk_cate_sessao (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id_evento
- FOREIGN KEY: fk_cate_cat (id_cat) REFERENCES cat_acidente_trabalho (id) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com cat_acidente_trabalho (id_cat)
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com usuario (id_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: cat_acidente_trabalho, sessao_usuario, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada mudança de estado na CAT
- Permite auditoria completa do ciclo de vida da CAT
- Status anterior e novo permitem rastrear a evolução
- Usada para geração de relatórios de acidentes de trabalho