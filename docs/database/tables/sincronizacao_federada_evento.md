# sincronizacao_federada_evento

**Objetivo:** Eventos de sincronização federada entre instâncias

**Descrição:** A tabela `sincronizacao_federada_evento` armazena dados relacionados a eventos de sincronização federada entre instâncias. Contém 10 colunas, com chave primária em `id_sync`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sync | BIGINT | Não | NULL | Campo numérico inteiro |
| id_ffa | BIGINT | Não | NULL | Campo numérico inteiro |
| evento | VARCHAR(60) | Não | NULL | Registro de evento ou ocorrência |
| estado_origem | VARCHAR(60) | Sim | NULL | Campo de texto de comprimento variável |
| estado_destino | VARCHAR(60) | Sim | NULL | Campo de texto de comprimento variável |
| id_sessao_usuario | BIGINT | Sim | NULL | Identificador da sessão de usuário ativa |
| sincronizado | TINYINT(1) | Sim | '0' | Campo numérico inteiro |
| versao_logica | BIGINT | Sim | '1' | Registro de auditoria ou log de sistema |
| criado_em | DATETIME(6) | Sim | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sync`

## Índices

- idx_sync_pendente: `sincronizado`, `criado_em`

## Constraints

- PRIMARY KEY em (`id_sync`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sincronizacao_federada_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Tabela operacional utilizada no fluxo de atendimento offline para armazenar dados específicos do domínio assistencial.
