# MD-gpat_atendimento-colunas — Colunas

## Tabela: `gpat_atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gpat` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTO' |
| `id_cliente` | bigint | NOT NULL |
| `tipo_prescritor` | enum('INTERNO','EXTERNO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'EXTERNO' |
| `id_usuario_medico` | bigint | DEFAULT NULL |
| `id_prescritor_externo` | bigint | DEFAULT NULL |
| `data_emissao` | date | DEFAULT NULL |
| `data_validade` | date | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_sessao_abertura` | bigint | DEFAULT NULL |
| `id_sessao_fechamento` | bigint | DEFAULT NULL |
| `id_usuario_abertura` | bigint | DEFAULT NULL |
| `id_usuario_fechamento` | bigint | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gpat`),
UNIQUE KEY `uk_gpat_codigo` (`codigo`),
KEY `idx_gpat_status` (`status`),
KEY `idx_gpat_cliente` (`id_cliente`),
KEY `idx_gpat_prescritor` (`id_prescritor_externo`),
KEY `fk_gpat_usuario_medico` (`id_usuario_medico`),
KEY `fk_gpat_sessao_abertura` (`id_sessao_abertura`),
KEY `fk_gpat_sessao_fechamento` (`id_sessao_fechamento`),
KEY `fk_gpat_atendimento_atendimento` (`id_atendimento`),
KEY `idx_gpat_ent` (`id_entidade`),
CONSTRAINT `fk_gpat_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_gpat_atendimento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_gpat_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
CONSTRAINT `fk_gpat_prescritor_ext` FOREIGN KEY (`id_prescritor_externo`) REFERENCES `prescritor_externo` (`id_prescritor_externo`),
CONSTRAINT `fk_gpat_usuario_medico` FOREIGN KEY (`id_usuario_medico`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `gpat_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_atendimento` ENABLE KEYS */;
