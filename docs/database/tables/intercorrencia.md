# intercorrencia

Objetivo: Registrar intercorrências ocorridas durante atendimentos e internações.

Descrição: Tabela que armazena intercorrências clínicas não planejadas que ocorrem durante atendimento ou internação, como complicações, reações adversas ou eventos não esperados. Controla gravidade e responsável pelo registro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_intercorrencia | bigint | NOT NULL | - | Identificador único da intercorrência, chave primária auto incrementada |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento onde a intercorrência ocorreu |
| id_internacao | bigint | DEFAULT NULL | - | Referência opcional à internação (se aplicável) |
| descricao | text | NOT NULL | - | Descrição detalhada da intercorrência |
| gravidade | enum('LEVE','MODERADA','GRAVE') | DEFAULT | 'LEVE' | Gravidade da intercorrência: leve, moderada ou grave |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que registrou a intercorrência |
| data_hora | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora da ocorrência |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_intercorrencia
- Únicas: -
- Estrangeiras: intercorrencia_ibfk_2 (id_internacao → internacao.id_internacao); intercorrencia_ibfk_3 (id_usuario → usuario.id_usuario)

## Índices
- id_usuario (id_usuario)
- idx_intercorrencia_atendimento (id_atendimento)
- idx_intercorrencia_internacao (id_internacao)

## Constraints
- CONSTRAINT intercorrencia_ibfk_2 FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT intercorrencia_ibfk_3 FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- intercorrencia.id_atendimento → atendimento (id_atendimento): N:1 (várias intercorrências podem referenciar o mesmo atendimento)
- intercorrencia.id_internacao → internacao (id_internacao): N:1 (várias intercorrências podem referenciar a mesma internação)
- intercorrencia.id_usuario → usuario (id_usuario): N:1 (várias intercorrências podem ser registradas pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, internacao, usuario

## Fluxo de utilização dentro do sistema
1. Usuário registra intercorrência durante atendimento ou internação
2. descricao detalha o que ocorreu
3. gravidade classifica o impacto (LEVE, MODERADA, GRAVE)
4. id_usuario identifica quem registrou o evento
5. data_hora marca o momento da ocorrência
6. Permite análise de segurança do paciente (PSI)