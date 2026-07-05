# MD-procedimento_protocolo_resultado-colunas — Colunas

## Tabela: `procedimento_protocolo_resultado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_resultado` | bigint | NOT NULL AUTO_INCREMENT |
| `id_protocolo` | bigint | NOT NULL |
| `categoria` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `versao` | int | NOT NULL DEFAULT '1' |
| `id_resultado_anterior` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_resultado`),
UNIQUE KEY `uk_pp_res` (`id_protocolo`,`categoria`,`versao`),
KEY `idx_pp_res_proto` (`id_protocolo`,`criado_em`),
KEY `idx_pp_res_cat` (`categoria`,`criado_em`),
KEY `fk_pp_res_prev` (`id_resultado_anterior`),
KEY `fk_pp_res_sessao` (`id_sessao_usuario`),
KEY `fk_pp_res_user` (`id_usuario`),
CONSTRAINT `fk_pp_res_prev` FOREIGN KEY (`id_resultado_anterior`) REFERENCES `procedimento_protocolo_resultado` (`id_resultado`),
CONSTRAINT `fk_pp_res_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
CONSTRAINT `fk_pp_res_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `procedimento_protocolo_resultado` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo_resultado` ENABLE KEYS */;
