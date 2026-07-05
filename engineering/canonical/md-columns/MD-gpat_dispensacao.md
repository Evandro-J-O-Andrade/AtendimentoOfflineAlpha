# MD-gpat_dispensacao-colunas — Colunas

## Tabela: `gpat_dispensacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gpat_dispensacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_gpat_item` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `id_local_estoque` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `status` | enum('ENTREGUE','ESTORNADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ENTREGUE' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `entregue_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `estornado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gpat_dispensacao`),
KEY `idx_gpat_disp_item` (`id_gpat_item`),
KEY `idx_gpat_disp_lote` (`id_lote`),
KEY `idx_gpat_disp_status` (`status`),
KEY `fk_gpat_disp_usuario` (`id_usuario`),
KEY `fk_gpat_disp_sessao` (`id_sessao_usuario`),
KEY `fk_gpat_disp_local` (`id_local_estoque`),
CONSTRAINT `fk_gpat_disp_item` FOREIGN KEY (`id_gpat_item`) REFERENCES `gpat_item` (`id_gpat_item`) ON DELETE CASCADE,
CONSTRAINT `fk_gpat_disp_local` FOREIGN KEY (`id_local_estoque`) REFERENCES `local_atendimento` (`id_local`),
CONSTRAINT `fk_gpat_disp_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`),
CONSTRAINT `fk_gpat_disp_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `gpat_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_dispensacao` ENABLE KEYS */;
