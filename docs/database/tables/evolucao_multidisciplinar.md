# evolucao_multidisciplinar

Objetivo: Registro de evoluções clínicas por profissional

Descrição: Registra evoluções de profissionais de diferentes áreas (multidisciplinar) vinculadas a atendimentos, preservando contexto do usuário e timestamp.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evolucao | bigint AUTO_INCREMENT | NO | — | Identificador único de evolucao |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| area | varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT | YES | NULL | Área profissional da evolução multidisciplinar |
| descricao | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | — | Descrição textual do registro |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Data e hora do evento |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evolucao
- Estrangeira (evolucao_multidisciplinar_ibfk_2): coluna id_usuario -> tabela usuario(id_usuario): Referencia a tabela usuario (coluna id_usuario) para garantir integridade referencial

## Indices

- id_atendimento (id_atendimento)
- id_usuario (id_usuario)

## Constraints

- FOREIGN KEY evolucao_multidisciplinar_ibfk_2: id_usuario references usuario(id_usuario)
- PRIMARY KEY (id_evolucao)

## Relacionamentos e Cardinalidade

- evolucao_multidisciplinar (1) -> usuario (1): campo id_usuario

## Dependencias

- Depende de:
  - usuario
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
