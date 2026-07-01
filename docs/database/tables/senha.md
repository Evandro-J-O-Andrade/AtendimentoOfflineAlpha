# senha

**Objetivo:** Gestão de senhas, eventos, sequências e transições de status

**Descrição:** A tabela `senha` armazena dados relacionados a gestão de senhas, eventos, sequências e transições de status. Contém 15 colunas, com chave primária em `id_senha` e relaciona-se com outras tabelas via chaves estrangeiras (id_entidade -> saas_entidade(id_entidade); id_ffa -> ffa(id_ffa); id_unidade -> unidade(id_unidade)).

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_senha | BIGINT | Não | NULL | Senha ou hash de senha |
| id_unidade | BIGINT | Não | NULL | Identificador da unidade de saúde |
| codigo_visual | VARCHAR(10) | Não | NULL | Código de identificação do item |
| id_paciente | BIGINT | Sim | NULL | Identificador do paciente associado |
| origem_entrada | ENUM('RECEPCAO','AGENDAMENTO','UBS','SAMU','TRANSFERENCIA','REGULACAO','FARMACIA','OUTRO') | Não | 'RECEPCAO' | Campo de enumeração com valores predefinidos |
| id_prioridade | BIGINT | Não | '1' | Campo numérico inteiro |
| id_fluxo_status | BIGINT | Não | '1' | Status atual do registro no fluxo |
| id_sessao_usuario | BIGINT | Sim | NULL | Identificador da sessão de usuário ativa |
| criado_em | DATETIME(6) | Não | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | DATETIME(6) | Sim | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data e hora da última atualização do registro |
| uuid_sync | CHAR(36) | Não | NULL | Identificador único universal (UUID) para rastreamento distribuído |
| versao_sync | BIGINT | Sim | '0' | Campo numérico inteiro |
| hash_estado | CHAR(64) | Sim | NULL | Hash criptográfico para validação de integridade |
| id_ffa | BIGINT | Sim | NULL | Campo numérico inteiro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_senha`
- **Estrangeiras:**
  - fk_senha_entidade: `id_entidade` -> `saas_entidade` (`id_entidade`)
  - fk_senha_ffa: `id_ffa` -> `ffa` (`id_ffa`)
  - fk_senha_unidade: `id_unidade` -> `unidade` (`id_unidade`)

## Índices

- idx_senha_paciente: `id_paciente`
- idx_senha_origem: `origem_entrada`
- fk_senha_unidade: `id_unidade`
- fk_senha_ffa: `id_ffa`
- idx_senha_entidade_unidade: `id_entidade`, `id_unidade`

## Constraints

- FOREIGN KEY `fk_senha_entidade` em (`id_entidade`) referencia `saas_entidade` (`id_entidade`)
- FOREIGN KEY `fk_senha_ffa` em (`id_ffa`) referencia `ffa` (`id_ffa`)
- FOREIGN KEY `fk_senha_unidade` em (`id_unidade`) referencia `unidade` (`id_unidade`)
- PRIMARY KEY em (`id_senha`)

## Relacionamentos e Cardinalidade

- **senha -> saas_entidade:** Relacionamento 1:N via `id_entidade` referenciando `saas_entidade`(`id_entidade`)
- **senha -> ffa:** Relacionamento 1:N via `id_ffa` referenciando `ffa`(`id_ffa`)
- **senha -> unidade:** Relacionamento 1:N via `id_unidade` referenciando `unidade`(`id_unidade`)

## Dependências

- **Depende de:** `saas_entidade`, `ffa`, `unidade`
- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `senha` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Gerencia o ciclo de vida de senhas de usuários e senhas de fluxo operacional, incluindo sequências, transições de status e eventos de auditoria.
