# MD-transporte_ambulancia-colunas — Colunas

## Tabela: `transporte_ambulancia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_senha` | bigint | NOT NULL |
| `placa_veiculo` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `condutor_nome` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo_equipe` | enum('BASICA','AVANCADA','AEREA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `km_saida` | int | DEFAULT NULL |
| `km_chegada` | int | DEFAULT NULL |
| `data_hora_acionamento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_samu_senha` (`id_senha`)
/*!40000 ALTER TABLE `transporte_ambulancia` DISABLE KEYS */;
/*!40000 ALTER TABLE `transporte_ambulancia` ENABLE KEYS */;
