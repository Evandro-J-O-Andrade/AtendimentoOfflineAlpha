# sinan_notificacao

**Objetivo:** Integração com sistema SINAN de notificações epidemiológicas

**Descrição:** A tabela `sinan_notificacao` armazena dados relacionados a integração com sistema sinan de notificações epidemiológicas. Contém 10 colunas, com chave primária em `id_sinan`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sinan | BIGINT | Não | NULL | Campo numérico inteiro |
| id_ffa | BIGINT | Não | NULL | Campo numérico inteiro |
| id_gpat | BIGINT | Não | NULL | Campo numérico inteiro |
| id_usuario_responsavel | BIGINT | Não | NULL | Identificador do usuário do sistema |
| tipo_notificacao | VARCHAR(80) | Não | NULL | Classificação ou tipo do registro |
| status | ENUM('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') | Não | 'ABERTA' | Status atual do registro no fluxo |
| payload_json | JSON | Sim | NULL | Dados estruturados em formato JSON |
| criado_em | DATETIME | Não | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | DATETIME | Sim | NULL | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sinan`

## Índices

- ix_sinan_ffa: `id_ffa`
- ix_sinan_gpat: `id_gpat`
- ix_sinan_status: `status`

## Constraints

- PRIMARY KEY em (`id_sinan`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sinan_notificacao` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Integração com o Sistema de Informação de Agravos de Notificação (SINAN), registrando eventos e notificações de doenças e agravos de notificação compulsória.
