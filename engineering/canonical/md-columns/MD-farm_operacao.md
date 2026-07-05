# MD-farm_operacao-colunas — Colunas

## Tabela: `farm_operacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_operacao` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo_ambiente` | enum('HIS','PA','UPA','UBS','HOSPITAL','RUA') | NOT NULL |
| `tipo_operacao` | enum('INTERNO','VENDA_BALCAO','CONVENIO') | NOT NULL |
| `exige_dupla_baixa` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_operacao`)
/*!40000 ALTER TABLE `farm_operacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_operacao` ENABLE KEYS */;
