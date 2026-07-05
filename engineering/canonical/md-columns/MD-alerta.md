# MD-alerta-colunas — Colunas

## Tabela: `alerta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alerta` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `titulo` | varchar(160) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `mensagem` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `gpat` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `severidade` | enum('INFO','ATENCAO','ALTA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATENCAO' |
| `status` | enum('ABERTO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTO' |
| `entidade_origem` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_origem` | bigint | DEFAULT NULL |
| `id_sessao_usuario_origem` | bigint | DEFAULT NULL |
| `id_usuario_origem` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alerta`),
KEY `idx_alerta_codigo_status` (`codigo`,`status`),
KEY `idx_alerta_unidade_local` (`id_unidade`,`id_local_operacional`,`status`),
KEY `idx_alerta_gpat` (`gpat`),
KEY `idx_alerta_paciente` (`id_paciente`),
KEY `idx_alerta_ffa` (`id_ffa`),
KEY `fk_alerta_sessao` (`id_sessao_usuario_origem`),
KEY `fk_alerta_usuario` (`id_usuario_origem`),
CONSTRAINT `fk_alerta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
CONSTRAINT `fk_alerta_usuario` FOREIGN KEY (`id_usuario_origem`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `alerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta` ENABLE KEYS */;
