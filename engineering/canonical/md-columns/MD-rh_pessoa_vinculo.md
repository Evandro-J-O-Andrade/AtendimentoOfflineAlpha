# MD-rh_pessoa_vinculo-colunas — Colunas

## Tabela: `rh_pessoa_vinculo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_rh_vinculo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `tipo_vinculo` | enum('FUNCIONARIO','TERCEIRO','ESTAGIARIO','PRESTADOR','VOLUNTARIO') | NOT NULL DEFAULT 'FUNCIONARIO' |
| `matricula` | varchar(40) | DEFAULT NULL |
| `cpf` | varchar(14) | DEFAULT NULL |
| `rg` | varchar(30) | DEFAULT NULL |
| `orgao_emissor` | varchar(20) | DEFAULT NULL |
| `pis_pasep` | varchar(20) | DEFAULT NULL |
| `data_admissao` | date | DEFAULT NULL |
| `data_demissao` | date | DEFAULT NULL |
| `status` | enum('ATIVO','INATIVO','AFASTADO') | NOT NULL DEFAULT 'ATIVO' |
| `id_unidade_lotacao` | bigint | DEFAULT NULL |
| `id_local_lotacao` | bigint | DEFAULT NULL |
| `cargo` | varchar(120) | DEFAULT NULL |
| `setor` | varchar(120) | DEFAULT NULL |
| `email` | varchar(120) | DEFAULT NULL |
| `telefone` | varchar(40) | DEFAULT NULL |
| `endereco` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_rh_vinculo`),
UNIQUE KEY `uk_rh_matricula` (`matricula`),
KEY `ix_rh_pessoa` (`id_pessoa`),
KEY `ix_rh_status` (`status`)
/*!40000 ALTER TABLE `rh_pessoa_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_pessoa_vinculo` ENABLE KEYS */;
