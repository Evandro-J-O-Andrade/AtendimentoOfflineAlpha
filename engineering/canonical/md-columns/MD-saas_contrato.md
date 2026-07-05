# MD-saas_contrato-colunas — Colunas

## Tabela: `saas_contrato`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_contrato` | bigint | NOT NULL AUTO_INCREMENT |
| `id_entidade` | bigint | unsigned NOT NULL |
| `data_inicio` | date | NOT NULL |
| `data_fim` | date | DEFAULT NULL |
| `status` | enum('ATIVO','SUSPENSO','CANCELADO') | NOT NULL DEFAULT 'ATIVO' |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

---

## Índices

PRIMARY KEY (`id_contrato`),
KEY `idx_contrato_entidade_status` (`id_entidade`,`status`),
CONSTRAINT `fk_saas_contrato_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `saas_contrato` DISABLE KEYS */;
/*!40000 ALTER TABLE `saas_contrato` ENABLE KEYS */;
