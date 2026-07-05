# MD-chamado-colunas — Colunas

## Tabela: `chamado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_chamado` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `area_responsavel` | enum('TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','OUTRA') | NOT NULL |
| `prioridade` | enum('BAIXA','MEDIA','ALTA','CRITICA') | NOT NULL DEFAULT 'MEDIA' |
| `status` | enum('ABERTO','ENVIADO_GLPI','EM_ATENDIMENTO','AGUARDANDO','RESOLVIDO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `titulo` | varchar(150) | NOT NULL |
| `id_usuario_abertura` | bigint | NOT NULL |
| `id_usuario_atribuido` | bigint | DEFAULT NULL |
| `glpi_ticket_id` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_chamado`),
KEY `idx_ch_area_status` (`area_responsavel`,`status`),
KEY `idx_ch_glpi` (`glpi_ticket_id`),
KEY `fk_ch_unidade` (`id_unidade`),
KEY `fk_ch_sistema` (`id_sistema`),
KEY `fk_ch_user_abertura` (`id_usuario_abertura`),
KEY `fk_ch_user_atr` (`id_usuario_atribuido`),
CONSTRAINT `fk_ch_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_ch_user_abertura` FOREIGN KEY (`id_usuario_abertura`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_ch_user_atr` FOREIGN KEY (`id_usuario_atribuido`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `chamado` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado` ENABLE KEYS */;
