# MD-pessoa_conselho_registro-colunas — Colunas

## Tabela: `pessoa_conselho_registro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_conselho` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `id_conselho` | int | NOT NULL |
| `uf_registro` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `registro` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `eh_principal` | tinyint(1) | NOT NULL DEFAULT '0' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_conselho`),
UNIQUE KEY `uk_pessoa_conselho` (`id_pessoa`,`id_conselho`,`uf_registro`,`registro`),
KEY `idx_pessoa_principal` (`id_pessoa`,`eh_principal`,`ativo`),
KEY `idx_conselho_registro` (`id_conselho`,`uf_registro`,`registro`),
CONSTRAINT `fk_pcr_conselho` FOREIGN KEY (`id_conselho`) REFERENCES `conselho_profissional` (`id_conselho`),
CONSTRAINT `fk_pcr_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_conselho_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_conselho_registro` ENABLE KEYS */;
