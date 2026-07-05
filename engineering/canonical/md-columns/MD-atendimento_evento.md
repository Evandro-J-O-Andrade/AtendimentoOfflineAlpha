# MD-atendimento_evento-colunas — Colunas

## Tabela: `atendimento_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `dominio` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `tipo_evento` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `estado_origem` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `estado_destino` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `contexto_fluxo` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `hash_evento` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_evento_ffa` (`id_ffa`),
KEY `idx_evento_atendimento` (`id_atendimento`),
KEY `idx_evento_paciente` (`id_paciente`),
KEY `idx_evento_dominio` (`dominio`),
KEY `idx_evento_tipo` (`tipo_evento`),
KEY `idx_evento_tempo` (`criado_em`),
KEY `idx_evento_sessao` (`id_sessao_usuario`),
KEY `idx_evento_hash` (`hash_evento`),
KEY `fk_aevt_unid` (`id_unidade`),
KEY `fk_atendimento_evento_entidade` (`id_entidade`),
CONSTRAINT `fk_aevt_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_atendimento_evento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_evento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_evento` ENABLE KEYS */;
