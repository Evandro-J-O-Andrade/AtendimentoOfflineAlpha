# MD-protocolo_emissao-colunas — Colunas

## Tabela: `protocolo_emissao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_emissao` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `chave` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ano` | int | DEFAULT NULL |
| `data_ref` | date | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_cliente` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_emissao`),
UNIQUE KEY `uk_protocolo_emissao_codigo` (`codigo`),
KEY `idx_prot_tipo_data` (`tipo`,`ano`,`data_ref`,`criado_em`),
KEY `idx_prot_paciente` (`id_paciente`),
KEY `idx_prot_ffa` (`id_ffa`),
KEY `idx_prot_senha` (`id_senha`),
KEY `idx_prot_cliente` (`id_cliente`),
KEY `idx_prot_sessao` (`id_sessao_usuario`),
KEY `fk_prot_em_usuario` (`id_usuario`),
CONSTRAINT `fk_prot_em_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
CONSTRAINT `fk_prot_em_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
CONSTRAINT `fk_prot_em_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `protocolo_emissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocolo_emissao` ENABLE KEYS */;
