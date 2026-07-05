# MD-codigo_externo_vinculo-colunas — Colunas

## Tabela: `codigo_externo_vinculo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_vinculo` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | varchar(30) | NOT NULL |
| `sistema_externo` | varchar(50) | NOT NULL |
| `codigo_externo` | varchar(80) | NOT NULL |
| `id_codigo_universal` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `observacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_vinculo`),
UNIQUE KEY `uk_vinculo` (`tipo`,`sistema_externo`,`codigo_externo`),
KEY `ix_vinculo_codigo` (`id_codigo_universal`)
/*!40000 ALTER TABLE `codigo_externo_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_externo_vinculo` ENABLE KEYS */;
