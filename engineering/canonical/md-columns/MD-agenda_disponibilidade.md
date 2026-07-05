# MD-agenda_disponibilidade-colunas — Colunas

## Tabela: `agenda_disponibilidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_disponibilidade` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned DEFAULT NULL |
| `id_profissional` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `tipo` | enum('ATENDIMENTO','BLOQUEIO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `inicio_em` | datetime | NOT NULL |
| `fim_em` | datetime | NOT NULL |
| `recorrente` | tinyint(1) | NOT NULL DEFAULT '0' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario_criador` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_disponibilidade`),
KEY `ix_disp_prof` (`id_profissional`,`inicio_em`,`fim_em`),
KEY `ix_disp_ctx` (`id_sistema`,`id_unidade`,`inicio_em`),
KEY `ix_disp_local` (`id_local_operacional`,`inicio_em`),
KEY `fk_disp_unidade` (`id_unidade`),
KEY `fk_disp_user` (`id_usuario_criador`),
KEY `fk_disp_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_disp_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_disp_prof` FOREIGN KEY (`id_profissional`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_disp_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_disp_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_disp_user` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `agenda_disponibilidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `agenda_disponibilidade` ENABLE KEYS */;
