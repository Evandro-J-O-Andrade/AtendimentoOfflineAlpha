# MD-solicitacao_exame-colunas — Colunas

## Tabela: `solicitacao_exame`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_solicitacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_exame` | int | DEFAULT NULL |
| `id_sigpat` | bigint | DEFAULT NULL |
| `status` | enum('SOLICITADO','COLETADO','EM_ANALISE','RESULTADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_medico` | bigint | DEFAULT NULL |
| `solicitado_em` | datetime | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_solicitacao`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_exame` (`id_exame`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `solicitacao_exame_ibfk_2` FOREIGN KEY (`id_exame`) REFERENCES `exame` (`id_exame`),
CONSTRAINT `solicitacao_exame_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `solicitacao_exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitacao_exame` ENABLE KEYS */;
