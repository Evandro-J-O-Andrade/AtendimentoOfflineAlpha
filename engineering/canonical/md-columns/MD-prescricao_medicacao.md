# MD-prescricao_medicacao-colunas — Colunas

## Tabela: `prescricao_medicacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prescricao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_medico` | bigint | NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Descrição livre da prescrição' |
| `controlada` | tinyint(1) | DEFAULT '0' COMMENT 'Se exige liberação da farmácia' |
| `criada_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `ativa` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prescricao`),
KEY `id_medico` (`id_medico`),
KEY `idx_ffa` (`id_ffa`),
CONSTRAINT `prescricao_medicacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT
/*!40000 ALTER TABLE `prescricao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_medicacao` ENABLE KEYS */;
