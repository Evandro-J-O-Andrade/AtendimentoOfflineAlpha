# MD-runtime_contexto-colunas — Colunas

## Tabela: `runtime_contexto`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_runtime_contexto` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `contexto_clinico` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `estado_fluxo` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `iniciado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `finalizado_em` | datetime(6) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_runtime_contexto`),
KEY `idx_runtime_sessao` (`id_sessao_usuario`),
KEY `fk_runtime_contexto_unidade` (`id_unidade`),
CONSTRAINT `fk_runtime_contexto_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_runtime_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `runtime_contexto` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_contexto` ENABLE KEYS */;
