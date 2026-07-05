# MD-hospital_leitos-colunas — Colunas

## Tabela: `hospital_leitos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_leito` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned DEFAULT NULL |
| `nome_leito` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo_leito` | enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status` | enum('LIVRE','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LIVRE' |
| `id_atendimento_atual` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_leito`)
/*!40000 ALTER TABLE `hospital_leitos` DISABLE KEYS */;
/*!40000 ALTER TABLE `hospital_leitos` ENABLE KEYS */;
