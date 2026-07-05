# MD-estoque_inventario-colunas — Colunas

## Tabela: `estoque_inventario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_inventario` | bigint | NOT NULL AUTO_INCREMENT |
| `id_estoque_local` | bigint | NOT NULL |
| `id_codigo_universal` | bigint | DEFAULT NULL |
| `codigo` | varchar(60) | DEFAULT NULL |
| `barcode` | varchar(60) | DEFAULT NULL |
| `status` | enum('ABERTO','EM_CONTAGEM','FECHADO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `id_sessao_usuario_abertura` | bigint | NOT NULL |
| `aberto_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `fechado_em` | datetime | DEFAULT NULL |
| `observacao` | varchar(255) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_inventario`),
KEY `ix_inv_local` (`id_estoque_local`),
KEY `ix_inv_status` (`status`)
/*!40000 ALTER TABLE `estoque_inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_inventario` ENABLE KEYS */;
