# MD-gaso_solicitacao-colunas — Colunas

## Tabela: `gaso_solicitacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gaso` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `tipo` | enum('CILINDRO','REDE','MANUTENCAO','OUTRO') | NOT NULL DEFAULT 'OUTRO' |
| `status` | enum('ABERTO','EM_ATENDIMENTO','ENTREGUE','CANCELADO','FINALIZADO') | NOT NULL DEFAULT 'ABERTO' |
| `local_destino` | varchar(150) | DEFAULT NULL |
| `id_usuario_abertura` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gaso`),
KEY `idx_gaso_status` (`status`),
KEY `fk_gaso_unidade` (`id_unidade`),
KEY `fk_gaso_user` (`id_usuario_abertura`),
CONSTRAINT `fk_gaso_solicitacao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_gaso_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `gaso_solicitacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `gaso_solicitacao` ENABLE KEYS */;
