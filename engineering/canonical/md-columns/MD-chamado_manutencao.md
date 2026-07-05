# MD-chamado_manutencao-colunas — Colunas

## Tabela: `chamado_manutencao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_chamado` | bigint | NOT NULL AUTO_INCREMENT |
| `id_setor` | int | NOT NULL |
| `origem` | enum('PA','INTERNACAO','AMBULATORIO','ADMINISTRATIVO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo_problema` | enum('ELETRICO','HIDRAULICO','AR_CONDICIONADO','EQUIPAMENTO','ESTRUTURAL','TI','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prioridade` | enum('BAIXA','MEDIA','ALTA','CRITICA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'MEDIA' |
| `status` | enum('ABERTO','EM_ATENDIMENTO','AGUARDANDO_PECA','RESOLVIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTO' |
| `aberto_por` | bigint | NOT NULL |
| `aberto_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `fechado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_chamado`)
/*!40000 ALTER TABLE `chamado_manutencao` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado_manutencao` ENABLE KEYS */;
