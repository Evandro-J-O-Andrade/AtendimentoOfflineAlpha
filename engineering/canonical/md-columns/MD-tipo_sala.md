# MD-tipo_sala-colunas — Colunas

## Tabela: `tipo_sala`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tipo_sala` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(50) | DEFAULT NULL |
| `nome` | varchar(100) | DEFAULT NULL |
| `gera_chamada_painel` | tinyint(1) | DEFAULT NULL |
| `usa_tts` | tinyint(1) | DEFAULT NULL |
| `tipo_fila` | varchar(50) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_tipo_sala`)
/*!40000 ALTER TABLE `tipo_sala` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipo_sala` ENABLE KEYS */;
