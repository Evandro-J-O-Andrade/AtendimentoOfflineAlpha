# servico_agendamento

**Objetivo:** Agendamento de serviços assistenciais

**Descrição:** A tabela `servico_agendamento` armazena dados relacionados a agendamento de serviços assistenciais. Contém 13 colunas, com chave primária em `id_servico` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade); id_sistema -> sistema(id_sistema)). Possui restrições de unicidade em: id_sistema, id_unidade, codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_servico | BIGINT | Não | NULL | Campo numérico inteiro |
| id_sistema | BIGINT | Não | NULL | Campo numérico inteiro |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| codigo | VARCHAR(50) | Não | NULL | Código de identificação do item |
| nome | VARCHAR(120) | Não | NULL | Nome ou descrição do item |
| duracao_minutos | INT | Não | '15' | Campo numérico inteiro |
| categoria | VARCHAR(30) | Sim | NULL | Campo de texto de comprimento variável |
| tipo | ENUM('CONSULTA','PROCEDIMENTO','EXAME','RETORNO','OUTRO') | Não | 'CONSULTA' | Classificação ou tipo do registro |
| exige_profissional | TINYINT(1) | Não | '1' | Identificador do profissional de saúde |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Não | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_servico`
- **Únicas:**
  - uk_servico_ctx_codigo: `id_sistema`, `id_unidade`, `codigo`
- **Estrangeiras:**
  - fk_servico_agendamento_unidade: `id_unidade` -> `unidade` (`id_unidade`)
  - fk_servico_sistema: `id_sistema` -> `sistema` (`id_sistema`)

## Índices

- ix_servico_ctx: `id_sistema`, `id_unidade`
- fk_servico_unidade: `id_unidade`

## Constraints

- FOREIGN KEY `fk_servico_agendamento_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- FOREIGN KEY `fk_servico_sistema` em (`id_sistema`) referencia `sistema` (`id_sistema`)
- UNIQUE KEY `uk_servico_ctx_codigo` em (`id_sistema, id_unidade, codigo`)
- PRIMARY KEY em (`id_servico`)

## Relacionamentos e Cardinalidade

- **servico_agendamento -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)
- **servico_agendamento -> sistema:** Relacionamento 1:N via `id_sistema` referenciando `sistema`(`id_sistema`)

## Dependências

- **Depende de:** `unidade`, `sistema`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `servico_agendamento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Controla agendamentos e disponibilidade de serviços assistenciais, integrando-se com agendas de profissionais e alocação de recursos.
