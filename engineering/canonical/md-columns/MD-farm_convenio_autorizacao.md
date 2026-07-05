# MD-farm_convenio_autorizacao-colunas — Colunas

## Tabela: `farm_convenio_autorizacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_autorizacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_dispensacao` | bigint | NOT NULL |
| `numero_autorizacao` | varchar(80) | DEFAULT NULL |
| `status` | enum('PENDENTE','APROVADO','NEGADO') | NOT NULL DEFAULT 'PENDENTE' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_autorizacao`),
KEY `fk_conv_disp` (`id_dispensacao`),
CONSTRAINT `fk_conv_disp` FOREIGN KEY (`id_dispensacao`) REFERENCES `farm_dispensacao` (`id_dispensacao`)
/*!40000 ALTER TABLE `farm_convenio_autorizacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_convenio_autorizacao` ENABLE KEYS */;
