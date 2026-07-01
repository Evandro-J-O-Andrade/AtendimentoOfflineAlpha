# tv_rotativo_tela

**Objetivo:** Gestão de TVs rotativas de chamada

**Descrição:** A tabela `tv_rotativo_tela` armazena dados relacionados a gestão de tvs rotativas de chamada. Contém 9 colunas, com chave primária em `id_tela` e relaciona-se com outras tabelas via chaves estrangeiras (id_painel -> painel(id_painel)). Possui restrições de unicidade em: id_painel, ordem.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_tela | BIGINT | Não | NULL | Configuração ou identificador de tela |
| id_painel | BIGINT | Não | NULL | Campo numérico inteiro |
| codigo_tela | VARCHAR(50) | Não | NULL | Código de identificação do item |
| ordem | INT | Não | NULL | Campo numérico inteiro |
| duracao_seg | INT | Não | '120' | Campo numérico inteiro |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Sim | NULL | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_tela`
- **Únicas:**
  - uk_tv_rotativo: `id_painel`, `ordem`
- **Estrangeiras:**
  - fk_tv_rotativo_painel: `id_painel` -> `painel` (`id_painel`)

## Índices

- idx_tv_painel: `id_painel`

## Constraints

- FOREIGN KEY `fk_tv_rotativo_painel` em (`id_painel`) referencia `painel` (`id_painel`)
- UNIQUE KEY `uk_tv_rotativo` em (`id_painel, ordem`)
- PRIMARY KEY em (`id_tela`)

## Relacionamentos e Cardinalidade

- **tv_rotativo_tela -> painel:** Relacionamento 1:N via `id_painel` referenciando `painel`(`id_painel`)

## Dependências

- **Depende de:** `painel`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `tv_rotativo_tela` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia painéis de TV rotativa para exibição de chamadas e filas de atendimento, melhorando a experiência do paciente.
