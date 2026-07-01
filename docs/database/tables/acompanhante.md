# acompanhante

Objetivo: Armazenar informações sobre pessoas que acompanham um paciente durante um atendimento ou FFA (Ficha de Atendimento), classificando seu tipo de vínculo com o paciente.

Descrição: Esta tabela registra os acompanhantes de pacientes no sistema de atendimento, vinculando pessoas físicas (pais, mães, responsáveis legais, acompanhantes ou outros) a um FFA específico, com controle de observações e status ativo/inativo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_acompanhante | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de acompanhante |
| id_pessoa | bigint | NOT NULL | - | Chave estrangeira que referencia a pessoa que é o acompanhante, vinculada à tabela pessoa |
| id_ffa | bigint | NOT NULL | - | Identificador do FFA (Ficha de Atendimento) ao qual o acompanhante está vinculado |
| tipo | enum('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO') | NOT NULL | - | Classificação do tipo de vínculo do acompanhante com o paciente: pai, mãe, responsável legal, acompanhante ou outro |
| observacao | varchar(255) | YES | NULL | Campo de texto livre para observações adicionais sobre o acompanhante |
| ativo | tinyint(1) | YES | '1' | Flag que indica se o registro de acompanhante está ativo (1) ou inativo (0) |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_acompanhante
- Únicas: uk_acompanhante_por_ffa (id_pessoa, id_ffa)
- Estrangeiras: acompanhante_ibfk_1 - id_pessoa → pessoa(id_pessoa) - Vincula o acompanhante a uma pessoa registrada no sistema

## Índices
- id_ffa (KEY)

## Constraints
- uk_acompanhante_por_ffa - UNIQUE - Garante que uma mesma pessoa não seja registrada como acompanhante mais de uma vez para o mesmo FFA
- acompanhante_ibfk_1 - FOREIGN KEY - Restringe id_pessoa à tabela pessoa(id_pessoa)

## Relacionamentos e Cardinalidade
- 1:1 com pessoa - Cada acompanhante está vinculado a uma pessoa específica
- N:1 com FFA - Um FFA pode ter múltiplos acompanhantes, mas cada acompanhante está associado a apenas um FFA

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para acompanhante)
- Tabelas das quais esta depende: pessoa (via id_pessoa)

## Fluxo de utilização dentro do sistema
- Registro de acompanhantes no início do atendimento
- Classificação do vínculo familiar ou responsável pelo paciente
- Controle de acompanhantes ativos para acompanhamento durante o atendimento
- Uso do campo observacao para registrar informações relevantes sobre o acompanhante
- Identificação única via UK para prevenir duplicação de registros