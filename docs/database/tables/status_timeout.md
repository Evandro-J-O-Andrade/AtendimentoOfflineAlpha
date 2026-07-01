# status_timeout

**Objetivo:** Configuração de timeouts por status de fluxo

**Descrição:** A tabela `status_timeout` armazena dados relacionados a configuração de timeouts por status de fluxo. Contém 5 colunas, com chave primária em `status`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| status | ENUM('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','AGUARDANDO_RX','CHAMANDO_RX','AGUARDANDO_MEDICACAO','EM_MEDICACAO') | Não | NULL | Status atual do registro no fluxo |
| tempo_max_segundos | INT | Não | NULL | Campo numérico inteiro |
| status_fallback | ENUM('AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_MEDICACAO') | Não | NULL | Status atual do registro no fluxo |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `status`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- PRIMARY KEY em (`status`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `status_timeout` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Define configurações de timeout por status de fluxo, controlando prazos de resposta e escalonamento automático.
