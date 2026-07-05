# MD-senha-colunas — Colunas

## Tabela: `senha`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_senha` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `codigo_visual` | varchar(10) | COLLATE utf8mb4_unicode_ci NOT NULL |
| `id_paciente` | bigint | unsigned DEFAULT NULL |
| `origem_entrada` | enum('RECEPCAO','AGENDAMENTO','UBS','SAMU','TRANSFERENCIA','REGULACAO','FARMACIA','OUTRO') | COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RECEPCAO' |
| `id_prioridade` | bigint | unsigned NOT NULL DEFAULT '1' |
| `id_fluxo_status` | bigint | unsigned NOT NULL DEFAULT '1' |
| `id_sessao_usuario` | bigint | unsigned DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `uuid_sync` | char(36) | COLLATE utf8mb4_unicode_ci NOT NULL |
| `versao_sync` | bigint | unsigned DEFAULT '0' |
| `hash_estado` | char(64) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `id_ffa` | bigint | unsigned DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_senha`),
KEY `idx_senha_paciente` (`id_paciente`),
KEY `idx_senha_origem` (`origem_entrada`),
KEY `fk_senha_unidade` (`id_unidade`),
KEY `fk_senha_ffa` (`id_ffa`),
KEY `idx_senha_entidade_unidade` (`id_entidade`,`id_unidade`),
CONSTRAINT `fk_senha_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_senha_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id_ffa`),
CONSTRAINT `fk_senha_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha` ENABLE KEYS */;
