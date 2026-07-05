# MD-tenant_registry-colunas — Colunas

## Tabela: `tenant_registry`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tenant` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_tenant` | char(36) | NOT NULL DEFAULT (uuid()) |
| `nome_fantasia` | varchar(200) | NOT NULL |
| `razao_social` | varchar(300) | NOT NULL |
| `cnpj` | varchar(20) | DEFAULT NULL |
| `cnes` | varchar(20) | DEFAULT NULL |
| `instancia_primary` | tinyint(1) | DEFAULT '1' |
| `regiao` | varchar(50) | DEFAULT NULL |
| `pais` | varchar(50) | DEFAULT 'BR' |
| `status` | enum('ATIVO','SUSPENSO','MIGRANDO','INATIVO') | DEFAULT 'ATIVO' |
| `created_at` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `updated_at` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_tenant`),
UNIQUE KEY `uk_uuid` (`uuid_tenant`),
UNIQUE KEY `uk_cnes` (`cnes`),
KEY `idx_status` (`status`),
KEY `idx_regiao` (`regiao`)
/*!40000 ALTER TABLE `tenant_registry` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenant_registry` ENABLE KEYS */;
