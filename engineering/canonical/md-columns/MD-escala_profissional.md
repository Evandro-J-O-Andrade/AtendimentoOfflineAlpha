# MD-escala_profissional-colunas — Colunas

## Tabela: `escala_profissional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_escala_profissional` | bigint | NOT NULL AUTO_INCREMENT |
| `id_funcionario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `data_inicio` | datetime | NOT NULL |
| `data_fim` | datetime | NOT NULL |
| `tipo_escala` | enum('PLANTAO','DIURNO','NOTURNO','SOBREAVISO') | DEFAULT 'PLANTAO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_escala_profissional`),
KEY `idx_ep_funcionario` (`id_funcionario`),
KEY `idx_ep_unidade` (`id_unidade`),
KEY `idx_ep_local` (`id_local`),
CONSTRAINT `fk_ep_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_ep_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_escala_profissional_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `escala_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_profissional` ENABLE KEYS */;
