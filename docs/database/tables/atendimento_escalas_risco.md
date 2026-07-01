# atendimento_escalas_risco

Objetivo: Registrar avaliações em escalas de risco durante atendimentos, controlando o tipo de escala, pontuação e resultado da classificação.

Descrição: Esta tabela armazena as avaliações realizadas com escalas de risco clínicas durante atendimentos, permitindo o registro do tipo de escala (Morse, Braden, Glasgow), pontuação obtida e classificação do resultado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de escala de risco |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a escala pertence |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário que realizou a avaliação na escala |
| escala_tipo | enum('MORSE_QUEDA','BRADEN_LESÃO_PELE','GLASGOW') | YES | NULL | Tipo de escala de risco: Morse (queda), Braden (lesão de pele) ou Glasgow (nível de consciência) |
| pontuacao_total | int | NOT NULL | - | Pontuação total obtida na avaliação da escala |
| classificacao_resultado | varchar(100) | YES | NULL | Classificação/texto do resultado da avaliação (ex: "Baixo risco", "Moderado", "Severo") |
| data_avaliacao | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora da avaliação |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_escalas_risco_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a escala ao atendimento; fk_atendimento_escalas_risco_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a escala à entidade

## Índices
- fk_escala_atend (KEY) - Índice para busca por atendimento
- idx_aescr_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_escalas_risco_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_escalas_risco_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada avaliação em escala está associada a um atendimento
- N:1 com saas_entidade - Cada avaliação pertence a uma entidade SaaS
- N:1 com usuario - Cada avaliação é realizada por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_escalas_risco)
- Tabelas das quais esta depende: atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
- Avaliação de risco em escalas validadas (Morse, Braden, Glasgow)
- Registro da pontuação total para histórico clínico
- Classificação automática ou manual do resultado da avaliação
- Vinculação ao atendimento e usuário para auditoria
- Timestamp automático da data da avaliação
- Índice para busca eficiente por atendimento