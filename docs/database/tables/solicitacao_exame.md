# solicitacao_exame

**Objetivo:** Solicitações de exames médicos

**Descrição:** A tabela `solicitacao_exame` armazena dados relacionados a solicitações de exames médicos. Contém 8 colunas, com chave primária em `id_solicitacao` e relaciona-se com outras tabelas via chaves estrangeiras (id_exame -> exame(id_exame); id_medico -> medico(id_usuario)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_solicitacao | BIGINT | Não | NULL | Solicitação operacional |
| id_atendimento | BIGINT | Não | NULL | Identificador do atendimento |
| id_exame | INT | Sim | NULL | Identificador do exame |
| id_sigpat | BIGINT | Sim | NULL | Campo numérico inteiro |
| status | ENUM('SOLICITADO','COLETADO','EM_ANALISE','RESULTADO','CANCELADO') | Não | NULL | Status atual do registro no fluxo |
| id_medico | BIGINT | Sim | NULL | Campo numérico inteiro |
| solicitado_em | DATETIME | Não | NULL | Campo de data e/ou hora |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_solicitacao`
- **Estrangeiras:**
  - solicitacao_exame_ibfk_2: `id_exame` -> `exame` (`id_exame`)
  - solicitacao_exame_ibfk_3: `id_medico` -> `medico` (`id_usuario`)

## Índices

- id_atendimento: `id_atendimento`
- id_exame: `id_exame`
- id_medico: `id_medico`

## Constraints

- FOREIGN KEY `solicitacao_exame_ibfk_2` em (`id_exame`) referencia `exame` (`id_exame`)
- FOREIGN KEY `solicitacao_exame_ibfk_3` em (`id_medico`) referencia `medico` (`id_usuario`)
- PRIMARY KEY em (`id_solicitacao`)

## Relacionamentos e Cardinalidade

- **solicitacao_exame -> exame:** Relacionamento 1:N via `id_exame` referenciando `exame`(`id_exame`)
- **solicitacao_exame -> medico:** Relacionamento 1:N via `id_medico` referenciando `medico`(`id_usuario`)

## Dependências

- **Depende de:** `exame`, `medico`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `solicitacao_exame` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Tabela operacional utilizada no fluxo de atendimento offline para armazenar dados específicos do domínio assistencial.
