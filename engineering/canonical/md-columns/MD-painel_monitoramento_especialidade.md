# MD-painel_monitoramento_especialidade-colunas — Colunas

## Tabela: `painel_monitoramento_especialidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cfg` | bigint | NOT NULL AUTO_INCREMENT |
| `id_painel` | bigint | NOT NULL |
| `id_especialidade` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `ordem` | int | NOT NULL DEFAULT '1' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cfg`),
KEY `idx_cfg_painel` (`id_painel`),
KEY `idx_cfg_local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_cfg_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_monitoramento_especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_monitoramento_especialidade` ENABLE KEYS */;
