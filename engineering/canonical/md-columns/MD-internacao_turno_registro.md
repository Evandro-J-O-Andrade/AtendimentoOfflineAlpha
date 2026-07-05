# MD-internacao_turno_registro-colunas — Colunas

## Tabela: `internacao_turno_registro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_turno_registro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `data_referencia` | date | NOT NULL |
| `turno` | enum('MANHA','TARDE','NOITE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `observacoes_gerais` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_turno_registro`),
KEY `idx_itr_internacao` (`id_internacao`),
KEY `idx_itr_data_turno` (`data_referencia`,`turno`),
KEY `idx_itr_criado_em` (`criado_em`),
KEY `idx_itr_usuario` (`id_usuario_responsavel`),
KEY `fk_itr_sessao` (`id_sessao_usuario`),
KEY `fk_internacao_turno_registro_atendimento` (`id_atendimento`),
KEY `idx_int_turno_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_turno_registro_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_turno_registro_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_itr_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_itr_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `internacao_turno_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_turno_registro` ENABLE KEYS */;
