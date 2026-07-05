# MD-estoque_conta-colunas — Colunas

## Tabela: `estoque_conta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_conta` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(30) | NOT NULL |
| `descricao` | varchar(150) | NOT NULL |
| `tipo` | enum('FISICO','RESERVA','PERDA','AJUSTE','TRANSITO','CONSUMO_ASSISTENCIAL') | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_conta`),
UNIQUE KEY `codigo` (`codigo`)
/*!40000 ALTER TABLE `estoque_conta` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_conta` ENABLE KEYS */;
