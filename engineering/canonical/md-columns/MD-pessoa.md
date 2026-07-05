# MD-pessoa-colunas — Colunas

## Tabela: `pessoa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(200) | NOT NULL |
| `nome_social` | varchar(200) | DEFAULT NULL |
| `sexo` | enum('MASCULINO','FEMININO','NAO_INFORMADO') | DEFAULT 'NAO_INFORMADO' |
| `identidade_genero` | enum('CIS_MASCULINO','CIS_FEMININO','TRANS_MASCULINO','TRANS_FEMININO','NAO_BINARIO','NAO_INFORMADO') | DEFAULT 'NAO_INFORMADO' |
| `data_nascimento` | date | DEFAULT NULL |
| `nacionalidade` | varchar(100) | DEFAULT NULL |
| `naturalidade` | varchar(150) | DEFAULT NULL |
| `nome_mae` | varchar(200) | DEFAULT NULL |
| `nome_pai` | varchar(200) | DEFAULT NULL |
| `estado_civil` | enum('SOLTEIRO','CASADO','DIVORCIADO','VIUVO','UNIAO_ESTAVEL','NAO_INFORMADO') | DEFAULT 'NAO_INFORMADO' |
| `tipo_pessoa` | enum('PACIENTE','FUNCIONARIO','PROFISSIONAL_SAUDE','ACOMPANHANTE','RESPONSAVEL','CLIENTE','FORNECEDOR','OUTRO') | DEFAULT 'OUTRO' |
| `foto_url` | varchar(500) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa`),
KEY `idx_pessoa_nome` (`nome`),
KEY `idx_pessoa_nome_social` (`nome_social`),
KEY `idx_pessoa_nascimento` (`data_nascimento`),
KEY `idx_pessoa_tipo` (`tipo_pessoa`,`ativo`),
KEY `idx_pessoa_entidade` (`id_entidade`),
CONSTRAINT `fk_pessoa_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
