# MD-servico_agendamento-colunas — Colunas

## Tabela: `servico_agendamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_servico` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `codigo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `nome` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `duracao_minutos` | int | NOT NULL DEFAULT '15' |
| `categoria` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('CONSULTA','PROCEDIMENTO','EXAME','RETORNO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CONSULTA' |
| `exige_profissional` | tinyint(1) | NOT NULL DEFAULT '1' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_servico`),
UNIQUE KEY `uk_servico_ctx_codigo` (`id_sistema`,`id_unidade`,`codigo`),
KEY `ix_servico_ctx` (`id_sistema`,`id_unidade`),
KEY `fk_servico_unidade` (`id_unidade`),
CONSTRAINT `fk_servico_agendamento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_servico_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
/*!40000 ALTER TABLE `servico_agendamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `servico_agendamento` ENABLE KEYS */;
