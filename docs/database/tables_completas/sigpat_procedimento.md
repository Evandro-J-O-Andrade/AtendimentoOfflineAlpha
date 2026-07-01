# sigpat_procedimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sigpat | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(20) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| tipo | enum('EXAME' | NOT NULL | - | (Documentar) |
| grupo | varchar(100) | YES | - | (Documentar) |
| subgrupo | varchar(100) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| setor_execucao | enum('RX' | NOT NULL | - | (Documentar) |
| gera_faturamento | tinyint(1) | YES | - | (Documentar) |
| exige_coleta | tinyint(1) | YES | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| atualizado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_sigpat)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

