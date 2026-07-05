# MD-md_arquivo_fonte_evento-colunas — Colunas

## Tabela: `md_arquivo_fonte_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_md_arquivo_fonte_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_md_arquivo_fonte` | bigint | NOT NULL |
| `ocorrido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `acao` | enum('CRIADO','BAIXADO','PROCESSADO','ERRO','REPROCESSAR') | NOT NULL |
| `detalhes` | varchar(500) | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_md_arquivo_fonte_evento`),
KEY `idx_md_fonte_evt_fonte` (`id_md_arquivo_fonte`),
KEY `idx_md_fonte_evt_dt` (`ocorrido_em`),
KEY `fk_md_fonte_evt_sessao` (`id_sessao_usuario`),
KEY `fk_md_fonte_evt_usuario` (`id_usuario`),
CONSTRAINT `fk_md_fonte_evt_fonte` FOREIGN KEY (`id_md_arquivo_fonte`) REFERENCES `md_arquivo_fonte` (`id_md_arquivo_fonte`),
CONSTRAINT `fk_md_fonte_evt_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `md_arquivo_fonte_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_arquivo_fonte_evento` ENABLE KEYS */;
