# plantao_modelo

Objetivo: Definir modelos padrão de plantões (horários e duração).
Descrição: Tabela que mantém os modelos de plantão com horários padrão (início, fim) e duração prevista, permitindo reutilizar configurações comuns.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_plantao_modelo | bigint | NOT NULL | - | Identificador único do modelo (chave primária, auto incremento) |
| nome | varchar(100) | NOT NULL | - | Nome do modelo (ex: "Plantão 12x36", "Plantão 8h") |
| inicio | time | NOT NULL | - | Hora de início padrão do plantão |
| fim | time | NOT NULL | - | Hora de fim padrão do plantão |
| atravessa_dia | tinyint(1) | YES | '0' | Flag indicando se o plantão atravessa para o dia seguinte (ex: 22h a 6h) |
| horas_previstas | decimal(6,2) | YES | NULL | Número de horas previstas para o plantão |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o modelo está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do modelo |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o modelo pertence |

## Chaves
- Primária: id_plantao_modelo
- Únicas: uk_plantao_modelo_nome (nome)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_plantao_modelo)
- UNIQUE KEY uk_plantao_modelo_nome (nome)

## Constraints
- PRIMARY KEY: id_plantao_modelo
- UNIQUE: uk_plantao_modelo_nome

## Relacionamentos e Cardinalidade
- 1:N com plantao_escala: Um modelo pode ser usado por muitas escalas

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: plantao_escala

## Fluxo de utilização dentro do sistema
Utilizada para padronizar modelos de plantão comuns. Quando criando escalas, pode-se selecionar um modelo já existente (ex: "Plantão 12x36" com horário 7h a 19h). O campo atravessa_dia indica plantões noturnos ou que ultrapassam a meia-noite. Permite evitar digitação repetitiva de horários.