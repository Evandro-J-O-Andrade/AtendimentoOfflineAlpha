# MD-internacao_dispositivos-colunas — Colunas

## Tabela: `internacao_dispositivos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispositivo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `tipo` | enum('CVC','SVD','SNG','SNE','DRENO','CATETER_PERIFERICO','CANULA_TRAQUEO') | NOT NULL |
| `localizacao` | varchar(100) | DEFAULT NULL |
| `data_insercao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `prazo_troca_dias` | int | DEFAULT '7' |
| `data_prevista_troca` | datetime | DEFAULT NULL |
| `id_usuario_insercao` | bigint | NOT NULL |
| `status` | enum('ATIVO','REMOVIDO','SUBSTITUIDO') | DEFAULT 'ATIVO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispositivo`),
KEY `fk_disp_internacao` (`id_internacao`),
CONSTRAINT `fk_disp_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`)
/*!40000 ALTER TABLE `internacao_dispositivos` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_dispositivos` ENABLE KEYS */;
