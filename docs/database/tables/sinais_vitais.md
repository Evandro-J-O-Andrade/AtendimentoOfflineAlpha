# sinais_vitais

**Objetivo:** Registro de sinais vitais do paciente

**Descrição:** A tabela `sinais_vitais` armazena dados relacionados a registro de sinais vitais do paciente. Contém 11 colunas, com chave primária em `id_sinal`.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sinal | BIGINT | Não | NULL | Campo numérico inteiro |
| id_atendimento | BIGINT | Não | NULL | Identificador do atendimento |
| id_usuario | BIGINT | Não | NULL | Identificador do usuário do sistema |
| frequencia_cardiaca | INT | Sim | NULL | Campo numérico inteiro |
| pressao_sistolica | INT | Sim | NULL | Campo numérico inteiro |
| pressao_diastolica | INT | Sim | NULL | Campo numérico inteiro |
| temperatura | DECIMAL(4,2) | Sim | NULL | Campo numérico decimal |
| saturacao_o2 | INT | Sim | NULL | Campo numérico inteiro |
| dor | INT | Sim | NULL | Campo numérico inteiro |
| criado_em | DATETIME | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sinal`

## Índices

- fk_sinais_atendimento: `id_atendimento`

## Constraints

- PRIMARY KEY em (`id_sinal`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sinais_vitais` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Registra sinais vitais coletados durante o atendimento, triagem ou internação, servindo como base para classificação de risco e acompanhamento clínico.
