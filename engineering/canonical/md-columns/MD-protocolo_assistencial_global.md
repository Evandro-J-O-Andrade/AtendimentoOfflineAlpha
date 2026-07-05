# MD-protocolo_assistencial_global-colunas — Colunas

## Tabela: `protocolo_assistencial_global`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_protocolo` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `versao_protocolo` | bigint | NOT NULL |
| `hash_protocolar` | char(64) | NOT NULL |
| `payload_protocolo` | json | NOT NULL |
| `estado_protocolo` | enum('ATIVO','OBSOLETO','REVOGADO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_protocolo`),
UNIQUE KEY `uk_protocolo_hash` (`hash_protocolar`),
KEY `idx_protocolo_dominio` (`dominio_fluxo`,`versao_protocolo`),
KEY `fk_protocolo_assistencial_global_atendimento` (`id_atendimento`),
KEY `idx_pag_ent` (`id_entidade`),
CONSTRAINT `fk_protocolo_assistencial_global_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_protocolo_assistencial_global_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `protocolo_assistencial_global` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocolo_assistencial_global` ENABLE KEYS */;
