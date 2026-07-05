# MD-senha_transicao_matriz-colunas — Colunas

## Tabela: `senha_transicao_matriz`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_senha_transicao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_status_origem` | bigint | NOT NULL |
| `id_status_destino` | bigint | NOT NULL |
| `permite_retorno` | tinyint(1) | DEFAULT '0' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_senha_transicao`),
UNIQUE KEY `uk_transicao` (`id_status_origem`,`id_status_destino`),
KEY `id_status_destino` (`id_status_destino`),
CONSTRAINT `senha_transicao_matriz_ibfk_1` FOREIGN KEY (`id_status_origem`) REFERENCES `senha_status` (`id_senha_status`),
CONSTRAINT `senha_transicao_matriz_ibfk_2` FOREIGN KEY (`id_status_destino`) REFERENCES `senha_status` (`id_senha_status`)
/*!40000 ALTER TABLE `senha_transicao_matriz` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha_transicao_matriz` ENABLE KEYS */;
