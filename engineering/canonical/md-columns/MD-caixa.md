# MD-caixa-colunas — Colunas

## Tabela: `caixa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_caixa` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | NOT NULL |
| `status` | enum('ABERTO','FECHADO') | NOT NULL DEFAULT 'FECHADO' |
| `aberto_em` | datetime | DEFAULT NULL |
| `fechado_em` | datetime | DEFAULT NULL |
| `aberto_por` | bigint | DEFAULT NULL |
| `fechado_por` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_caixa`),
KEY `idx_caixa_status` (`status`),
KEY `fk_caixa_unidade` (`id_unidade`),
KEY `fk_caixa_localop` (`id_local_operacional`),
KEY `fk_caixa_aberto_por` (`aberto_por`),
KEY `fk_caixa_fechado_por` (`fechado_por`),
CONSTRAINT `fk_caixa_aberto_por` FOREIGN KEY (`aberto_por`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_caixa_fechado_por` FOREIGN KEY (`fechado_por`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_caixa_localop` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`)
/*!40000 ALTER TABLE `caixa` DISABLE KEYS */;
/*!40000 ALTER TABLE `caixa` ENABLE KEYS */;
