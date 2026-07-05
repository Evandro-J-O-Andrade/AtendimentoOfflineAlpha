# MD-plantao_modelo-colunas — Colunas

## Tabela: `plantao_modelo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_plantao_modelo` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(100) | NOT NULL |
| `atravessa_dia` | tinyint(1) | DEFAULT '0' |
| `horas_previstas` | decimal(6,2) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_plantao_modelo`),
UNIQUE KEY `uk_plantao_modelo_nome` (`nome`)
/*!40000 ALTER TABLE `plantao_modelo` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao_modelo` ENABLE KEYS */;
