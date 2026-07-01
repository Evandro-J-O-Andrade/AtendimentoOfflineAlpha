# kernel_authz_policy

Objetivo: Gerenciar políticas de autorização e controle de acesso baseadas em runtime para recursos do sistema.
Descrição: Tabela central do kernel de autorização que define políticas de permissão para ações em contextos específicos, considerando perfis, usuários, dispositivos e estados. Cada política determina se uma ação é permitida (permitido=1) ou negada (permitido=0) com base em combinações de tenant, perfil, contexto, recurso e estados de origem/destino.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_policy` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da política de autorização |
| `id_tenant` | bigint | NOT NULL | - | Identificador do tenant (organização cliente) |
| `id_perfil` | bigint | NOT NULL | - | Identificador do perfil de usuário para o qual a política se aplica |
| `id_usuario` | bigint | NULL | NULL | Identificador específico de usuário (opcional, para políticas específicas de usuário) |
| `contexto` | varchar(60) | NOT NULL | - | Contexto da política (ex: ATENDIMENTO, PACIENTE, USUARIO) |
| `recurso` | varchar(120) | NOT NULL | - | Recurso específico para o qual a política se aplica (ex: ATENDIMENTO_INICIAR) |
| `estado_origem` | varchar(60) | NULL | '*' | Estado de origem para transição (padrão '*' significa qualquer estado) |
| `estado_destino` | varchar(60) | NULL | '*' | Estado de destino para transição (padrão '*' significa qualquer estado) |
| `id_dispositivo` | bigint | NULL | NULL | Identificador do dispositivo para o qual a política se aplica (opcional) |
| `id_dispositivo_norm` | bigint | NULL | STORED GENERATED | Valor normalizado de id_dispositivo (0 se NULL) para indexação eficiente |
| `permitido` | tinyint | NULL | '0' | Indica se a ação é permitida (1) ou negada (0) |
| `decision_fingerprint` | char(64) | NULL | NULL | Hash de decisão para validação de integridade da política |
| `ativo` | tinyint | NULL | '1' | Indica se a política está ativa (1) ou inativa (0) |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação da política com precisão de microssegundos |
| `id_entidade` | bigint unsigned | NULL | NULL | Referência à entidade proprietária (opcional) |

## Chaves
- Primária: `id_policy`
- Únicas: `uk_policy_runtime` (`id_tenant`,`id_perfil`,`contexto`,`recurso`,`estado_origem`,`estado_destino`,`id_dispositivo_norm`)
- Estrangeiras: -

## Índices
- `uk_policy_runtime` (UNIQUE KEY) - Garante unicidade da combinação tenant/perfil/contexto/recurso/estados/dispositivo
- `idx_policy_lookup` (KEY) - Índice composto para busca eficiente por tenant, contexto, recurso, ativo e permitido

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `tenant` - Muitas políticas podem pertencer a um tenant
- N:1 com `perfil` - Muitas políticas podem estar associadas a um perfil
- N:1 com `usuario` - Muitas políticas podem estar associadas a um usuário específico (se informado)
- N:1 com `dispositivo` - Muitas políticas podem estar associadas a um dispositivo (se informado)

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `tenant`, `perfil`, `usuario`, `dispositivo`, `saas_entidade` (via id_entidade - opcional)

## Fluxo de utilização dentro do sistema
1. O sistema carrega políticas de autorização no início da sessão ou sob demanda
2. Antes de executar uma ação, o kernel verifica a política correspondente baseada em tenant, perfil, contexto, recurso e estados
3. O campo `permitido` determina se a ação é autorizada ou negada
4. Políticas com `ativo=0` são ignoradas pelo sistema
5. O `decision_fingerprint` permite validação de integridade e versionamento
6. Usado pelo middleware de autorização para controle de acesso em tempo real
7. Permite auditoria de decisões de autorização