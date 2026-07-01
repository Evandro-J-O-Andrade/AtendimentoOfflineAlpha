# kernel_runtime_evento

Objetivo: Registrar eventos de runtime ocorridos no sistema para monitoramento, auditoria e processamento distribuído.
Descrição: Tabela que captura eventos assíncronos do runtime do sistema, permitindo o rastreamento de ações distribuídas, mudanças de estado e processamento de eventos. Cada evento possui um UUID único, payload JSON e hash para integridade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador numérico únrico do evento |
| `uuid_runtime` | char(36) | NOT NULL | - | UUID único do evento no runtime (identificador global) |
| `id_usuario` | bigint | NULL | NULL | Identificador do usuário que gerou o evento |
| `tipo_evento` | varchar(80) | NOT NULL | - | Tipo do evento (ex: ATENDIMENTO_INICIADO, PRESCRICAO_CRIADA) |
| `entidade_alvo` | varchar(80) | NULL | NULL | Nome da entidade alvo do evento (ex: FFA, ATENDIMENTO) |
| `id_referencia` | bigint | NULL | NULL | Identificador do registro referenciado no evento |
| `payload` | json | NULL | NULL | Payload JSON contendo dados adicionais do evento |
| `hash_evento` | char(64) | NOT NULL | - | Hash SHA256 do evento para integridade e detecção de duplicação |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação com precisão de microssegundos |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do evento |

## Chaves
- Primária: `id_evento` (bigint)
- Únicas: -
- Estrangeiras: 
  - `fk_kernel_runtime_evento_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula o evento à entidade proprietária

## Índices
- `idx_runtime_evento_uuid` (KEY) - Índice no UUID do evento para buscas rápidas
- `idx_runtime_evento_tipo` (KEY) - Índice no tipo do evento
- `idx_runtime_evento_referencia` (KEY) - Índice composto em `entidade_alvo` e `id_referencia`
- `fk_kernel_runtime_evento_entidade` (KEY) - Índice na coluna `id_entidade`

## Constraints
- `fk_kernel_runtime_evento_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Muitos eventos pertencem a uma entidade
- N:1 com `usuario` - Muitos eventos podem ser gerados pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: `observacoes_eventos` (via id_ffa), `assistencial_evento_hash`, `assistencial_quorum_clinico`
- Esta tabela depende de: `saas_entidade`, `usuario`

## Fluxo de utilização dentro do sistema
1. Eventos são gerados automaticamente ou manualmente durante operações do sistema
2. O UUID runtime permite rastrear eventos distribuídos entre múltiplas instâncias
3. O tipo_evento classifica o evento para processamento adequado
4. O payload contém dados estruturados para processamento posterior
5. O hash_evento permite verificar integridade e detectar duplicações
6. Usado para sincronização distribuída via ledger_evento_sincronizacao
7. Permite replay de eventos em caso de falha em sistemas distribuídos
8. Base para sistemas de event sourcing e CQRS