# MD-reg_auditoria_acesso_sensivel-colunas — Colunas

## Tabela: `reg_auditoria_acesso_sensivel`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_acesso` | bigint | NOT NULL AUTO_INCREMENT |
| `ocorrido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `entidade_ref` | varchar(80) | NOT NULL |
| `id_ref` | bigint | NOT NULL |
| `acao` | enum('VISUALIZAR','EXPORTAR','IMPRIMIR','ANEXAR','ALTERAR') | NOT NULL DEFAULT 'VISUALIZAR' |
| `motivo` | varchar(255) | DEFAULT NULL |
| `ip_origem` | varchar(60) | DEFAULT NULL |
| `user_agent` | varchar(255) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_acesso`),
KEY `idx_reg_acesso_dt` (`ocorrido_em`),
KEY `idx_reg_acesso_ref` (`entidade_ref`,`id_ref`),
KEY `idx_reg_acesso_usuario` (`id_usuario`),
KEY `idx_reg_acesso_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_reg_acesso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `reg_auditoria_acesso_sensivel` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_auditoria_acesso_sensivel` ENABLE KEYS */;
