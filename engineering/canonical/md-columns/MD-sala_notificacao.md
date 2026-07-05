# MD-sala_notificacao-colunas — Colunas

## Tabela: `sala_notificacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_notificacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `tipo` | enum('VIOLENCIA','AGRAVO','OUTRO') | NOT NULL DEFAULT 'OUTRO' |
| `status` | enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `id_usuario_abertura` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_notificacao`),
KEY `fk_sn_unidade` (`id_unidade`),
KEY `fk_sn_user` (`id_usuario_abertura`),
CONSTRAINT `fk_sala_notificacao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_sn_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `sala_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `sala_notificacao` ENABLE KEYS */;
