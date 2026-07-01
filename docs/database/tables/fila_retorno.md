# fila_retorno

Objetivo: Controlar pedidos de retorno de pacientes às filas.

Descrição: Tabela que gerencia os pedidos de retorno dos pacientes que já utilizaram sua senha de atendimento mas precisam retornar ao sistema. Permite controle de tempo e validade dos retornos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do retorno, chave primária auto incrementada |
| id_fila | bigint | NOT NULL | - | Referência à senha da fila (fila_senha) que será retornada |
| retorno_em | datetime | NOT NULL | - | Data e hora programada para retorno do paciente |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se o retorno está ativo (1=ativo, 0=inativo) |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro de retorno |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fila_retorno_ibfk_1 (id_fila → fila_senha.id)

## Índices
- id_fila (id_fila)

## Constraints
- CONSTRAINT fila_retorno_ibfk_1 FOREIGN KEY (id_fila) REFERENCES fila_senha (id)

## Relacionamentos e Cardinalidade
- fila_retorno.id_fila → fila_senha (id): N:1 (vários registros de retorno podem referenciar a mesma senha)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: fila_senha

## Fluxo de utilização dentro do sistema
1. Paciente é atendido e sai da fila, mas precisa retornar depois
2. Registro de retorno é criado com data retorno_em programada
3. Campo ativo controla se o retorno ainda pode ser utilizado
4. Quando o paciente retorna, sistema valida contra este registro