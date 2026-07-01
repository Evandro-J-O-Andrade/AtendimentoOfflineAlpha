# ffa_substatus

Objetivo: Controlar substatus assistenciais detalhados dos episódios FFA.

Descrição: Tabela que armazena os substatus específicos de cada categoria de atendimento (medicação, farmácia, observação, exames) dentro de um episódio FFA. Permite o acompanhamento granular do andamento em cada área do atendimento assistencial.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do substatus, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual o substatus pertence |
| categoria | enum('MEDICACAO','FARMACIA','OBSERVACAO','RX','ECG','COLETA','OUTRO') | NOT NULL | - | Categoria do substatus: medicação, farmácia, observação, RX, ECG, coleta ou outro |
| status | varchar(50) | NOT NULL | - | Status específico dentro da categoria |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se o substatus está ativo |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| finalizado_em | datetime | DEFAULT NULL | - | Data e hora quando o substatus foi finalizado |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário responsável pelo substatus (pode ser NULL se deletado) |
| observacao | text | DEFAULT NULL | - | Observações complementares sobre o substatus |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: ffa_substatus_ibfk_2 (id_usuario → usuario.id_usuario ON DELETE SET NULL)

## Índices
- id_usuario (id_usuario)
- idx_ffa_categoria (id_ffa, categoria, ativo)

## Constraints
- CONSTRAINT ffa_substatus_ibfk_2 FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE SET NULL

## Relacionamentos e Cardinalidade
- ffa_substatus.id_ffa → ffa (id_ffa): N:1 (vários substatus podem pertencer ao mesmo FFA)
- ffa_substatus.id_usuario → usuario (id_usuario): N:1 (vários substatus podem ser atribuídos ao mesmo usuário, ou NULL)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa, usuario

## Fluxo de utilização dentro do sistema
1. Durante o atendimento FFA, substatus é criado para cada categoria (MEDICACAO, FARMACIA, etc)
2. Campo ativo controla se o substatus ainda está em vigor
3. Quando finalizado, finalizado_em é preenchido com timestamp
4. Usuário responsável pelo substatus é registrado
5. Permite acompanhamento detalhado do progresso em cada área do atendimento