# MD-contexto_atendimento-colunas — Colunas

## Tabela: `contexto_atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_contexto` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `nome` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('PORTA','EMERGENCIA','LEITO','EXECUCAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `usa_fila` | tinyint(1) | DEFAULT NULL |
| `usa_chamada` | tinyint(1) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_contexto`),
KEY `id_sistema` (`id_sistema`),
CONSTRAINT `contexto_atendimento_ibfk_1` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
/*!40000 ALTER TABLE `contexto_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `contexto_atendimento` ENABLE KEYS */;
