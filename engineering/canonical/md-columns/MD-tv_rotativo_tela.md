# MD-tv_rotativo_tela-colunas — Colunas

## Tabela: `tv_rotativo_tela`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tela` | bigint | NOT NULL AUTO_INCREMENT |
| `id_painel` | bigint | NOT NULL |
| `codigo_tela` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ordem` | int | NOT NULL |
| `duracao_seg` | int | NOT NULL DEFAULT '120' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_tela`),
UNIQUE KEY `uk_tv_rotativo` (`id_painel`,`ordem`),
KEY `idx_tv_painel` (`id_painel`),
CONSTRAINT `fk_tv_rotativo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `tv_rotativo_tela` DISABLE KEYS */;
/*!40000 ALTER TABLE `tv_rotativo_tela` ENABLE KEYS */;
