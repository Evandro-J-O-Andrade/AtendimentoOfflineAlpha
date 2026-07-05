# MD-conselho_profissional-colunas — Colunas

## Tabela: `conselho_profissional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_conselho` | int | NOT NULL AUTO_INCREMENT |
| `sigla` | varchar(10) | NOT NULL |
| `nome` | varchar(100) | NOT NULL |
| `uf` | char(2) | DEFAULT 'SP' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_conselho`)
/*!40000 ALTER TABLE `conselho_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `conselho_profissional` ENABLE KEYS */;
