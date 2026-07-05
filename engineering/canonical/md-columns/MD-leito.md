# MD-leito-colunas — Colunas

## Tabela: `leito`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_leito` | int | NOT NULL AUTO_INCREMENT |
| `id_setor` | int | NOT NULL |
| `identificacao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | enum('DISPONIVEL','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO','INTERDITADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'DISPONIVEL' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_leito`),
UNIQUE KEY `uk_setor_leito` (`id_setor`,`identificacao`),
KEY `idx_leito_setor_status` (`id_setor`,`status`),
CONSTRAINT `leito_ibfk_1` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
/*!40000 ALTER TABLE `leito` DISABLE KEYS */;
/*!40000 ALTER TABLE `leito` ENABLE KEYS */;
