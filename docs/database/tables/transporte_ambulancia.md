# transporte_ambulancia

**Objetivo:** Gestão de transporte por ambulância

**Descrição:** A tabela `transporte_ambulancia` armazena dados relacionados a gestão de transporte por ambulância. Contém 9 colunas, com chave primária em `id`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | BIGINT | Não | NULL | Identificador único da linha na tabela transporte_ambulancia |
| id_senha | BIGINT | Não | NULL | Senha ou hash de senha |
| placa_veiculo | VARCHAR(10) | Sim | NULL | Campo de texto de comprimento variável |
| condutor_nome | VARCHAR(100) | Sim | NULL | Nome ou descrição do item |
| tipo_equipe | ENUM('BASICA','AVANCADA','AEREA') | Sim | NULL | Classificação ou tipo do registro |
| km_saida | INT | Sim | NULL | Campo numérico inteiro |
| km_chegada | INT | Sim | NULL | Campo numérico inteiro |
| data_hora_acionamento | DATETIME | Sim | CURRENT_TIMESTAMP | Dados operacionais do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id`

## Índices

- fk_samu_senha: `id_senha`

## Constraints

- PRIMARY KEY em (`id`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `transporte_ambulancia` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Controla solicitações e eventos de transporte de pacientes por ambulância, incluindo logística e rastreamento.
