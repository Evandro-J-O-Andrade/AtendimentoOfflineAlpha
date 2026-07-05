# MD-ordem_assistencial-colunas — Colunas

## Tabela: `ordem_assistencial`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `tipo_ordem` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | enum('ATIVA','SUSPENSA','ENCERRADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVA' |
| `origem` | enum('MEDICO','ENFERMAGEM') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `payload_clinico` | json | NOT NULL |
| `prioridade` | int | DEFAULT '0' |
| `iniciado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `suspenso_em` | datetime | DEFAULT NULL |
| `encerrado_em` | datetime | DEFAULT NULL |
| `motivo_suspensao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `motivo_encerramento` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | NOT NULL |
| `atualizado_em` | datetime | DEFAULT NULL |
| `atualizado_por` | bigint | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ordem_ffa` (`id_ffa`),
KEY `idx_ordem_status` (`status`),
KEY `idx_ordem_tipo` (`tipo_ordem`),
KEY `fk_ordem_assistencial_atendimento` (`id_atendimento`),
KEY `idx_oass_ent` (`id_entidade`),
CONSTRAINT `fk_ordem_assistencial_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_ordem_assistencial_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `ordem_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial` ENABLE KEYS */;
