# paciente_alertas

Objetivo: Armazenar alertas clínicos importantes sobre pacientes (alergias, comorbidades, riscos).
Descrição: Tabela que registra alertas de saúde relevantes para o paciente, como alergias a medicamentos, comorbidades, riscos de infecção e precauções. Permite que profissionais de saúde tenham acesso rápido a informações críticas durante o atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do alerta (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o alerta está vinculado (pode ser paciente) |
| tipo_alerta | enum('ALERGIA','COMORBIDADE','RISCO_INFECCAO','PRECAUCAO_CONTATO') | YES | NULL | Tipo de alerta: alergia, comorbidade, risco de infecção ou precaução de contato |
| descricao | varchar(255) | NOT NULL | - | Descrição detalhada do alerta clínico |
| grau_severidade | enum('BAIXO','MODERADO','ALTO','CRITICO') | YES | NULL | Grau de severidade do alerta |
| data_registro | datetime | YES | CURRENT_TIMESTAMP | Data/hora do registro do alerta |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o alerta pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos alertas podem estar vinculados a uma pessoa/paciente

## Dependências
- Esta tabela depende de: saas_entidade (via id_entidade)
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para alertar profissionais sobre condições que requerem atenção especial durante o atendimento. Ao abrir um atendimento, os alertas do paciente são exibidos no dashboard clínico. Permite evitar erros como administrar medicamento ao qual o paciente é alérgico. Alertas são registrados uma vez e permanecem associados ao paciente.