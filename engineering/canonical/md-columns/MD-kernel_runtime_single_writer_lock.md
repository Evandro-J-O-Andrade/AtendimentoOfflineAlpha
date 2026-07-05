# MD-kernel_runtime_single_writer_lock-colunas — Colunas

## Tabela: `kernel_runtime_single_writer_lock`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_lock` | bigint | NOT NULL AUTO_INCREMENT |
| `contexto_runtime` | varchar(50) | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `estado_lock` | enum('ATIVO','LIBERADO','EXPIRADO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_lock`),
KEY `idx_lock_contexto` (`contexto_runtime`),
KEY `idx_lock_estado` (`estado_lock`)
/*!40000 ALTER TABLE `kernel_runtime_single_writer_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_runtime_single_writer_lock` ENABLE KEYS */;
