# gasoterapia_consumo

Objetivo: Controlar o consumo de gasoterapia em atendimentos.

Descrição: Tabela que registra o consumo de gases medicinais (oxigênio, ar comprimido, vácuo, mistura N2O) em pacientes internados, controlando início, fim e quantidade consumida. Vinculada ao atendimento e leito.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do consumo, chave primária auto incrementada |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento onde o consumo ocorre |
| id_leito | int | NOT NULL | - | Referência ao leito onde o consumo está sendo usado |
| tipo_gas | enum('OXIGENIO','AR_COMPRIMIDO','VACUO','MISTURA_N2O') | NOT NULL | - | Tipo de gás: oxigênio, ar comprimido, vácuo ou mistura N2O |
| litros_por_minuto | decimal(10,2) | NOT NULL | '0.00' | Taxa de consumo em litros por minuto |
| data_inicio | datetime | NOT NULL | - | Data e hora de início do consumo |
| data_fim | datetime | DEFAULT NULL | - | Data e hora de fim do consumo |
| status | enum('EM_USO','ENCERRADO','CANCELADO') | DEFAULT | 'EM_USO' | Status do consumo: em uso, encerrado ou cancelado |
| id_usuario_registro | bigint | NOT NULL | - | Referência ao usuário que registrou o consumo |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fk_gaso_atendimento (id_atendimento → atendimento.id_atendimento); fk_gaso_leito (id_leito → leito.id_leito)

## Índices
- fk_gaso_atendimento (id_atendimento)
- fk_gaso_leito (id_leito)

## Constraints
- CONSTRAINT fk_gaso_leito FOREIGN KEY (id_leito) REFERENCES leito (id_leito)

## Relacionamentos e Cardinalidade
- gasoterapia_consumo.id_atendimento → atendimento (id_atendimento): N:1 (vários consumos podem referenciar o mesmo atendimento)
- gasoterapia_consumo.id_leito → leito (id_leito): N:1 (vários consumos podem ocorrer no mesmo leito)
- gasoterapia_consumo.id_usuario_registro → usuario (id_usuario): N:1 (vários registros podem ser feitos pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: gasoterapia_consumo_evento
- Esta tabela depende de: atendimento, leito

## Fluxo de utilização dentro do sistema
1. Paciente internado é iniciado em gasoterapia
2. Registro é criado com tipo_gas e litros_por_minuto
3. id_atendimento e id_leito vinculam o consumo ao leito do paciente
4. data_inicio é obrigatório, data_fim é preenchido ao encerrar
5. Status inicia como 'EM_USO'
6. Ao encerrar: status muda para 'ENCERRADO', data_fim preenchida
7. Se cancelado: status muda para 'CANCELADO'