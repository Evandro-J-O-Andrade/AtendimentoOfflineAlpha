# MD-kernel_authz_policy-colunas — Colunas

## Tabela: `kernel_authz_policy`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_policy` | bigint | NOT NULL AUTO_INCREMENT |
| `id_tenant` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `contexto` | varchar(60) | NOT NULL |
| `recurso` | varchar(120) | NOT NULL |
| `estado_origem` | varchar(60) | DEFAULT '*' |
| `estado_destino` | varchar(60) | DEFAULT '*' |
| `id_dispositivo` | bigint | DEFAULT NULL |
| `id_dispositivo_norm` | bigint | GENERATED ALWAYS AS (ifnull(`id_dispositivo` |
| `decision_fingerprint` | char(64) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_policy`),
UNIQUE KEY `uk_policy_runtime` (`id_tenant`,`id_perfil`,`contexto`,`recurso`,`estado_origem`,`estado_destino`,`id_dispositivo_norm`),
KEY `idx_policy_lookup` (`id_tenant`,`contexto`,`recurso`,`ativo`,`permitido`)
/*!40000 ALTER TABLE `kernel_authz_policy` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_authz_policy` ENABLE KEYS */;
