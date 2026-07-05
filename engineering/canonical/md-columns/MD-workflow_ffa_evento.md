# MD-workflow_ffa_evento-colunas — Colunas

## Tabela: `workflow_ffa_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_workflow_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `origem` | varchar(20) | NOT NULL |
| `entidade` | varchar(50) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `tipo_evento` | varchar(60) | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL |
| `payload_json` | json | DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_workflow_evento`),
KEY `ix_wf_ffa` (`id_ffa`,`criado_em`),
KEY `ix_wf_tipo` (`tipo_evento`),
KEY `ix_wf_origem` (`origem`),
KEY `ix_wf_entidade` (`entidade`,`id_entidade`),
KEY `fk_workflow_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_workflow_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `workflow_ffa_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_ffa_evento` ENABLE KEYS */;
ON DUPLICATE KEY UPDATE atualizado_em = CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE pipeline_hash=pipeline_hash;
ON DUPLICATE KEY UPDATE id_saldo=id_saldo;
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE qtd_fisica = qtd_fisica + p_quantidade, qtd_projetada = qtd_fisica + p_quantidade;
FOREIGN KEY (id_unidade)
ON DUPLICATE KEY UPDATE lease_expira_em = NOW() + INTERVAL 30 SECOND;
ON DUPLICATE KEY UPDATE id_saldo = id_saldo;
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;
FOREIGN KEY (id_pessoa)
'FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade`(`id_entidade`);'
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE login = login;
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
FROM information_schema.KEY_COLUMN_USAGE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
ON DUPLICATE KEY UPDATE
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
