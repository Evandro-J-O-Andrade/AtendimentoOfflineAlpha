# MD-estoque_local-colunas — Colunas

## Tabela: `estoque_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_estoque_local` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(60) | NOT NULL |
| `tipo` | enum('FARMACIA_RUA','FARMACIA_PA','FARMACIA_UPA','FARMACIA_UBS','ALMOX','LAB','OUTRO') | NOT NULL |
| `ala` | enum('ADULTO','PEDI') | DEFAULT NULL |
| `nome` | varchar(200) | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_local_operacional` | bigint | NOT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_estoque_local`),
UNIQUE KEY `uk_codigo_unidade` (`codigo`,`id_unidade`),
KEY `fk_local_sessao` (`id_sessao_usuario`),
KEY `fk_estoque_local_unidade` (`id_unidade`),
CONSTRAINT `fk_estoque_local_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `estoque_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_local` ENABLE KEYS */;
