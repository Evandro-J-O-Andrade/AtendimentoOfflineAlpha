# MD-erro_evento-colunas — Colunas

## Tabela: `erro_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_erro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_erro_catalogo` | bigint | DEFAULT NULL |
| `uuid_transacao` | char(36) | DEFAULT NULL |
| `dominio` | varchar(50) | DEFAULT NULL |
| `acao` | varchar(100) | DEFAULT NULL |
| `mensagem_erro` | text | NOT NULL |
| `stack_trace` | json | DEFAULT NULL |
| `payload_tentativa` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_erro`),
KEY `idx_erro_sessao` (`id_sessao_usuario`),
KEY `idx_erro_data` (`criado_em`),
KEY `fk_erro_catalogo` (`id_erro_catalogo`),
CONSTRAINT `fk_erro_catalogo` FOREIGN KEY (`id_erro_catalogo`) REFERENCES `erro_catalogo` (`id_erro_catalogo`) ON DELETE SET NULL
/*!40000 ALTER TABLE `erro_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `erro_evento` ENABLE KEYS */;
