# reg_export_erro_validacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_export_erro | bigint | NOT NULL | - | (Documentar) |
| id_export_item | bigint | YES | - | (Documentar) |
| id_export_arquivo | bigint | YES | - | (Documentar) |
| severidade | enum('INFO' | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | YES | - | (Documentar) |
| campo | varchar(120) | YES | - | (Documentar) |
| mensagem | varchar(500) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_export_arquivo -> reg_export_arquivo.id_export_arquivo
- Estrangeira: id_export_item -> reg_export_item.id_export_item

## Indices

- PRIMARY KEY (id_export_erro)
- KEY (id_export_item)
- KEY (id_export_arquivo)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

