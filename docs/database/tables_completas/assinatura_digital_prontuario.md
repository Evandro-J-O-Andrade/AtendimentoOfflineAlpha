# assinatura_digital_prontuario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_ffa_evolucao | bigint | NOT NULL | - | (Documentar) |
| hash_assinatura | text | NOT NULL | - | (Documentar) |
| certificado_serial | varchar(255) | YES | - | (Documentar) |
| data_assinatura | datetime | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_ffa_evolucao -> atendimento_evolucao.id
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id)
- KEY (id_ffa_evolucao)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

