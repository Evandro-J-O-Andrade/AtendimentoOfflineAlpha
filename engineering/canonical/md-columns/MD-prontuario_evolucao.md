# MD-prontuario_evolucao-colunas — Colunas

## Tabela: `prontuario_evolucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evolucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `status` | enum('ATIVO','REVISADO','CANCELADO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `alterado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evolucao`),
KEY `fk_evolucao_atendimento` (`id_atendimento`),
KEY `fk_evolucao_usuario` (`id_usuario`),
CONSTRAINT `fk_evolucao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `prontuario_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prontuario_evolucao` ENABLE KEYS */;
