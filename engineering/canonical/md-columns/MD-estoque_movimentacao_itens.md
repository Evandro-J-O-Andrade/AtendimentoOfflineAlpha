# MD-estoque_movimentacao_itens-colunas — Colunas

## Tabela: `estoque_movimentacao_itens`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_produto` | int | NOT NULL |
| `quantidade_saida` | decimal(12,4) | NOT NULL |
| `id_usuario_quem_deu_baixa` | bigint | NOT NULL |
| `data_movimento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_mov_atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `estoque_movimentacao_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimentacao_itens` ENABLE KEYS */;
