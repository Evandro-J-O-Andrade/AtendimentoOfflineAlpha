# MD-local_dispositivo-colunas — Colunas

## Tabela: `local_dispositivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local_dispositivo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_local` | bigint | NOT NULL |
| `id_dispositivo` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local_dispositivo`),
KEY `id_local` (`id_local`),
CONSTRAINT `local_dispositivo_ibfk_1` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`)
/*!40000 ALTER TABLE `local_dispositivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_dispositivo` ENABLE KEYS */;
