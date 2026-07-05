# MD-internacao_registro_enfermagem-colunas — Colunas

## Tabela: `internacao_registro_enfermagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_registro_enfermagem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `data_hora` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `turno` | enum('MANHA','TARDE','NOITE','INDEFINIDO') | NOT NULL DEFAULT 'INDEFINIDO' |
| `periodicidade` | enum('2H','4H','6H','TURNO','EVENTUAL') | NOT NULL DEFAULT 'EVENTUAL' |
| `pressao_arterial` | varchar(10) | DEFAULT NULL |
| `temperatura` | decimal(4,1) | DEFAULT NULL |
| `frequencia_cardiaca` | int | DEFAULT NULL |
| `frequencia_respiratoria` | int | DEFAULT NULL |
| `saturacao_o2` | int | DEFAULT NULL |
| `glicemia` | int | DEFAULT NULL |
| `entradas_ml` | int | DEFAULT NULL |
| `saidas_ml` | int | DEFAULT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_registro_enfermagem`),
KEY `idx_ire_internacao` (`id_internacao`),
KEY `idx_ire_data_hora` (`data_hora`),
KEY `idx_ire_usuario` (`id_usuario_responsavel`),
KEY `idx_ire_sessao` (`id_sessao_usuario`),
KEY `fk_internacao_registro_enfermagem_atendimento` (`id_atendimento`),
KEY `idx_int_regenf_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_registro_enfermagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_registro_enfermagem_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_ire_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_ire_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `internacao_registro_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_registro_enfermagem` ENABLE KEYS */;
