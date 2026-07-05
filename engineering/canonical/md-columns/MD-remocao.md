# MD-remocao-colunas — Colunas

## Tabela: `remocao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_remocao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `origem` | varchar(150) | DEFAULT NULL |
| `destino` | varchar(150) | DEFAULT NULL |
| `motivo` | varchar(255) | DEFAULT NULL |
| `status` | enum('SOLICITADA','AUTORIZADA','EM_TRANSITO','CONCLUIDA','CANCELADA') | NOT NULL DEFAULT 'SOLICITADA' |
| `id_viatura` | bigint | DEFAULT NULL |
| `condutor_interno` | varchar(150) | DEFAULT NULL |
| `condutor_externo` | varchar(150) | DEFAULT NULL |
| `protocolo_cross` | varchar(50) | DEFAULT NULL |
| `id_usuario_solicitante` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_remocao`),
KEY `idx_rem_status` (`status`),
KEY `fk_rem_unidade` (`id_unidade`),
KEY `fk_rem_viatura` (`id_viatura`),
KEY `fk_rem_user` (`id_usuario_solicitante`),
CONSTRAINT `fk_rem_user` FOREIGN KEY (`id_usuario_solicitante`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_rem_viatura` FOREIGN KEY (`id_viatura`) REFERENCES `viatura` (`id_viatura`),
CONSTRAINT `fk_remocao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `remocao` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao` ENABLE KEYS */;
