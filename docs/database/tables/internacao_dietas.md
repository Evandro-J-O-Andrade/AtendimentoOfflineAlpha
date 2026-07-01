# internacao_dietas

Objetivo: Registrar dietas prescritas durante internações.

Descrição: Tabela que detalha as dietas médicas prescritas para pacientes internados, incluindo consistência da dieta e restrições alimentares. Vinculada aos itens de prescrição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da dieta, chave primária auto incrementada |
| id_prescricao_item | bigint | NOT NULL | - | Referência ao item de prescrição ao qual a dieta está vinculada |
| consistencia | enum('LIVRE','BRANDAS','PASTOSA','LIQUIDA','ZERO','ENTERAL','PARENTERAL') | DEFAULT NULL | - | Consistência da dieta: líquida, pastosa, brandas, zero, enteral ou parenteral |
| restricao | varchar(255) | DEFAULT NULL | - | Restrições específicas (ex: sem sal, sem lactose) |
| volume_total_dia | int | DEFAULT NULL | - | Volume total diário em mL ou outra unidade |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fk_dieta_presc (id_prescricao_item → prescricao_itens.id)

## Índices
- fk_dieta_presc (id_prescricao_item)

## Constraints
- CONSTRAINT fk_dieta_presc FOREIGN KEY (id_prescricao_item) REFERENCES prescricao_itens (id)

## Relacionamentos e Cardinalidade
- internacao_dietas.id_prescricao_item → prescricao_itens (id): N:1 (várias dietas podem referenciar o mesmo item de prescrição)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: prescricao_itens

## Fluxo de utilização dentro do sistema
1. Médico prescreve dieta para paciente internado
2. Registro vincula ao item de prescrição
3. consistencia define a textura da dieta (pastosa, líquida, etc)
4. restricao indica restrições específicas
5. volume_total_dia define quantidade total do dia
6. Nutricionista/Nurse segue a prescrição