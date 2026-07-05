# MD-atendimento_estado_ativo-colunas — Colunas

## Tabela: `atendimento_estado_ativo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_ffa` | bigint | NOT NULL |
| `id_local_atual` | bigint | NOT NULL |
| `id_leito` | bigint | DEFAULT NULL |
| `tipo_estado` | enum('FILA_ESPERA','TRIAGEM','ATENDIMENTO_MEDICO','OBSERVACAO','INTERNACAO','EXAME','ALTA','EVASAO') | NOT NULL |
| `id_sessao_ultimo_movimento` | bigint | NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_ffa`),
KEY `fk_estado_local` (`id_local_atual`),
KEY `fk_estado_sessao` (`id_sessao_ultimo_movimento`),
KEY `fk_atendimento_estado_ativo_atendimento` (`id_atendimento`),
KEY `idx_aest_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_estado_ativo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_estado_ativo_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_estado_local` FOREIGN KEY (`id_local_atual`) REFERENCES `local_operacional` (`id_local_operacional`)
/*!40000 ALTER TABLE `atendimento_estado_ativo` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_estado_ativo` ENABLE KEYS */;
