# MD-atendimento_recepcao-colunas — Colunas

## Tabela: `atendimento_recepcao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo_atendimento` | enum('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `chegada` | enum('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prioridade` | enum('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'NORMAL' |
| `motivo_procura` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `destino_inicial` | enum('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_recepcionista` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_atendimento`),
KEY `id_recepcionista` (`id_recepcionista`),
KEY `idx_arec_ent` (`id_entidade`),
CONSTRAINT `atendimento_recepcao_ibfk_2` FOREIGN KEY (`id_recepcionista`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_atendimento_recepcao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_recepcao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_recepcao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_recepcao` ENABLE KEYS */;
