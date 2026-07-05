# MD-atendimento-colunas — Colunas

## Tabela: `atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_atendimento` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_saas_entidade` | bigint | unsigned NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | unsigned NOT NULL |
| `id_profissional_responsavel` | bigint | unsigned DEFAULT NULL |
| `tipo_atendimento` | enum('AMBULATORIAL','URGENCIA','ELETIVO','UBS','FARMACIA','TELEMEDICINA','SAMU','REMOCAO') | COLLATE utf8mb4_unicode_ci NOT NULL |
| `modo_entrada` | enum('LOCAL','SAMU','REGULADO','TRANSFERENCIA','CONVENIO') | COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LOCAL' |
| `status_execucao` | enum('INICIADO','EM_CURSO','PAUSADO','CONCLUIDO','CANCELADO') | COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INICIADO' |
| `id_faturamento_guia` | varchar(50) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `id_sessao_usuario_criacao` | bigint | unsigned DEFAULT NULL |
| `id_sessao_usuario_alteracao` | bigint | unsigned DEFAULT NULL |
| `uuid_sync` | char(36) | COLLATE utf8mb4_unicode_ci NOT NULL |
| `versao_sync` | bigint | unsigned DEFAULT '0' |
| `hash_estado` | char(64) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `finalizado_em` | datetime(6) | DEFAULT NULL |
| `removido_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_atendimento`),
KEY `idx_atendimento_ffa` (`id_ffa`),
KEY `idx_atendimento_saas_unidade` (`id_saas_entidade`,`id_unidade`),
KEY `idx_atendimento_status_execucao` (`status_execucao`),
KEY `fk_atendimento_unidade` (`id_unidade`),
KEY `idx_atendimento_entidade` (`id_entidade`),
CONSTRAINT `fk_atendimento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_atendimento_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id_ffa`),
CONSTRAINT `fk_atendimento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento` ENABLE KEYS */;
