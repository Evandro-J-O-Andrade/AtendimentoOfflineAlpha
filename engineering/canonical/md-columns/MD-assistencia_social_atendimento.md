# MD-assistencia_social_atendimento-colunas — Colunas

## Tabela: `assistencia_social_atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_as` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `status` | enum('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `motivo` | varchar(255) | DEFAULT NULL |
| `id_usuario_abertura` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_as`),
KEY `fk_as_unidade` (`id_unidade`),
KEY `fk_as_user` (`id_usuario_abertura`),
CONSTRAINT `fk_as_user` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `assistencia_social_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencia_social_atendimento` ENABLE KEYS */;
