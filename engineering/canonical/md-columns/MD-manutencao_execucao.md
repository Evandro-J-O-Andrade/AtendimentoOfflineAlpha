# MD-manutencao_execucao-colunas — Colunas

## Tabela: `manutencao_execucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_execucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_chamado` | bigint | NOT NULL |
| `tecnico` | bigint | NOT NULL |
| `descricao_servico` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `inicio_em` | datetime | DEFAULT NULL |
| `fim_em` | datetime | DEFAULT NULL |
| `status` | enum('INICIADO','PAUSADO','FINALIZADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'INICIADO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_execucao`)
/*!40000 ALTER TABLE `manutencao_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `manutencao_execucao` ENABLE KEYS */;
