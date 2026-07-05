# MD-agendamentos_eventos-colunas — Colunas

## Tabela: `agendamentos_eventos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_agendamento` | bigint | NOT NULL |
| `tipo` | enum('CRIADO','REAGENDADO','CANCELADO','CHECKIN','INICIADO','CONCLUIDO','NAO_COMPARECEU','OBSERVACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `de_status` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `para_status` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `ix_agev_agendamento` (`id_agendamento`,`criado_em`),
KEY `fk_agev_usuario` (`id_usuario`),
KEY `fk_agev_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_agev_agendamento` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`),
CONSTRAINT `fk_agev_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_agev_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `agendamentos_eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamentos_eventos` ENABLE KEYS */;
