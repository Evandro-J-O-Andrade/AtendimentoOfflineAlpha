# MD-internacao_ferida_avaliacao-colunas — Colunas

## Tabela: `internacao_ferida_avaliacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_ferida_avaliacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `data_hora` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `tipo` | enum('FERIDA','LPP','CIRURGICA','OUTRA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'FERIDA' |
| `local_anatomico` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `estagio_lpp` | enum('I','II','III','IV','NAO_CLASSIFICAVEL','TECIDO_PROFUNDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tamanho_cm` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `aspecto` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `exsudato` | enum('AUSENTE','POUCO','MODERADO','ABUNDANTE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `odor` | enum('NAO','SIM') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `dor` | enum('NAO','SIM') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `curativo` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `observacoes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_documento` | bigint | DEFAULT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_ferida_avaliacao`),
KEY `idx_ifa_internacao` (`id_internacao`),
KEY `idx_ifa_data_hora` (`data_hora`),
KEY `idx_ifa_usuario` (`id_usuario_responsavel`),
KEY `idx_ifa_sessao` (`id_sessao_usuario`),
KEY `idx_ifa_documento` (`id_documento`),
CONSTRAINT `fk_ifa_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`),
CONSTRAINT `fk_ifa_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_ifa_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `internacao_ferida_avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_ferida_avaliacao` ENABLE KEYS */;
