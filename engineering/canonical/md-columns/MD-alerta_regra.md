# MD-alerta_regra-colunas — Colunas

## Tabela: `alerta_regra`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alerta_regra` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(60) | NOT NULL |
| `id_sistema_destino` | bigint | NOT NULL |
| `id_perfil_destino` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alerta_regra`),
UNIQUE KEY `uk_alerta_codigo_destino` (`codigo`,`id_sistema_destino`,`id_perfil_destino`),
KEY `fk_alerta_regra_sistema` (`id_sistema_destino`),
KEY `fk_alerta_regra_perfil` (`id_perfil_destino`),
KEY `fk_alerta_regra_unidade` (`id_unidade`),
CONSTRAINT `fk_alerta_regra_perfil` FOREIGN KEY (`id_perfil_destino`) REFERENCES `perfil` (`id_perfil`),
CONSTRAINT `fk_alerta_regra_sistema` FOREIGN KEY (`id_sistema_destino`) REFERENCES `sistema` (`id_sistema`)
/*!40000 ALTER TABLE `alerta_regra` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_regra` ENABLE KEYS */;
