# plantao

Objetivo: Registrar plantões (horas trabalhadas) de profissionais.
Descrição: Tabela que mantém o registro de plantões de profissionais em determinados locais, com tipos de plantão (clínico, pediatria, emergência), horários de início e fim.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_plantao | bigint | NOT NULL | - | Identificador único do plantão (chave primária, auto incremento) |
| id_unidade | bigint unsigned | NOT NULL | - | ID da unidade onde o plantão ocorre |
| id_local | bigint | YES | NULL | ID do local específico dentro da unidade |
| id_funcionario | bigint | NOT NULL | - | ID do funcionário/profissional que está de plantão |
| tipo_plantao | enum('CLINICO','PEDIATRIA','EMERGENCIA','ADMINISTRATIVO','OUTRO') | NOT NULL | - | Tipo de plantão: clínico, pediatria, emergência, administrativo ou outro |
| inicio_plantao | datetime | NOT NULL | - | Data/hora de início do plantão |
| fim_plantao | datetime | NOT NULL | - | Data/hora de fim do plantão |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o plantão está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o plantão pertence |

## Chaves
- Primária: id_plantao
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_plantao_funcionario: id_funcionario → funcionario (id_funcionario) com RESTRICT
  - fk_plantao_local: id_local → local (id_local) com SET NULL
  - fk_plantao_unidade: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id_plantao)
- KEY idx_plantao_global (id_unidade, ativo, inicio_plantao, fim_plantao)
- KEY idx_plantao_funcionario (id_funcionario)
- KEY idx_plantao_local (id_local)

## Constraints
- PRIMARY KEY: id_plantao
- FOREIGN KEY: fk_plantao_funcionario
- FOREIGN KEY: fk_plantao_local
- FOREIGN KEY: fk_plantao_unidade

## Relacionamentos e Cardinalidade
- N:1 com unidade: Muitos plantões pertencem a uma unidade
- N:1 com local: Muitos plantões ocorrem em um local
- N:1 com funcionario: Muitos plantões são realizados por um funcionário

## Dependências
- Esta tabela depende de: unidade, local, funcionario, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar e controlar os plantões dos profissionais. Permite saber quem está de plantão em cada unidade e horário. O sistema de painel exibe quem está de plantão. Permite gerar escalas, controle de horas trabalhadas e identificar profissionais disponíveis.