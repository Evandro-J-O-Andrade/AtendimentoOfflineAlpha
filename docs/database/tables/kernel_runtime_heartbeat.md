# kernel_runtime_heartbeat

Objetivo: Monitorar a saúde e disponibilidade dos runtimes do sistema através de heartbeats periódicos.
Descrição: Tabela que registra os heartbeats (pings) enviados pelos componentes runtime do sistema, permitindo detectar falhas, componentes offline e monitorar o estado de saúde dos runtimes. Cada runtime envia heartbeats periódicos com seu UUID único.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_heartbeat` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do heartbeat |
| `uuid_runtime` | char(36) | NOT NULL | - | UUID único do componente/runtime que envia o heartbeat |
| `estado_runtime` | varchar(80) | NOT NULL | - | Estado atual do runtime (ex: SAUDE_TOTAL, WARNING, CRITICAL) |
| `ultimo_ping` | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp do último heartbeat recebido |
| `ativo` | tinyint(1) | NULL | '1' | Indica se o runtime está ativo (1) ou inativo (0) |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do heartbeat |

## Chaves
- Primária: `id_heartbeat`
- Únicas: `uk_heartbeat_runtime` (`uuid_runtime`) - Garante unicidade do UUID do runtime
- Estrangeiras: -

## Índices
- `idx_heartbeat_estado` (KEY) - Índice no estado do runtime para filtros por saúde

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Muitos heartbeats pertencem a uma entidade
- 1:1 com `runtime` - Cada runtime tem um heartbeat único (via uuid_runtime)

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada componente runtime envia heartbeats periódicos (ex: a cada 30 segundos)
2. O heartbeat atualiza o campo `ultimo_ping` com timestamp atual
3. Sistemas de monitoramento verificam heartbeats expirados para detectar falhas
4. Se um heartbeat não é recebido dentro do timeout esperado, o runtime é marcado como inativo
5. O estado do runtime reflete a saúde geral (SAUDE_TOTAL, WARNING, CRITICAL)
6. Usado pelo assistencial_watchdog_fila para monitoramento de healthy
7. Permite decisão de spillover e redirecionamento de carga
8. Base para alertas de disponibilidade e SLA