# classificacao_risco

Objetivo: Definir níveis de classificação de risco para atendimentos assistenciais.
Descrição: Tabela que estabelece as cores e tempos máximos para classificação de risco no atendimento, usada para triagem e priorização de pacientes.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_risco | int | NOT NULL | - | Identificador único da classificação, chave primária auto incrementada. |
| cor | enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') | Nullable | - | Cor da classificação: vermelho, laranja, amarelo, verde ou azul. |
| tempo_max | int | Nullable | - | Tempo máximo em minutos para atendimento nesta classificação. |
| descricao | varchar(100) | Nullable | - | Descrição da classificação (ex: Emergência, Urgência, Pouco Urgente). |
| id_entidade | bigint unsigned | Nullable | NULL | Referência à entidade (pode ser nulo para configuração global). |

## Chaves
- Primária: id_risco
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_risco)

## Constraints
- PRIMARY KEY: id_risco

## Relacionamentos e Cardinalidade
- 1:N com saas_entidade (id_entidade) - opcional
- Referenciada por sistemas de triagem para classificação de pacientes

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: saas_entidade (opcional)

## Fluxo de utilização dentro do sistema
- Usada na triagem para classificar risco do paciente
- Tempo máximo guia SLA de atendimento
- Cores padrão (Vermelho=Emergência, Amarelo=Urgência, Verde=Pouco Urgente)
- Configuração pode ser específica por entidade ou global
- Integrada ao sistema de filas para priorização automática