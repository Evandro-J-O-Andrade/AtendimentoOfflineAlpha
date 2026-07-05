# MD-produtividade_evento-colunas — Colunas

## Tabela: `produtividade_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `tipo` | enum('INICIO_ATENDIMENTO','FIM_ATENDIMENTO','EVOLUCAO','PRESCRICAO','ENCAMINHAMENTO','OUTRO') | NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `ocorrido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `detalhe` | varchar(255) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_pe_user_time` (`id_usuario`,`ocorrido_em`),
KEY `idx_pe_tipo_time` (`tipo`,`ocorrido_em`),
KEY `fk_pe_unidade` (`id_unidade`),
CONSTRAINT `fk_pe_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_produtividade_evento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `produtividade_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `produtividade_evento` ENABLE KEYS */;
