# MD-atendimento_balanco_hidrico-colunas — Colunas

## Tabela: `atendimento_balanco_hidrico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo_movimentacao` | enum('ENTRADA','SAIDA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `volume_ml` | int | NOT NULL |
| `id_usuario_registro` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_atendimento_balanco_hidrico_atendimento` (`id_atendimento`),
KEY `idx_abhi_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_balanco_hidrico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_balanco_hidrico_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_balanco_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_balanco_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `atendimento_balanco_hidrico` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_balanco_hidrico` ENABLE KEYS */;
