# MD-ffa-colunas — Colunas

## Tabela: `ffa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_ffa` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_paciente` | bigint | unsigned NOT NULL |
| `estado_clinico` | enum('AGUARDANDO_TRIAGEM','EM_TRIAGEM','AGUARDANDO_ATENDIMENTO','EM_ATENDIMENTO','OBSERVACAO','MEDICACAO','EXAMES','ALTA','EVASAO','TRANSFERENCIA','INTERNACAO','FINALIZADO') | COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AGUARDANDO_TRIAGEM' |
| `contexto_fluxo` | json | DEFAULT NULL |
| `versao_ledger` | bigint | unsigned DEFAULT '1' |
| `id_sessao_usuario_abertura` | bigint | unsigned DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `fechado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_ffa`),
KEY `idx_ffa_paciente` (`id_paciente`),
KEY `idx_ffa_estado` (`estado_clinico`),
KEY `fk_ffa_unidade` (`id_unidade`),
KEY `idx_ffa_entidade_unidade` (`id_entidade`,`id_unidade`),
CONSTRAINT `fk_ffa_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_ffa_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `ffa` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa` ENABLE KEYS */;
