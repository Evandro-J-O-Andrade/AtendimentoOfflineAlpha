# MD-pessoa_telefone-colunas — Colunas

## Tabela: `pessoa_telefone`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_telefone` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `numero` | varchar(20) | NOT NULL |
| `tipo` | enum('CELULAR','RESIDENCIAL','COMERCIAL','WHATSAPP','EMERGENCIA','OUTRO') | DEFAULT 'CELULAR' |
| `principal` | tinyint(1) | DEFAULT '0' |
| `whatsapp` | tinyint(1) | DEFAULT '0' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `valido_de` | date | DEFAULT NULL |
| `valido_ate` | date | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_telefone`),
KEY `idx_telefone_pessoa` (`id_pessoa`),
KEY `idx_telefone_principal` (`principal`),
CONSTRAINT `fk_pessoa_telefone_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_telefone` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_telefone` ENABLE KEYS */;
