# MD-codigo_universal-colunas — Colunas

## Tabela: `codigo_universal`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_codigo` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio` | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prefixo_5` | char(5) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `sequencia` | int | DEFAULT NULL |
| `codigo_interno` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `barcode` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL |
| `origem_interno` | enum('AUTO','MANUAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AUTO' |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_produto` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_cliente` | bigint | DEFAULT NULL |
| `status` | enum('ATIVO','CANCELADO','SUBSTITUIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO' |
| `payload` | json | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_codigo`),
UNIQUE KEY `uk_codigo_interno` (`codigo_interno`),
UNIQUE KEY `uk_barcode` (`barcode`),
UNIQUE KEY `uk_prefixo_seq` (`dominio`,`prefixo_5`,`sequencia`),
KEY `idx_codigo_dom_status` (`dominio`,`status`,`criado_em`),
KEY `idx_codigo_ffa` (`id_ffa`),
KEY `idx_codigo_produto` (`id_produto`),
KEY `idx_codigo_usuario` (`id_usuario`),
KEY `fk_codigo_senha` (`id_senha`),
KEY `fk_codigo_paciente` (`id_paciente`),
KEY `fk_codigo_cliente` (`id_cliente`),
KEY `fk_codigo_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_codigo_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
CONSTRAINT `fk_codigo_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
CONSTRAINT `fk_codigo_produto` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produto` (`id_produto`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_codigo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `codigo_universal` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_universal` ENABLE KEYS */;
