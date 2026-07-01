# kernel_runtime_single_writer_lock

Objetivo: Implementar mecanismo de lock de escrita única (single writer) para garantir consistência em operações críticas no runtime distribuído.
Descrição: Tabela que controla o padrão de lock single writer, garantindo que apenas uma sessão de usuário possa realizar escrita em um determinado contexto por vez. Evita conflitos de concorrência em operações críticas como atualização de estados ou processamento de eventos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_lock` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do lock |
| `contexto_runtime` | varchar(50) | NOT NULL | - | Contexto onde o lock é aplicado (ex: ATUALIZACAO_FFAX, PROCESSAMENTO_LAB) |
| `id_sessao_usuario` | bigint | NOT NULL | - | Identificador da sessão de usuário que detém o lock |
| `estado_lock` | enum('ATIVO','LIBERADO','EXPIRADO') | NULL | 'ATIVO' | Estado atual do lock: ATIVO (bloqueado), LIBERADO, EXPIRADO |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do lock com precisão de microssegundos |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do lock |

## Chaves
- Primária: `id_lock`
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_lock_contexto` (KEY) - Índice no contexto do lock para buscas por contexto
- `idx_lock_estado` (KEY) - Índice no estado do lock para filtros de status

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Muitos locks pertencem a uma entidade
- N:1 com `sessao_usuario` - Muitos locks podem estar associados a uma sessão

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`, `sessao_usuario`

## Fluxo de utilização dentro do sistema
1. Antes de operação crítica, uma sessão solicita lock no contexto apropriado
2. O lock é criado com estado ATIVO e vinculado à sessão do usuário
3. Outras sessões que tentarem operar no mesmo contexto são bloqueadas
4. Ao final da operação, o lock deve ser liberado (estado LIBERADO)
5. Locks com `estado_lock='EXPIRADO'` são ignorados pelo sistema
6. Locks expirados sem atualização são detectados e limpeza automática
7. Usado para garantir atomicidade de operações distribuídas
8. Previne condições de corrida em atualizações de estado críticas