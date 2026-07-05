# MD-farm_atendimento_externo-colunas — Colunas

## Tabela: `farm_atendimento_externo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_atendimento_ext` | bigint | NOT NULL AUTO_INCREMENT |
| `id_gpat` | bigint | NOT NULL |
| `origem` | varchar(120) | NOT NULL |
| `nome_paciente` | varchar(255) | NOT NULL |
| `nome_medico` | varchar(255) | NOT NULL |
| `conselho_medico` | varchar(10) | DEFAULT NULL |
| `numero_conselho` | varchar(30) | DEFAULT NULL |
| `uf_conselho` | char(2) | DEFAULT NULL |
| `data_receita` | date | DEFAULT NULL |
| `dias_tratamento` | int | DEFAULT NULL |
| `status` | enum('ABERTO','FINALIZADO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_atendimento_ext`),
KEY `ix_fext_gpat` (`id_gpat`),
KEY `ix_fext_status` (`status`),
KEY `fk_farm_atendimento_externo_atendimento` (`id_atendimento`),
KEY `idx_farm_ext_ent` (`id_entidade`),
CONSTRAINT `fk_farm_atendimento_externo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_farm_atendimento_externo_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `farm_atendimento_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_atendimento_externo` ENABLE KEYS */;
