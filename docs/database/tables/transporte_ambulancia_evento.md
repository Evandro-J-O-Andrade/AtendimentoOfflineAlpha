# transporte_ambulancia_evento

**Objetivo:** Gestão de transporte por ambulância

**Descrição:** A tabela `transporte_ambulancia_evento` armazena dados relacionados a gestão de transporte por ambulância. Contém 8 colunas, com chave primária em `id_evento` e relaciona-se com outras tabelas via chaves estrangeiras (id_transporte -> transporte_ambulancia(id)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_transporte | BIGINT | Não | NULL | Dados de transporte |
| evento | VARCHAR(80) | Não | NULL | Registro de evento ou ocorrência |
| detalhe | TEXT | Sim | NULL | Detalhes complementares do registro |
| id_usuario | BIGINT | Sim | NULL | Identificador do usuário do sistema |
| id_sessao_usuario | BIGINT | Sim | NULL | Identificador da sessão de usuário ativa |
| criado_em | DATETIME | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_evento`
- **Estrangeiras:**
  - fk_tae_transporte: `id_transporte` -> `transporte_ambulancia` (`id`)

## Índices

- idx_tae_transporte: `id_transporte`
- idx_tae_sessao: `id_sessao_usuario`

## Constraints

- FOREIGN KEY `fk_tae_transporte` em (`id_transporte`) referencia `transporte_ambulancia` (`id`)
- PRIMARY KEY em (`id_evento`)

## Relacionamentos e Cardinalidade

- **transporte_ambulancia_evento -> transporte_ambulancia:** Relacionamento 1:N via `id_transporte` referenciando `transporte_ambulancia`(`id`)

## Dependências

- **Depende de:** `transporte_ambulancia`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `transporte_ambulancia_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Controla solicitações e eventos de transporte de pacientes por ambulância, incluindo logística e rastreamento.
