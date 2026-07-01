# prioridade_social

Objetivo: Definir categorias de prioridade social para pacientes em atendimentos, com peso de priorização baseado em vulnerabilidades específicas.

Descrição: Tabela que armazena categorias de prioridade social atribuídas a pacientes durante atendimentos, permitindo classificação baseada em vulnerabilidades como idoso, gestante, PCD, autista, etc. O peso atribuído a cada categoria influencia a priorização no fluxo de atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Chave primária da tabela, identificador único da categoria de prioridade |
| codigo | varchar(30) | NOT NULL | - | Código único que identifica a categoria de prioridade |
| descricao | varchar(100) | NOT NULL | - | Descrição da categoria de prioridade social |
| peso | int | NOT NULL | - | Peso numérico para priorização (quanto maior, mais prioritário) |
| ativo | tinyint(1) | - | '1' | Flag indicando se a categoria está ativa e pode ser utilizada |
| id_entidade | bigint unsigned | YES | NULL | Identificador da entidade/organização onde a prioridade é aplicada |

## Chaves
- Primária: id
- Únicas: codigo
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)
- UNIQUE KEY codigo (codigo)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com tabelas que utilizem categorias de prioridade social

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Cadastrada como categoria de prioridade social no sistema
- Vinculada a pacientes durante triagem ou atendimento
- O peso influencia a posição do paciente na fila de atendimento
- Categorias incluem: IDOSO, AUTISTA, PCD, GESTANTE, CRIANCACOLO