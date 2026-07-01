# sinan_evento

**Objetivo:** Integração com sistema SINAN de notificações epidemiológicas

**Descrição:** A tabela `sinan_evento` armazena dados relacionados a integração com sistema sinan de notificações epidemiológicas. Contém 7 colunas, com chave primária em `id_sinan_evento`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sinan_evento | BIGINT | Não | NULL | Registro de evento ou ocorrência |
| id_sinan | BIGINT | Não | NULL | Campo numérico inteiro |
| id_sessao_usuario | BIGINT | Não | NULL | Identificador da sessão de usuário ativa |
| evento | VARCHAR(50) | Não | NULL | Registro de evento ou ocorrência |
| payload_json | JSON | Sim | NULL | Dados estruturados em formato JSON |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sinan_evento`

## Índices

- ix_sinan_evento_sinan: `id_sinan`
- ix_sinan_evento_evt: `evento`

## Constraints

- PRIMARY KEY em (`id_sinan_evento`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sinan_evento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Integração com o Sistema de Informação de Agravos de Notificação (SINAN), registrando eventos e notificações de doenças e agravos de notificação compulsória.
