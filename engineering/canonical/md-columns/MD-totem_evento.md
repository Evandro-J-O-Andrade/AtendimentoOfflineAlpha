# MD-totem_evento-colunas — Colunas

## Tabela: `totem_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_totem_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_totem` | bigint | NOT NULL |
| `evento` | enum('ONLINE','OFFLINE','EMITIU_SENHA','ERRO','SENHA_GERADA','SENHA_CHAMADA','SENHA_ATENDIDA','SENHA_CANCELADA','SENHA_REAUTUADA') | NOT NULL |
| `ip_acesso` | varchar(45) | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_totem_evento`),
KEY `idx_te_totem` (`id_totem`),
CONSTRAINT `fk_te_totem` FOREIGN KEY (`id_totem`) REFERENCES `totem` (`id_totem`)
/*!40000 ALTER TABLE `totem_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem_evento` ENABLE KEYS */;
