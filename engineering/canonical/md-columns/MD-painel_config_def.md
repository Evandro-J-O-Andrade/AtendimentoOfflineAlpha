# MD-painel_config_def-colunas — Colunas

## Tabela: `painel_config_def`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel_config_def` | bigint | NOT NULL AUTO_INCREMENT |
| `chave` | varchar(80) | NOT NULL |
| `aplica_em` | enum('PAINEL','TOTEM','TV','TODOS') | NOT NULL DEFAULT 'TODOS' |
| `tipo_valor` | enum('BOOL','INT','DECIMAL','TEXT','JSON','ENUM') | NOT NULL |
| `default_bool` | tinyint(1) | DEFAULT NULL |
| `default_int` | int | DEFAULT NULL |
| `default_decimal` | decimal(12,4) | DEFAULT NULL |
| `default_json` | json | DEFAULT NULL |
| `default_enum` | varchar(80) | DEFAULT NULL |
| `categoria` | varchar(50) | DEFAULT NULL |
| `descricao` | varchar(255) | DEFAULT NULL |
| `enum_opcoes_json` | json | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_painel_config_def`),
UNIQUE KEY `uk_painel_config_def_chave` (`chave`),
UNIQUE KEY `uk_painel_cfgdef_aplica_chave` (`aplica_em`,`chave`),
KEY `idx_painel_config_def_categoria` (`categoria`),
KEY `idx_painel_config_def_ativo` (`ativo`)
/*!40000 ALTER TABLE `painel_config_def` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_config_def` ENABLE KEYS */;
