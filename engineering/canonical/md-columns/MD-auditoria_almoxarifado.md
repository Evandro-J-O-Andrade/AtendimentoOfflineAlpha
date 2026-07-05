# MD-auditoria_almoxarifado-colunas — Colunas

## Tabela: `auditoria_almoxarifado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_log` | bigint | NOT NULL AUTO_INCREMENT |
| `id_produto` | bigint | NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `acao` | enum('ENTRADA','SAIDA','AJUSTE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `quantidade` | int | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_log`),
KEY `id_produto` (`id_produto`),
KEY `id_local` (`id_local`),
KEY `id_usuario` (`id_usuario`),
CONSTRAINT `auditoria_almoxarifado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_almoxarifado` (`id_produto`),
CONSTRAINT `auditoria_almoxarifado_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`),
CONSTRAINT `auditoria_almoxarifado_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `auditoria_almoxarifado` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_almoxarifado` ENABLE KEYS */;
