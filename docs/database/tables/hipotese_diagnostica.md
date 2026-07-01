# hipotese_diagnostica

Objetivo: Registrar hipóteses diagnósticas dos atendimentos.

Descrição: Tabela que armazena as hipóteses diagnósticas registradas durante atendimentos, com CID-10, indicação de principal/não principal e médico responsável. Utilizada para documentação do diagnóstico clínico.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_hipotese | bigint | NOT NULL | - | Identificador único da hipótese, chave primária auto incrementada |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento onde a hipótese foi formulada |
| cid10 | varchar(10) | DEFAULT NULL | - | Código CID-10 da doença diagnosticada |
| principal | tinyint(1) | DEFAULT | '0' | Indicador se é a hipótese principal (0=não, 1=sim) |
| id_medico | bigint | DEFAULT NULL | - | Referência ao médico que formulou a hipótese |
| data_hora | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora do diagnóstico |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_hipotese
- Únicas: -
- Estrangeiras: hipotese_diagnostica_ibfk_2 (id_medico → medico.id_usuario)

## Índices
- id_atendimento (id_atendimento)
- id_medico (id_medico)

## Constraints
- CONSTRAINT hipotese_diagnostica_ibfk_2 FOREIGN KEY (id_medico) REFERENCES medico (id_usuario)

## Relacionamentos e Cardinalidade
- hipotese_diagnostica.id_atendimento → atendimento (id_atendimento): N:1 (várias hipóteses podem referenciar o mesmo atendimento)
- hipotese_diagnostica.id_medico → medico (id_usuario): N:1 (várias hipóteses podem ser feitas pelo mesmo médico)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, medico

## Fluxo de utilização dentro do sistema
1. Médico registra hipótese diagnóstica durante atendimento
2. cid10 é preenchido com código da doença
3. principal indica se é o diagnóstico principal
4. data_hora registra quando foi formulado
5. Permite histórico completo de diagnósticos por atendimento