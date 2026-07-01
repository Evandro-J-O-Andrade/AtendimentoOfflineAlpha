# evolucao_enfermagem

Objetivo: Registro de evoluções clínicas por profissional

Descrição: Registra evoluções de enfermagem durante internações, com descrição textual, identificação do profissional e data/hora.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evolucao | bigint AUTO_INCREMENT | NO | — | Identificador único de evolucao |
| id_internacao | bigint | NO | — | Identificador da internação |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Descrição textual do registro |
| id_enfermeiro | bigint | NO | — | Identificador único de enfermeiro |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Data e hora do evento |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evolucao
- Estrangeira (evolucao_enfermagem_ibfk_1): coluna id_internacao -> tabela internacao(id_internacao): Referencia a tabela internacao (coluna id_internacao) para garantir integridade referencial
- Estrangeira (evolucao_enfermagem_ibfk_2): coluna id_enfermeiro -> tabela usuario(id_usuario): Referencia a tabela usuario (coluna id_usuario) para garantir integridade referencial

## Indices

- id_internacao (id_internacao)
- id_enfermeiro (id_enfermeiro)

## Constraints

- FOREIGN KEY evolucao_enfermagem_ibfk_1: id_internacao references internacao(id_internacao)
- FOREIGN KEY evolucao_enfermagem_ibfk_2: id_enfermeiro references usuario(id_usuario)
- PRIMARY KEY (id_evolucao)

## Relacionamentos e Cardinalidade

- evolucao_enfermagem (1) -> internacao (1): campo id_internacao
- evolucao_enfermagem (1) -> usuario (1): campo id_enfermeiro

## Dependencias

- Depende de:
  - internacao
  - usuario
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
