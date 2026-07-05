# MD-gasoterapia_consumo-colunas — Colunas

## Tabela: `gasoterapia_consumo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_leito` | int | NOT NULL |
| `tipo_gas` | enum('OXIGENIO','AR_COMPRIMIDO','VACUO','MISTURA_N2O') | NOT NULL |
| `litros_por_minuto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `data_inicio` | datetime | NOT NULL |
| `data_fim` | datetime | DEFAULT NULL |
| `status` | enum('EM_USO','ENCERRADO','CANCELADO') | DEFAULT 'EM_USO' |
| `id_usuario_registro` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_gaso_atendimento` (`id_atendimento`),
KEY `fk_gaso_leito` (`id_leito`),
CONSTRAINT `fk_gaso_leito` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
/*!40000 ALTER TABLE `gasoterapia_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `gasoterapia_consumo` ENABLE KEYS */;
