# MD-sinan_notificacao-colunas — Colunas

## Tabela: `sinan_notificacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sinan` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_gpat` | bigint | NOT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `tipo_notificacao` | varchar(80) | NOT NULL |
| `status` | enum('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') | NOT NULL DEFAULT 'ABERTA' |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sinan`),
KEY `ix_sinan_ffa` (`id_ffa`),
KEY `ix_sinan_gpat` (`id_gpat`),
KEY `ix_sinan_status` (`status`)
/*!40000 ALTER TABLE `sinan_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinan_notificacao` ENABLE KEYS */;
