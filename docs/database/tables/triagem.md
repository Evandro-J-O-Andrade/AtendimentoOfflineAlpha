# triagem

**Objetivo:** Registro de triagem de pacientes

**Descrição:** A tabela `triagem` armazena dados relacionados a registro de triagem de pacientes. Contém 9 colunas, com chave primária em `id_triagem` e relaciona-se com outras tabelas via chaves estrangeiras (id_atendimento -> atendimento(id_atendimento); id_entidade -> saas_entidade(id_entidade); id_risco -> classificacao_risco(id_risco); id_enfermeiro -> usuario(id_usuario)). Possui restrições de unicidade em: id_atendimento.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_triagem | BIGINT | Não | NULL | Dados de triagem |
| id_atendimento | BIGINT | Não | NULL | Identificador do atendimento |
| id_risco | INT | Não | NULL | Campo numérico inteiro |
| queixa | TEXT | Sim | NULL | Campo de texto longo |
| sinais_vitais | JSON | Sim | NULL | Dados estruturados em formato JSON |
| observacao | TEXT | Sim | NULL | Observações ou anotações adicionais |
| id_enfermeiro | BIGINT | Não | NULL | Campo numérico inteiro |
| data_hora | DATETIME | Sim | CURRENT_TIMESTAMP | Dados operacionais do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_triagem`
- **Únicas:**
  - uk_triagem_atendimento: `id_atendimento`
- **Estrangeiras:**
  - fk_triagem_atendimento: `id_atendimento` -> `atendimento` (`id_atendimento`)
  - fk_triagem_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)
  - triagem_ibfk_2: `id_risco` -> `classificacao_risco` (`id_risco`)
  - triagem_ibfk_3: `id_enfermeiro` -> `usuario` (`id_usuario`)

## Índices

- id_risco: `id_risco`
- id_enfermeiro: `id_enfermeiro`
- idx_tri_ent: `id_entidade`

## Constraints

- FOREIGN KEY `fk_triagem_atendimento` em (`id_atendimento`) referencia `atendimento` (`id_atendimento`)
- FOREIGN KEY `fk_triagem_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- FOREIGN KEY `triagem_ibfk_2` em (`id_risco`) referencia `classificacao_risco` (`id_risco`)
- FOREIGN KEY `triagem_ibfk_3` em (`id_enfermeiro`) referencia `usuario` (`id_usuario`)
- UNIQUE KEY `uk_triagem_atendimento` em (`id_atendimento`)
- PRIMARY KEY em (`id_triagem`)

## Relacionamentos e Cardinalidade

- **triagem -> atendimento:** Relacionamento 1:N via `id_atendimento` referenciando `atendimento`(`id_atendimento`)
- **triagem -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)
- **triagem -> classificacao_risco:** Relacionamento 1:N via `id_risco` referenciando `classificacao_risco`(`id_risco`)
- **triagem -> usuario:** Relacionamento 1:N via `id_enfermeiro` referenciando `usuario`(`id_usuario`)

## Dependências

- **Depende de:** `atendimento`, `saas_entidade`, `classificacao_risco`, `usuario`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `triagem` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Registra dados de triagem de pacientes na recepção, possibilitando classificação de risco e direcionamento para atendimento.
