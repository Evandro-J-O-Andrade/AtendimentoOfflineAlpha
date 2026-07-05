# MD-atendimento_identidade_fluxo-colunas — Colunas

## Tabela: `atendimento_identidade_fluxo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fluxo` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_evento` | char(36) | NOT NULL |
| `uuid_pessoa_assistida` | char(36) | NOT NULL |
| `tipo_entidade` | enum('PACIENTE','FUNCIONARIO','VISITANTE','OUTRO') | NOT NULL |
| `origem_cadastro` | enum('CENTRAL','EDGE_RUNTIME','PROVISORIO_OFFLINE') | NOT NULL |
| `metadata_fluxo` | json | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_fluxo`),
UNIQUE KEY `uk_fluxo_evento` (`uuid_evento`),
KEY `idx_fluxo_pessoa` (`uuid_pessoa_assistida`),
KEY `fk_atendimento_identidade_fluxo_atendimento` (`id_atendimento`),
KEY `idx_aidflux_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_identidade_fluxo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_identidade_fluxo_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_identidade_fluxo` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_identidade_fluxo` ENABLE KEYS */;
