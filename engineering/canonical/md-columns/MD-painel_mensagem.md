# MD-painel_mensagem-colunas — Colunas

## Tabela: `painel_mensagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_mensagem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_painel` | bigint | NOT NULL |
| `tipo` | enum('ALERTA','CHAMAR_MEDICO','INFO','URGENTE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ALERTA' |
| `titulo` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `texto` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prioridade` | int | NOT NULL DEFAULT '0' |
| `expira_em` | datetime | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_mensagem`),
KEY `idx_msg_painel` (`id_painel`,`ativo`,`criado_em`),
KEY `idx_msg_expira` (`expira_em`),
CONSTRAINT `fk_msg_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_mensagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_mensagem` ENABLE KEYS */;
