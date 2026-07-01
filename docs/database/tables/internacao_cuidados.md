# internacao_cuidados

Objetivo: Registrar cuidados específicos prescritos para internações.

Descrição: Tabela que detalha cuidados de enfermagem prescritos durante internação, como decúbito, curativo, dreno, sonda, oxigênio e sinais vitais. Vinculada aos itens de prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do cuidado, chave primária auto incrementada |
| id_prescricao_item | bigint | NOT NULL | - | Referência ao item de prescrição ao qual o cuidado está vinculado |
| tipo_cuidado | enum('DECUBITO','CURATIVO','DRENO','SONDA','OXIGENIO','SINAIS_VITAIS') | DEFAULT NULL | - | Tipo de cuidado: decúbito, curativo, dreno, sonda, oxigênio ou sinais vitais |
| posicionamento | varchar(100) | DEFAULT NULL | - | Posicionamento recomendado (ex: dorso, lado esquerdo) |
| frequencia_checagem | int | DEFAULT NULL | - | Frequência de verificação em horas ou minutos |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fk_cuidado_presc (id_prescricao_item → prescricao_itens.id)

## Índices
- fk_cuidado_presc (id_prescricao_item)

## Constraints
- CONSTRAINT fk_cuidado_presc FOREIGN KEY (id_prescricao_item) REFERENCES prescricao_itens (id)

## Relacionamentos e Cardinalidade
- internacao_cuidados.id_prescricao_item → prescricao_itens (id): N:1 (vários cuidados podem referenciar o mesmo item de prescrição)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: prescricao_itens

## Fluxo de utilização dentro do sistema
1. Médico prescreve cuidado de enfermagem
2. Registro é criado vinculando ao item de prescrição
3. tipo_cuidado define o tipo (DECUBITO, CURATIVO, etc)
4. posicionamento especifica como deve ser feito
5. frequencia_checagem define periodicidade das verificações
6. Enfermeiro executa conforme prescrição