# MD-nucleo_governanca_assistencial-colunas — Colunas

## Tabela: `nucleo_governanca_assistencial`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_nucleo` | bigint | NOT NULL AUTO_INCREMENT |
| `hash_nucleo_estrutura` | char(64) | NOT NULL |
| `versao_protocolo` | bigint | NOT NULL |
| `estado_nucleo` | enum('ATIVO','MIGRANDO','BLOQUEADO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_nucleo`),
UNIQUE KEY `uk_nucleo_hash` (`hash_nucleo_estrutura`)
/*!40000 ALTER TABLE `nucleo_governanca_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `nucleo_governanca_assistencial` ENABLE KEYS */;
