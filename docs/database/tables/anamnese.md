# anamnese

Objetivo: Armazenar o registro de anamnese clínica realizada durante um atendimento, contendo descrição e dados do profissional que a realizou.

Descrição: Esta tabela registra a anamnese clínica coletada durante atendimentos, permitindo o armazenamento da descrição completa da anamnese, vinculada ao atendimento, ao paciente e ao usuário que a realizou.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_anamnese | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de anamnese |
| id_atendimento | bigint unsigned | YES | NULL | Chave estrangeira que referencia o atendimento ao qual a anamnese está vinculada |
| descricao | text | YES | NULL | Texto completo da anamnese clínica coletada durante o atendimento |
| id_usuario | bigint | YES | NULL | Chave estrangeira que referencia o usuário que realizou a anamnese |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a anamnese foi registrada |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_anamnese
- Únicas: Nenhuma
- Estrangeiras: anamnese_ibfk_2 - id_usuario → usuario(id_usuario) - Vincula a anamnese ao usuário; fk_anamnese_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a anamnese ao atendimento

## Índices
- id_atendimento (KEY) - Índice para busca por atendimento
- id_usuario (KEY) - Índice para busca por usuário

## Constraints
- anamnese_ibfk_2 - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)
- fk_anamnese_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com RESTRICT em delete e CASCADE em update

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada anamnese está associada a um atendimento (com RESTRICT em delete)
- N:1 com usuario - Cada anamnese pode ter um usuário associado (opcional)

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para anamnese)
- Tabelas das quais esta depende: atendimento, usuario

## Fluxo de utilização dentro do sistema
- Registro digital da anamnese clínica durante atendimento
- Vinculação ao atendimento para contexto clínico completo
- Vinculação ao profissional que coletou a anamnese
- Timestamp automático para registrar quando a anamnese foi coletada
- CASCADE em update permite manter a anamnese quando atendimento é atualizado