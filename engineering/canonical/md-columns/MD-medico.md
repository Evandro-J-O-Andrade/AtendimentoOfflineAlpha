# MD-medico-colunas — Colunas

## Tabela: `medico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `crm` | varchar(20) | DEFAULT NULL |
| `uf_crm` | char(2) | DEFAULT NULL |
| `id_especialidade` | bigint | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`),
KEY `fk_medico_especialidade` (`id_especialidade`),
CONSTRAINT `fk_medico_especialidade` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_medico_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `medico` ENABLE KEYS */;
