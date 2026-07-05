# MD-config_leitos-colunas — Colunas

## Tabela: `config_leitos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `identificacao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_ocupacao` | enum('LIVRE','OCUPADO','RESERVADO','HIGIENIZACAO','MANUTENCAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LIVRE' |
| `id_atendimento_atual` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_config_leitos_unidade` (`id_unidade`),
CONSTRAINT `fk_config_leitos_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `config_leitos` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_leitos` ENABLE KEYS */;
