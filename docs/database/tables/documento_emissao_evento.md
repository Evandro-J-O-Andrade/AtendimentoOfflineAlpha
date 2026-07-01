# documento_emissao_evento

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NO |  | id evento |
| id_documento | bigint | NO |  | id documento |
| tipo | enum('GERAR','IMPRIMIR','REIMPRIMIR','CANCELAR') | NO |  | tipo |
| detalhe | text | YES |  | detalhe |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| id_usuario | bigint | NO |  | id usuario |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_evento.

## Ãndices

- idx_doc_ev_doc em (id_documento)
- idx_doc_ev_data em (criado_em)
- fk_doc_ev_sessao em (id_sessao_usuario)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

