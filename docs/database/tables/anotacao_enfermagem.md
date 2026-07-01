# anotacao_enfermagem

Objetivo: Registrar anotações de enfermagem durante internações, permitindo o registro de informações clínicas e observações do enfermeiro.

Descrição: Esta tabela armazena anotações realizadas pela equipe de enfermagem durante internações hospitalares, vinculadas ao internamento, ao usuário enfermeiro responsável e contendo descrição detalhada das observações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_anotacao | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da anotação de enfermagem |
| id_internacao | bigint | NOT NULL | - | Chave estrangeira que referencia o internamento ao qual a anotação está vinculada |
| descricao | text | NOT NULL | - | Texto completo da anotação de enfermagem com observações clínicas |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário (enfermeiro) que realizou a anotação |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a anotação foi registrada |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_anotacao
- Únicas: Nenhuma
- Estrangeiras: anotacao_enfermagem_ibfk_1 - id_internacao → internacao(id_internacao) - Vincula a anotação ao internamento; anotacao_enfermagem_ibfk_2 - id_usuario → usuario(id_usuario) - Vincula a anotação ao enfermeiro

## Índices
- id_internacao (KEY) - Índice para busca por internamento
- id_usuario (KEY) - Índice para busca por usuário

## Constraints
- anotacao_enfermagem_ibfk_1 - FOREIGN KEY - Restringe id_internacao à tabela internacao(id_internacao)
- anotacao_enfermagem_ibfk_2 - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com internacao - Cada anotação está associada a um internamento específico
- N:1 com usuario - Cada anotação é realizada por um único enfermeiro/usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para anotacao_enfermagem)
- Tabelas das quais esta depende: internacao, usuario

## Fluxo de utilização dentro do sistema
- Registro de observações de enfermagem durante internação
- Vinculação ao internamento para contexto clínico
- Vinculação ao enfermeiro responsável pela anotação
- Timestamp automático para auditoria de quando a anotação foi feita
- Índices para busca rápida por internamento ou enfermeiro