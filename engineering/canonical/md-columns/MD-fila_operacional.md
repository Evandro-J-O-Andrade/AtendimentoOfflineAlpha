# MD-fila_operacional-colunas — Colunas

## Tabela: `fila_operacional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fila` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL COMMENT 'Episódio assistencial' |
| `tipo` | enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de fila' |
| `substatus` | enum('AGUARDANDO','EM_EXECUCAO','REAVALIAR','FINALIZADO','CANCELADO','NAO_COMPARECEU','ENCAMINHADO','RETORNO','EM_OBSERVACAO','CRITICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AGUARDANDO' |
| `prioridade` | enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester' |
| `data_entrada` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila' |
| `entrada_original_em` | datetime | DEFAULT NULL |
| `nao_compareceu_em` | datetime | DEFAULT NULL |
| `retorno_permitido_ate` | datetime | DEFAULT NULL |
| `retorno_utilizado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `retorno_em` | datetime | DEFAULT NULL |
| `data_inicio` | datetime | DEFAULT NULL COMMENT 'Início do atendimento/exame' |
| `reavaliar_em` | datetime | DEFAULT NULL |
| `data_fim` | datetime | DEFAULT NULL COMMENT 'Término do atendimento/exame' |
| `id_responsavel` | bigint | DEFAULT NULL COMMENT 'Usuário que está atendendo/executando' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'Notas ou observações específicas' |
| `id_local` | bigint | DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_fila`),
KEY `id_responsavel` (`id_responsavel`),
KEY `id_local` (`id_local`),
KEY `idx_ffa_tipo_substatus` (`id_ffa`,`tipo`,`substatus`),
KEY `idx_tipo_prioridade` (`tipo`,`prioridade`,`substatus`),
KEY `idx_filaop_ordem` (`tipo`,`substatus`,`prioridade`,`data_entrada`,`id_local_operacional`),
KEY `idx_reavaliar_em` (`tipo`,`substatus`,`reavaliar_em`),
CONSTRAINT `fila_operacional_ibfk_2` FOREIGN KEY (`id_responsavel`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fila_operacional_ibfk_3` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
/*!40000 ALTER TABLE `fila_operacional` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_operacional` ENABLE KEYS */;
