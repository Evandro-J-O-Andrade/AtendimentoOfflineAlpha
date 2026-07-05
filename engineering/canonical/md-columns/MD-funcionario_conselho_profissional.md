# MD-funcionario_conselho_profissional-colunas — Colunas

## Tabela: `funcionario_conselho_profissional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_funcionario_conselho` | bigint | NOT NULL AUTO_INCREMENT |
| `id_funcionario` | bigint | NOT NULL |
| `conselho` | varchar(50) | NOT NULL |
| `numero_registro` | varchar(50) | NOT NULL |
| `uf` | char(2) | NOT NULL |
| `situacao` | enum('ATIVO','SUSPENSO','CANCELADO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_funcionario_conselho`),
KEY `idx_fcp_funcionario` (`id_funcionario`),
CONSTRAINT `fk_fcp_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`)
/*!40000 ALTER TABLE `funcionario_conselho_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario_conselho_profissional` ENABLE KEYS */;
