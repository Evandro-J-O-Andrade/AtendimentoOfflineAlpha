# MD-funcionario-colunas — Colunas

## Tabela: `funcionario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_funcionario` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `matricula` | varchar(50) | DEFAULT NULL |
| `tipo_funcionario` | enum('MEDICO','ENFERMEIRO','TECNICO_ENFERMAGEM','RECEPCIONISTA','FARMACEUTICO','ADMINISTRATIVO','GESTOR','SUPORTE_TI','COORDENADOR','FISIOTERAPEUTA','MANUTENCAO','COORDENADOR_ENFERMAGEM','SUPERVISOR','NUTRICIONISTA','OUTRO') | DEFAULT NULL |
| `cargo` | varchar(150) | DEFAULT NULL |
| `departamento` | varchar(150) | DEFAULT NULL |
| `data_admissao` | date | DEFAULT NULL |
| `data_demissao` | date | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |

---

## Índices

PRIMARY KEY (`id_funcionario`),
KEY `idx_funcionario_pessoa` (`id_pessoa`),
KEY `idx_funcionario_entidade` (`id_entidade`),
KEY `idx_funcionario_matricula` (`matricula`),
CONSTRAINT `fk_funcionario_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_funcionario_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
