# MD-rh_registro_profissional-colunas — Colunas

## Tabela: `rh_registro_profissional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_registro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `conselho` | enum('CRM','COREN','CRF','CRO','CREFITO','CRP','CRN','OUTRO') | NOT NULL DEFAULT 'OUTRO' |
| `numero` | varchar(30) | NOT NULL |
| `uf` | char(2) | DEFAULT NULL |
| `uf_norm` | char(2) | GENERATED ALWAYS AS (ifnull(`uf` |
| `especialidade` | varchar(120) | DEFAULT NULL |
| `validade` | date | DEFAULT NULL |
| `status` | enum('ATIVO','INATIVO','SUSPENSO') | NOT NULL DEFAULT 'ATIVO' |
| `origem` | enum('MANUAL','RH','IMPORTADO','INTEGRACAO') | NOT NULL DEFAULT 'MANUAL' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_registro`),
UNIQUE KEY `uk_registro` (`conselho`,`numero`,`uf_norm`),
KEY `ix_registro_pessoa` (`id_pessoa`),
KEY `ix_registro_status` (`status`)
/*!40000 ALTER TABLE `rh_registro_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_registro_profissional` ENABLE KEYS */;
