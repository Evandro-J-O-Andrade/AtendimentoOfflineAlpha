# MD-procedimento_protocolo_evento-colunas — Colunas

## Tabela: `procedimento_protocolo_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_protocolo` | bigint | NOT NULL |
| `tipo_evento` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_evt_proto` (`id_protocolo`,`criado_em`),
KEY `idx_evt_tipo` (`tipo_evento`,`criado_em`),
KEY `idx_evt_sessao` (`id_sessao_usuario`,`criado_em`),
KEY `fk_pp_evt_user` (`id_usuario`),
CONSTRAINT `fk_pp_evt_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
CONSTRAINT `fk_pp_evt_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `procedimento_protocolo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo_evento` ENABLE KEYS */;
