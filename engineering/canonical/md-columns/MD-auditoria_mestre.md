# MD-auditoria_mestre-colunas — Colunas

## Tabela: `auditoria_mestre`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | NOT NULL |
| `dominio` | enum('FILA','ASSISTENCIAL','FINANCEIRO','ESTOQUE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tabela_afetada` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_registro` | bigint | DEFAULT NULL |
| `valor_anterior` | json | DEFAULT NULL |
| `valor_novo` | json | DEFAULT NULL |
| `motivo_alteracao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_evento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_audit_sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_audit_sessao_usuario` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `auditoria_mestre` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_mestre` ENABLE KEYS */;
