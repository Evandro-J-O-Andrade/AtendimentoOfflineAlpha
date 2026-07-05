# MD-pessoa_endereco-colunas — Colunas

## Tabela: `pessoa_endereco`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_endereco` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `id_cidade` | bigint | DEFAULT NULL |
| `tipo` | enum('RESIDENCIAL','COMERCIAL','CORRESPONDENCIA','EMERGENCIA','OUTRO') | DEFAULT 'RESIDENCIAL' |
| `principal` | tinyint(1) | DEFAULT '0' |
| `cep` | varchar(10) | DEFAULT NULL |
| `logradouro` | varchar(150) | DEFAULT NULL |
| `numero` | varchar(20) | DEFAULT NULL |
| `complemento` | varchar(100) | DEFAULT NULL |
| `bairro` | varchar(120) | DEFAULT NULL |
| `referencia` | varchar(200) | DEFAULT NULL |
| `latitude` | decimal(10,7) | DEFAULT NULL |
| `longitude` | decimal(10,7) | DEFAULT NULL |
| `valido_de` | date | DEFAULT NULL |
| `valido_ate` | date | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_endereco`),
KEY `idx_pessoa_endereco_pessoa` (`id_pessoa`),
KEY `idx_pessoa_endereco_cidade` (`id_cidade`),
KEY `idx_pessoa_endereco_principal` (`principal`),
CONSTRAINT `fk_pessoa_endereco_cidade` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
CONSTRAINT `fk_pessoa_endereco_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_endereco` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_endereco` ENABLE KEYS */;
