# atendimento_anamnese

Objetivo: Registrar a anamnese clínica detalhada realizada durante um atendimento, contendo informações históricas e descritivas do paciente.

Descrição: Esta tabela armazena a anamnese completa do paciente durante atendimentos, incluindo queixa principal, histórico de doenças, antecedentes pessoais, com auditoria de criação e informações de dispositivo/IP.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de anamnese no atendimento |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde a anamnese foi realizada |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o registro pertence |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário que realizou a anamnese |
| id_sessao_usuario | bigint | NOT NULL | - | Identificador da sessão do usuário no momento da anamnese |
| queixa_principal | text | YES | NULL | Campo de texto livre com a queixa principal relatada pelo paciente |
| historico_doenca | text | YES | NULL | Histórico de doenças prévias do paciente |
| antecedentes_pessoais | text | YES | NULL | Antecedentes pessoais relevantes do paciente |
| ip_origem | varchar(45) | YES | NULL | Endereço IP de origem da requisição que criou a anamnese |
| device_info | varchar(255) | YES | NULL | Informações do dispositivo utilizado no momento da anamnese |
| criado_em | datetime(6) | YES | NULL | Timestamp da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a anamnese pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_aanam_unid - id_unidade → unidade(id_unidade) - Vincula a anamnese à unidade; fk_anamnese_atend - id_atendimento → atendimento(id_atendimento) - Vincula a anamnese ao atendimento; fk_atendimento_anamnese_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a anamnese ao atendimento; fk_atendimento_anamnese_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a anamnese à entidade

## Índices
- idx_ffa (KEY) - Índice para busca por FFA
- fk_atendimento_anamnese_atendimento (KEY) - Índice para busca por atendimento
- fk_aanam_unid (KEY) - Índice para busca por unidade
- fk_atendimento_anamnese_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_aanam_unid - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)
- fk_anamnese_atend - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com RESTRICT em delete e CASCADE em update
- fk_atendimento_anamnese_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_anamnese_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada anamnese está associada a uma unidade
- N:1 com atendimento - Cada anamnese está associada a um atendimento (múltiplas constraints)
- N:1 com saas_entidade - Cada anamnese pertence a uma entidade SaaS
- N:1 com usuario - Cada anamnese é realizada por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_anamnese)
- Tabelas das quais esta depende: unidade, atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
- Registro completo da anamnese clínica durante o atendimento
- Queixa principal, histórico e antecedentes para história clínica completa
- Auditoria de IP e dispositivo para rastreio de origem dos registros
- Vinculação ao atendimento via múltiplas constraints para garantia de integridade
- Índice para busca eficiente por FFA e atendimento