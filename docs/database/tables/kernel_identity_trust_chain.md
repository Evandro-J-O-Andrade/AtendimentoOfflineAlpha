# kernel_identity_trust_chain

Objetivo: Gerenciar a cadeia de confiança de identidade de usuários no runtime, implementando controle de segurança baseado em comportamento e risco.
Descrição: Tabela do kernel responsável por rastrear e validar a identidade do usuário durante sessões, usando múltiplos fingerprints (runtime, behavior, device) para detectar anomalias e potencialmente bloquear tentativas de acesso suspeitas. Implementa mecanismo de janela de tentativas e limite de risco.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_chain` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da cadeia de confiança |
| `id_tenant` | bigint | NOT NULL | - | Identificador do tenant (organização cliente) |
| `id_usuario` | bigint | NOT NULL | - | Identificador do usuário cuja identidade está sendo verificada |
| `id_sessao` | bigint | NULL | NULL | Identificador da sessão de usuário (opcional) |
| `id_dispositivo` | bigint | NULL | NULL | Identificador do dispositivo usado para acesso (opcional) |
| `ip_origem` | varchar(45) | NULL | NULL | Endereço IP de origem da requisição (IPv4 ou IPv6) |
| `user_agent` | varchar(500) | NULL | NULL | String do user agent do navegador/dispositivo cliente |
| `fingerprint_runtime` | char(64) | NOT NULL | - | Fingerprint único da sessão runtime atual |
| `fingerprint_behavior` | char(64) | NULL | NULL | Fingerprint baseado no padrão de comportamento do usuário |
| `fingerprint_device` | char(64) | NULL | NULL | Fingerprint do dispositivo usado para acesso |
| `estado_runtime` | varchar(60) | NOT NULL | - | Estado atual do runtime (ex: ATIVO, SUSPENSO, ENCERRADO) |
| `score_risco` | int | NULL | '0' | Pontuação de risco calculada para a sessão atual |
| `limite_risco` | int | NULL | '80' | Limite máximo de pontuação de risco antes do bloqueio automático |
| `tentativas` | int | NULL | '0' | Número de tentativas de acesso suspeitas |
| `janela_tentativa` | int | NULL | '15' | Janela de tempo (minutos) para contagem de tentativas |
| `bloqueado` | tinyint | NULL | '0' | Indica se a identidade está bloqueada (1) ou liberada (0) |
| `ativo` | tinyint | NULL | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| `nonce_runtime` | char(64) | NULL | NULL | Nonce único para prevenir ataques de repetição |
| `lineage_hash` | char(64) | NULL | NULL | Hash que representa a linhagem de confiança |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação com precisão de microssegundos |
| `atualizado_em` | datetime(6) | NULL | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do registro |

## Chaves
- Primária: `id_chain`
- Únicas: `uk_nonce_runtime` (`nonce_runtime`) - Garante unicidade do nonce para prevenir repetição
- Estrangeiras: -

## Índices
- `idx_runtime_fp` (KEY) - Índice no fingerprint runtime para buscas rápidas
- `idx_behavior_fp` (KEY) - Índice no fingerprint behavior
- `idx_device_fp` (KEY) - Índice no fingerprint do dispositivo
- `idx_usuario` (KEY) - Índice em `id_usuario`
- `idx_tenant_usuario` (KEY) - Índice composto em `id_tenant` e `id_usuario`
- `idx_sessao` (KEY) - Índice em `id_sessao`
- `idx_dispositivo` (KEY) - Índice em `id_dispositivo`
- `idx_bloqueio` (KEY) - Índice composto em `bloqueado` e `ativo` para filtros de status
- `idx_score` (KEY) - Índice em `score_risco`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `tenant` - Muitas cadeias de identidade podem pertencer a um tenant
- N:1 com `usuario` - Muitas cadeias podem estar associadas a um usuário
- N:1 com `sessao_usuario` - Muitas cadeias podem estar associadas a uma sessão
- N:1 com `dispositivo` - Muitas cadeias podem estar associadas a um dispositivo

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `tenant`, `usuario`, `sessao_usuario`, `dispositivo`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Ao iniciar uma sessão, um novo registro é criado na trust chain com fingerprint runtime
2. O sistema monitora o comportamento do usuário coletando fingerprints
3. Cada ação suspeita incrementa o `score_risco` e `tentativas`
4. Quando `score_risco` atinge `limite_risco`, o registro é marcado como `bloqueado=1`
5. O `nonce_runtime` é verificado para prevenir ataques de repetição
6. O `lineage_hash` mantém a rastreabilidade da sessão
7. Usado para controle de acesso adaptativo e detecção de anomalias