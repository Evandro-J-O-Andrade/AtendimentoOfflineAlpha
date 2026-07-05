# MD-farm_receita_controlada-colunas — Colunas

## Tabela: `farm_receita_controlada`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_receita` | bigint | NOT NULL AUTO_INCREMENT |
| `id_operacao` | bigint | NOT NULL |
| `origem` | enum('INTERNO','EXTERNO') | NOT NULL |
| `id_prescricao_medicacao` | bigint | DEFAULT NULL |
| `id_atendimento_ext` | bigint | DEFAULT NULL |
| `paciente_nome` | varchar(255) | DEFAULT NULL |
| `paciente_documento` | varchar(40) | DEFAULT NULL |
| `id_medico` | bigint | DEFAULT NULL |
| `id_prescritor_externo` | bigint | DEFAULT NULL |
| `numero_receita` | varchar(80) | DEFAULT NULL |
| `status` | enum('PENDENTE','RECEBIDA','DISPENSADA','CANCELADA') | NOT NULL DEFAULT 'PENDENTE' |
| `recebido_em` | datetime | DEFAULT NULL |
| `id_usuario_recebimento` | bigint | DEFAULT NULL |
| `id_usuario_baixa_final` | bigint | DEFAULT NULL |
| `baixa_final_em` | datetime | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_receita`),
KEY `ix_receita_status` (`status`),
KEY `fk_rc_operacao` (`id_operacao`),
KEY `fk_rc_at_ext` (`id_atendimento_ext`),
CONSTRAINT `fk_rc_at_ext` FOREIGN KEY (`id_atendimento_ext`) REFERENCES `farm_atendimento_externo` (`id_atendimento_ext`),
CONSTRAINT `fk_rc_operacao` FOREIGN KEY (`id_operacao`) REFERENCES `farm_operacao` (`id_operacao`)
/*!40000 ALTER TABLE `farm_receita_controlada` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_receita_controlada` ENABLE KEYS */;
