# MD-reg_export_lote-colunas — Colunas

## Tabela: `reg_export_lote`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_export_lote` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | enum('SINAN_EPIDEMIOLOGICA','SINAN_VIOLENCIA','CAT','PRODUCAO_SUS','FATURAMENTO','OUTRO') | NOT NULL |
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario_criador` | bigint | DEFAULT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `status` | enum('ABERTO','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `protocolo_externo` | varchar(80) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_export_lote`),
KEY `idx_reg_lote_tipo_status` (`tipo`,`status`),
KEY `idx_reg_lote_competencia` (`competencia`),
KEY `idx_reg_lote_data` (`criado_em`),
KEY `idx_reg_lote_sessao` (`id_sessao_usuario`),
KEY `idx_reg_lote_usuario` (`id_usuario_criador`),
KEY `idx_reg_lote_unidade_local` (`id_unidade`,`id_local_operacional`),
KEY `fk_reg_lote_local` (`id_local_operacional`),
CONSTRAINT `fk_reg_export_lote_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_reg_lote_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`),
CONSTRAINT `fk_reg_lote_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_atendimento` (`id_local`),
CONSTRAINT `fk_reg_lote_usuario` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `reg_export_lote` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_lote` ENABLE KEYS */;
