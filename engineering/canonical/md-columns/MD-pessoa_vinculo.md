# MD-pessoa_vinculo-colunas — Colunas

## Tabela: `pessoa_vinculo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_vinculo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa_origem` | bigint | NOT NULL |
| `id_pessoa_destino` | bigint | NOT NULL |
| `tipo_vinculo` | enum('RESPONSAVEL','ACOMPANHANTE','FAMILIAR','CONJUGE','PAI','MAE','FILHO','TUTOR','CUIDADOR','RESPONSAVEL_CLINICO','OUTRO') | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_vinculo`),
KEY `idx_vinculo_origem` (`id_pessoa_origem`),
KEY `idx_vinculo_destino` (`id_pessoa_destino`),
CONSTRAINT `fk_vinculo_pessoa_destino` FOREIGN KEY (`id_pessoa_destino`) REFERENCES `pessoa` (`id_pessoa`),
CONSTRAINT `fk_vinculo_pessoa_origem` FOREIGN KEY (`id_pessoa_origem`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_vinculo` ENABLE KEYS */;
