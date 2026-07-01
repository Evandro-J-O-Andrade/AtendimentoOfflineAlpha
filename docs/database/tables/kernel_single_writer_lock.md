# kernel_single_writer_lock

Objetivo: Implementar bloqueio de escrita única (single writer) baseado em UUID runtime para garantir exclusividade de operações.
Descrição: Tabela simplificada de lock single writer que usa UUID runtime como identificador. Permite que apenas uma instância do runtime realize operações críticas em um contexto específico, evitando conflitos em sistemas distribuídos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_lock` | bigint | NOT NULL | AUTO_INCREMENT | Identificador numérico único do lock |
| `uuid_runtime` | char(36) | NOT NULL | - | UUID único do runtime que detém o lock |
| `bloqueado` | tinyint(1) | NULL | '1' | Indica se está bloqueado (1) ou liberado (0) |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do lock |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_lock`
- Únicas: `uk_kernel_runtime` (`uuid_runtime`) - Garante unicidade do UUID do runtime
- Estrangeiras: -

## Índices
- Não possui índices adicionais além do UNIQUE KEY

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- 1:1 com `runtime` - Cada UUID runtime tem um lock único
- N:1 com `saas_entidade` - Muitos locks pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Runtime adquire lock informando seu UUID como single writer
2. O campo `bloqueado=1` indica que o lock está ativo
3. Outras instâncias verificam existência do UUID antes de operar
4. Locks são liberados definindo `bloqueado=0`
5. Usado para sincronização de processamento entre múltiples nós
6. Evita condições de corrida em operações críticas
7. Permite failover automático (UUID pode ser reutilizado após timeout)