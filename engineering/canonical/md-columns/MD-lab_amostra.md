# MD-lab_amostra-colunas — Colunas

## Tabela: `lab_amostra`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_amostra` | bigint | NOT NULL AUTO_INCREMENT |
| `id_protocolo` | bigint | NOT NULL |
| `codigo_amostra` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo_material` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status` | enum('GERADO','COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADO' |
| `impresso` | tinyint(1) | NOT NULL DEFAULT '0' |
| `coletado_em` | datetime | DEFAULT NULL |
| `id_sessao_coleta` | bigint | DEFAULT NULL |
| `id_usuario_coleta` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_ffa` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_amostra`),
UNIQUE KEY `uk_lab_codigo` (`codigo_amostra`),
KEY `idx_lab_status` (`status`,`criado_em`),
KEY `fk_lab_sessao_col` (`id_sessao_coleta`),
KEY `fk_lab_user_col` (`id_usuario_coleta`),
KEY `idx_lab_amostra_protocolo_ffa` (`id_protocolo`,`id_ffa`),
KEY `idx_lab_amostra_ffa` (`id_ffa`),
KEY `idx_lab_amostra_protocolo` (`id_protocolo`),
CONSTRAINT `fk_lab_amostra_protocolo` FOREIGN KEY (`id_protocolo`) REFERENCES `lab_protocolo` (`id_protocolo`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_lab_proto` FOREIGN KEY (`id_protocolo`) REFERENCES `procedimento_protocolo` (`id_protocolo`),
CONSTRAINT `fk_lab_user_col` FOREIGN KEY (`id_usuario_coleta`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `lab_amostra` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_amostra` ENABLE KEYS */;
