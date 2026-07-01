# internacao_braden_avaliacao

Objetivo: Registrar avaliações de risco de úlcera por pressão (escore de Braden).

Descrição: Tabela que armazena avaliações do escore de Braden para pacientes internados, incluindo os 6 fatores (percepção sensorial, umidade, atividade, mobilidade, nutrição, fricção/cisalhamento) e cálculo do score total e risco. Utilizada para prevenção de úlceras de pressão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_internacao_braden_avaliacao | bigint | NOT NULL | - | Identificador único da avaliação, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação avaliada |
| data_hora | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora da avaliação |
| percepcao_sensorial | tinyint | NOT NULL | - | Pontuação de percepção sensorial (1-4) |
| umidade | tinyint | NOT NULL | - | Pontuação de umidade (1-4) |
| atividade | tinyint | NOT NULL | - | Pontuação de atividade (1-4) |
| mobilidade | tinyint | NOT NULL | - | Pontuação de mobilidade (1-4) |
| nutricao | tinyint | NOT NULL | - | Pontuação de nutrição (1-4) |
| friccao_cisalhamento | tinyint | NOT NULL | - | Pontuação de fricção/cisalhamento (1-3) |
| score_total | tinyint | NOT NULL | - | Score total calculado (6-23) |
| risco | enum('SEM_RISCO','LEVE','MODERADO','ALTO','MUITO_ALTO') | NOT NULL | - | Classificação de risco baseada no score: sem risco, leve, moderado, alto ou muito alto |
| observacoes | text | DEFAULT NULL | - | Observações sobre a avaliação |
| id_documento | bigint | DEFAULT NULL | - | Referência ao documento gerado |
| id_usuario_responsavel | bigint | NOT NULL | - | Referência ao usuário que realizou a avaliação |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_internacao_braden_avaliacao
- Únicas: -
- Estrangeiras: fk_iba_documento (id_documento → documento_emissao.id_documento); fk_iba_internacao (id_internacao → internacao.id_internacao); fk_iba_usuario (id_usuario_responsavel → usuario.id_usuario)

## Índices
- idx_iba_internacao (id_internacao)
- idx_iba_data_hora (data_hora)
- idx_iba_usuario (id_usuario_responsavel)
- idx_iba_sessao (id_sessao_usuario)
- idx_iba_documento (id_documento)

## Constraints
- CONSTRAINT fk_iba_documento FOREIGN KEY (id_documento) REFERENCES documento_emissao (id_documento)
- CONSTRAINT fk_iba_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)
- CONSTRAINT fk_iba_usuario FOREIGN KEY (id_usuario_responsavel) REFERENCES usuario (id_usuario)
- CONSTRAINT chk_iba_at CHECK (atividade between 1 and 4)
- CONSTRAINT chk_iba_fc CHECK (friccao_cisalhamento between 1 and 3)
- CONSTRAINT chk_iba_mo CHECK (mobilidade between 1 and 4)
- CONSTRAINT chk_iba_nu CHECK (nutricao between 1 and 4)
- CONSTRAINT chk_iba_ps CHECK (percepcao_sensorial between 1 and 4)
- CONSTRAINT chk_iba_total CHECK (score_total between 6 and 23)

## Relacionamentos e Cardinalidade
- internacao_braden_avaliacao.id_internacao → internacao (id_internacao): N:1 (várias avaliações podem referenciar a mesma internação)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, usuario, documento_emissao

## Fluxo de utilização dentro do sistema
1. Enfermeiro avalia paciente internado com escala de Braden
2. Cada fator é pontuado (percepção sensorial, umidade, atividade, mobilidade, nutrição, fricção)
3. Score total é calculado automaticamente (mínimo 6, máximo 23)
4. risco é classificado com base no score
5. CHECK constraints garantem valores válidos
6. Histórico é mantido para acompanhamento de risco