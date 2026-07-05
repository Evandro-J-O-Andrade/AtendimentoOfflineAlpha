# MD-documento_tipo_config-colunas — Colunas

## Tabela: `documento_tipo_config`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `codigo` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `destino` | enum('PACIENTE','FARMACIA','ENFERMAGEM','ADMIN','ARQUIVO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PACIENTE' |
| `exige_farmaceutico` | tinyint(1) | NOT NULL DEFAULT '0' |
| `template_codigo` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`codigo`)
/*!40000 ALTER TABLE `documento_tipo_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_tipo_config` ENABLE KEYS */;
