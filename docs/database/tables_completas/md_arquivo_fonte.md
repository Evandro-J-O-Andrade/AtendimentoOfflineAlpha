# md_arquivo_fonte

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_md_arquivo_fonte | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('CID10' | NOT NULL | - | (Documentar) |
| competencia | char(6) | YES | - | (Documentar) |
| origem | varchar(120) | YES | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| url_origem | varchar(255) | YES | - | (Documentar) |
| nome_arquivo | varchar(200) | YES | - | (Documentar) |
| tamanho_bytes | bigint | YES | - | (Documentar) |
| sha256 | char(64) | YES | - | (Documentar) |
| baixado_em | datetime | YES | - | (Documentar) |
| processado_em | datetime | YES | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| mensagem_erro | varchar(500) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: competencia -> md_competencia.competencia

## Indices

- PRIMARY KEY (id_md_arquivo_fonte)
- KEY (tipo,competencia)
- KEY (status)
- KEY (sha256)
- KEY (competencia)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

