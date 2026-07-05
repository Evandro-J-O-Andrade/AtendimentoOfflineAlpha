# MD-paciente-colunas — Colunas

## Tabela: `paciente`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_paciente` | char(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL |
| `hash_identidade` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL |
| `id_pessoa` | bigint | NOT NULL |
| `prontuario` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL |
| `data_cadastro` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `sexo` | char(1) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL |
| `data_nascimento` | date | DEFAULT NULL |
| `nome` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL |
| `documento_principal` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL |
| `metadata_identidade` | json | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_paciente_uuid` (`uuid_paciente`),
UNIQUE KEY `uk_paciente_hash` (`hash_identidade`),
UNIQUE KEY `prontuario` (`prontuario`),
KEY `id_pessoa` (`id_pessoa`),
KEY `idx_paciente_nome` (`nome`),
KEY `idx_paciente_entidade` (`id_entidade`),
KEY `idx_paciente_prontuario` (`id_entidade`,`prontuario`),
CONSTRAINT `fk_paciente_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
