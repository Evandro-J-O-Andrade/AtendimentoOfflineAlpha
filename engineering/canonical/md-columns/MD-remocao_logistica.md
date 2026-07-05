# MD-remocao_logistica-colunas — Colunas

## Tabela: `remocao_logistica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_remocao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `motorista_nome` | varchar(100) | DEFAULT NULL |
| `tecnico_nome` | varchar(100) | DEFAULT NULL |
| `destino` | varchar(255) | NOT NULL |
| `status` | enum('PENDENTE','EM_REMOCAO','CONCLUIDO') | DEFAULT 'PENDENTE' |
| `data_saida` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_remocao`),
KEY `fk_rem_ffa_heranca` (`id_ffa`),
KEY `fk_rem_atend_heranca` (`id_atendimento`)
/*!40000 ALTER TABLE `remocao_logistica` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao_logistica` ENABLE KEYS */;
