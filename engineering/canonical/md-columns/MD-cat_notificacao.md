# MD-cat_notificacao-colunas — Colunas

## Tabela: `cat_notificacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cat` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_gpat` | bigint | NOT NULL |
| `id_pedido_item` | bigint | DEFAULT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `status` | enum('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') | NOT NULL DEFAULT 'ABERTA' |
| `data_evento` | datetime | DEFAULT NULL |
| `local_evento` | varchar(255) | DEFAULT NULL |
| `ocupacao` | varchar(120) | DEFAULT NULL |
| `empresa` | varchar(255) | DEFAULT NULL |
| `cnpj` | varchar(20) | DEFAULT NULL |
| `protocolo_interno` | varchar(50) | DEFAULT NULL |
| `protocolo_externo` | varchar(80) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cat`),
KEY `ix_cat_ffa` (`id_ffa`),
KEY `ix_cat_gpat` (`id_gpat`),
KEY `ix_cat_status` (`status`)
/*!40000 ALTER TABLE `cat_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_notificacao` ENABLE KEYS */;
