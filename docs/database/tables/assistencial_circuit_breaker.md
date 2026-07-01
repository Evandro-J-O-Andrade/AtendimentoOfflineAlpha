# assistencial_circuit_breaker

Objetivo: Monitorar e controlar o circuit breaker do sistema assistencial, gerenciando estados de falha e recuperação dos componentes críticos.

Descrição: Esta tabela implementa o padrão circuit breaker para componentes do sistema assistencial, permitindo o controle automático de falhas consecutivas, estados de circuito (fechado, aberto, meio-aberto) e limites de falha para detecção precoce de problemas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_circuit | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do circuit breaker |
| componente | varchar(60) | NOT NULL | - | Nome ou identificador do componente monitorado pelo circuit breaker |
| estado | enum('FECHADO','ABERTO','MEIO_ABERTO') | YES | 'FECHADO' | Estado atual do circuito: FECHADO (normal), ABERTO (falhando), MEIO_ABERTO (testing) |
| falhas_consecutivas | int | YES | '0' | Contador de falhas consecutivas detectadas no componente |
| limite_falha | int | YES | '5' | Limite máximo de falhas consecutivas antes de abrir o circuito |
| atualizado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático de atualização do estado do circuito |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o circuito pertence |

## Chaves
- Primária: id_circuit
- Únicas: uk_circuit_componente (componente) - Garante um único circuit breaker por componente
- Estrangeiras: Nenhuma

## Índices
- Nenhum índice adicional definido

## Constraints
- uk_circuit_componente - UNIQUE - Garante unicidade do componente no circuit breaker

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_circuit_breaker)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Monitoramento contínuo de componentes críticos do sistema assistencial
- Estado FECHADO indica componente funcionando normalmente
- Estado ABERTO indica que o componente foi desativado por excesso de falhas
- Estado MEIO_ABERTO indica teste de recuperação do componente
- Contador de falhas consecutivas para detecção de instabilidade
- Limite configurável de falhas antes de abrir o circuito
- Timestamp de atualização para controle de quando houve mudança de estado