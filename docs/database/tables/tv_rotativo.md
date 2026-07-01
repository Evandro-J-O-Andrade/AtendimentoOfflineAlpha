# tv_rotativo

**Objetivo:** Gestão de TVs rotativas de chamada

**Descrição:** A tabela `tv_rotativo` armazena dados relacionados a gestão de tvs rotativas de chamada. Contém 10 colunas, com chave primária em `id_tv_rotativo` e relaciona-se com outras tabelas via chaves estrangeiras (id_unidade -> unidade(id_unidade)). Possui restrições de unicidade em: nome.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tv_rotativo | BIGINT | Não | NULL | Indica se o registro está ativo (1) ou inativo (0) |
| nome | VARCHAR(80) | Não | NULL | Nome ou descrição do item |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| intervalo_seg | INT | Não | '120' | Campo numérico inteiro |
| ativo | TINYINT | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| criado_por | BIGINT | Sim | NULL | Campo numérico inteiro |
| atualizado_em | DATETIME | Sim | NULL | Data e hora da última atualização do registro |
| atualizado_por | BIGINT | Sim | NULL | Campo numérico inteiro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tv_rotativo`
- **Únicas:**
  - uk_tv_rotativo_nome: `nome`
- **Estrangeiras:**
  - fk_tv_rotativo_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- fk_tv_rotativo_unidade: `id_unidade`

## Constraints

- FOREIGN KEY `fk_tv_rotativo_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- UNIQUE KEY `uk_tv_rotativo_nome` em (`nome`)
- PRIMARY KEY em (`id_tv_rotativo`)

## Relacionamentos e Cardinalidade

- **tv_rotativo -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tv_rotativo` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia painéis de TV rotativa para exibição de chamadas e filas de atendimento, melhorando a experiência do paciente.
