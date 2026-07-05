# MD-farm_dispensacao-colunas — Colunas

## Tabela: `farm_dispensacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispensacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_receita` | bigint | NOT NULL |
| `tipo` | enum('INTERNO','VENDA','CONVENIO') | NOT NULL |
| `id_usuario_primeira_baixa` | bigint | DEFAULT NULL |
| `primeira_baixa_em` | datetime | DEFAULT NULL |
| `id_usuario_segunda_baixa` | bigint | DEFAULT NULL |
| `segunda_baixa_em` | datetime | DEFAULT NULL |
| `status` | enum('ABERTA','PARCIAL','FINALIZADA','CANCELADA') | NOT NULL DEFAULT 'ABERTA' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispensacao`),
KEY `fk_disp_receita` (`id_receita`),
CONSTRAINT `fk_disp_receita` FOREIGN KEY (`id_receita`) REFERENCES `farm_receita_controlada` (`id_receita`)
/*!40000 ALTER TABLE `farm_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farm_dispensacao` ENABLE KEYS */;
