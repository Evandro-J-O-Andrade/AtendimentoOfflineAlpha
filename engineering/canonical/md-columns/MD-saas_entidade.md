# MD-saas_entidade-colunas — Colunas

## Tabela: `saas_entidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_entidade` | bigint | unsigned NOT NULL |
| `nome_fantasia` | varchar(200) | NOT NULL |
| `razao_social` | varchar(200) | DEFAULT NULL |
| `cnpj` | varchar(20) | DEFAULT NULL |
| `tipo_entidade` | enum('PREFEITURA','HOSPITAL','UPA','UBS','CLINICA','FARMACIA','OPERADORA') | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_entidade`)
/*!40000 ALTER TABLE `saas_entidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `saas_entidade` ENABLE KEYS */;
