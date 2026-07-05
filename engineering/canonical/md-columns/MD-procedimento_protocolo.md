# MD-procedimento_protocolo-colunas — Colunas

## Tabela: `procedimento_protocolo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_protocolo` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | enum('EXAME','RX') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `barcode` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | enum('CRIADO','EM_EXECUCAO','FINALIZADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CRIADO' |
| `id_ffa` | bigint | NOT NULL |
| `id_fila` | bigint | NOT NULL |
| `id_sessao_criacao` | bigint | NOT NULL |
| `id_usuario_criacao` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_protocolo`),
UNIQUE KEY `uk_protocolo_codigo` (`codigo`),
UNIQUE KEY `uk_protocolo_fila` (`id_fila`,`tipo`),
KEY `idx_prot_ffa` (`id_ffa`),
KEY `idx_prot_status` (`tipo`,`status`,`criado_em`),
KEY `fk_prot_sessao` (`id_sessao_criacao`),
KEY `fk_prot_usuario` (`id_usuario_criacao`),
CONSTRAINT `fk_prot_fila` FOREIGN KEY (`id_fila`) REFERENCES `fila_operacional` (`id_fila`),
CONSTRAINT `fk_prot_usuario` FOREIGN KEY (`id_usuario_criacao`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `procedimento_protocolo` DISABLE KEYS */;
/*!40000 ALTER TABLE `procedimento_protocolo` ENABLE KEYS */;
