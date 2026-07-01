# fila_painel_runtime

Objetivo: Armazenar o estado runtime das filas para exibição em painéis.

Descrição: Tabela que mantém o estado atual das filas para exibição em painéis de monitoramento em tempo real. Permite visualização rápida do status das senhas, prioridades e atualizações sem precisar consultar as tabelas principais.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro runtime, chave primária auto incrementada |
| id_unidade | bigint | NOT NULL | - | Referência à unidade onde a fila está localizada |
| id_local | bigint | DEFAULT NULL | - | Referência ao local específico da fila |
| id_senha | bigint | DEFAULT NULL | - | Referência à senha da fila (fila_senha) |
| codigo_visual | varchar(20) | DEFAULT NULL | - | Código visual para exibição no painel |
| status | varchar(50) | DEFAULT NULL | - | Status atual da fila para exibição |
| prioridade | int | DEFAULT NULL | - | Nível numérico de prioridade para ordenação no painel |
| atualizado_em | datetime(6) | DEFAULT NULL | - | Timestamp de última atualização do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- idx_unidade (id_unidade)
- idx_local (id_local)
- idx_status (status)

## Constraints
- -

## Relacionamentos e Cardinalidade
- fila_painel_runtime.id_unidade → unidade (id_unidade): N:1 (vários registros podem referenciar a mesma unidade)
- fila_painel_runtime.id_local → local (id_local): N:1 (vários registros podem referenciar o mesmo local)
- fila_painel_runtime.id_senha → fila_senha (id): N:1 (vários registros podem referenciar a mesma senha)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: unidade, local, fila_senha

## Fluxo de utilização dentro do sistema
1. Painel de monitoramento consulta esta tabela para exibir filas em tempo real
2. Registros são atualizados conforme mudanças nas filas operacionais
3. Campo codigo_visual permite identificação visual rápida
4. Prioridade numérica auxilia ordenação no painel
5. Status reflete o estado atual da senha na fila