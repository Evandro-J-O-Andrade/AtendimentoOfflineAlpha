# MD-painel_config-colunas — Colunas

## Tabela: `painel_config`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel_config` | bigint | NOT NULL AUTO_INCREMENT |
| `id_painel` | bigint | DEFAULT NULL |
| `chave` | varchar(80) | NOT NULL |
| `valor_bool` | tinyint(1) | DEFAULT NULL |
| `valor_int` | int | DEFAULT NULL |
| `valor_decimal` | decimal(12,4) | DEFAULT NULL |
| `valor_json` | json | DEFAULT NULL |
| `valor_enum` | varchar(80) | DEFAULT NULL |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_painel_config`),
UNIQUE KEY `uk_painel_config_painel_chave` (`id_painel`,`chave`),
KEY `idx_painel_config_chave` (`chave`),
KEY `idx_painel_config_painel` (`id_painel`),
KEY `idx_painel_config_atualizado_em` (`atualizado_em`),
CONSTRAINT `fk_painel_config_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`) ON DELETE CASCADE
/*!40000 ALTER TABLE `painel_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_config` ENABLE KEYS */;
