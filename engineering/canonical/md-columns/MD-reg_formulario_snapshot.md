# MD-reg_formulario_snapshot-colunas — Colunas

## Tabela: `reg_formulario_snapshot`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_snapshot` | bigint | NOT NULL AUTO_INCREMENT |
| `entidade_ref` | varchar(80) | NOT NULL |
| `id_ref` | bigint | NOT NULL |
| `tipo_formulario` | varchar(80) | NOT NULL |
| `versao_layout` | varchar(40) | DEFAULT NULL |
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `payload_json` | json | NOT NULL |
| `payload_hash` | char(64) | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario_criador` | bigint | DEFAULT NULL |
| `sigilo_nivel` | enum('NORMAL','SENSIVEL','MUITO_SENSIVEL') | NOT NULL DEFAULT 'SENSIVEL' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_snapshot`),
UNIQUE KEY `uk_reg_snapshot_ref` (`entidade_ref`,`id_ref`,`tipo_formulario`,`versao_layout`),
KEY `idx_reg_snapshot_hash` (`payload_hash`),
KEY `idx_reg_snapshot_competencia` (`competencia`),
KEY `idx_reg_snapshot_sessao` (`id_sessao_usuario`),
KEY `idx_reg_snapshot_usuario` (`id_usuario_criador`),
CONSTRAINT `fk_reg_snapshot_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`),
CONSTRAINT `fk_reg_snapshot_usuario` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `reg_formulario_snapshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_formulario_snapshot` ENABLE KEYS */;
