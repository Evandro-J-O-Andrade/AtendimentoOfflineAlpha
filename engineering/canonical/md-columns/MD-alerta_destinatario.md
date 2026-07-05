# MD-alerta_destinatario-colunas — Colunas

## Tabela: `alerta_destinatario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alerta_destinatario` | bigint | NOT NULL AUTO_INCREMENT |
| `id_alerta` | bigint | NOT NULL |
| `tipo_destino` | enum('USUARIO','PERFIL','PAINEL','LOCAL','UNIDADE','SISTEMA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo_destino` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_destino` | bigint | DEFAULT NULL |
| `status` | enum('NOVO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'NOVO' |
| `lido_em` | datetime | DEFAULT NULL |
| `id_sessao_usuario_acao` | bigint | DEFAULT NULL |
| `id_usuario_acao` | bigint | DEFAULT NULL |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alerta_destinatario`),
KEY `idx_ad_alerta` (`id_alerta`),
KEY `idx_ad_tipo_codigo_status` (`tipo_destino`,`codigo_destino`,`status`),
KEY `idx_ad_tipo_id_status` (`tipo_destino`,`id_destino`,`status`),
KEY `idx_ad_lido_em` (`lido_em`),
KEY `fk_ad_sessao` (`id_sessao_usuario_acao`),
KEY `fk_ad_usuario` (`id_usuario_acao`),
CONSTRAINT `fk_ad_alerta` FOREIGN KEY (`id_alerta`) REFERENCES `alerta` (`id_alerta`) ON DELETE CASCADE,
CONSTRAINT `fk_ad_usuario` FOREIGN KEY (`id_usuario_acao`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `alerta_destinatario` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_destinatario` ENABLE KEYS */;
