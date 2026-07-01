# totem_senha_opcao

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `totem_senha_opcao` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 11 colunas, com chave primária em `id_opcao` e relaciona-se com outras tabelas via chaves estrangeiras (id_painel -> painel(id_painel)). Possui restrições de unicidade em: id_painel, codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_opcao | BIGINT | Não | NULL | Opção de senha ou atendimento |
| id_painel | BIGINT | Não | NULL | Campo numérico inteiro |
| codigo | VARCHAR(30) | Não | NULL | Código de identificação do item |
| label | VARCHAR(80) | Não | NULL | Campo de texto de comprimento variável |
| lane | VARCHAR(20) | Não | NULL | Campo de texto de comprimento variável |
| tipo_atendimento | VARCHAR(30) | Não | NULL | Classificação ou tipo do registro |
| prefixo | VARCHAR(5) | Sim | NULL | Campo de texto de comprimento variável |
| ordem | INT | Não | '1' | Campo numérico inteiro |
| ativo | TINYINT(1) | Não | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Sim | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_opcao`
- **Únicas:**
  - uk_totem_opcao: `id_painel`, `codigo`
- **Estrangeiras:**
  - fk_totem_opcao_painel: `id_painel` -> `painel` (`id_painel`)

## Índices

- idx_totem_opcao_painel: `id_painel`

## Constraints

- FOREIGN KEY `fk_totem_opcao_painel` em (`id_painel`) referencia `painel` (`id_painel`)
- UNIQUE KEY `uk_totem_opcao` em (`id_painel, codigo`)
- PRIMARY KEY em (`id_opcao`)

## Relacionamentos e Cardinalidade

- **totem_senha_opcao -> painel:** Relacionamento 1:N via `id_painel` referenciando `painel`(`id_painel`)

## Dependências

- **Depende de:** `painel`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `totem_senha_opcao` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.
