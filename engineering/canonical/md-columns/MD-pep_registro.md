# MD-pep_registro-colunas — Colunas

## Tabela: `pep_registro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pep_registro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_gpat` | bigint | NOT NULL |
| `id_usuario_autor` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `tipo_registro` | enum('EVOLUCAO','ANAMNESE','EXAME_FISICO','HIPOTESE','DIAGNOSTICO','PRESCRICAO','SOLICITACAO','RESULTADO','ALTA','TRANSFERENCIA','OUTRO') | NOT NULL |
| `payload_json` | json | DEFAULT NULL |
| `assinado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `assinado_em` | datetime | DEFAULT NULL |
| `hash_assinatura` | varchar(128) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pep_registro`),
KEY `ix_pep_ffa` (`id_ffa`),
KEY `ix_pep_gpat` (`id_gpat`),
KEY `ix_pep_tipo` (`tipo_registro`),
KEY `ix_pep_autor` (`id_usuario_autor`)
/*!40000 ALTER TABLE `pep_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pep_registro` ENABLE KEYS */;
