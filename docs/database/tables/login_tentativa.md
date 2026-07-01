# login_tentativa

Objetivo: Registrar tentativas de login no sistema para detecção de ataques e auditoria de segurança.
Descrição: Tabela que registra todas as tentativas de autenticação no sistema, com informações de IP, dispositivo, horário e resultado, permitindo detecção de ataques de força bruta e comportamentos suspeitos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_tentativa` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da tentativa |
| `id_usuario` | bigint | NOT NULL | - | Usuário que tentou fazer login |
| `login` | varchar(80) | NOT NULL | - | Login informado na tentativa |
| `ip_origem` | varchar(45) | NULL | NULL | IP de origem da tentativa (IPv4 ou IPv6) |
| `dispositivo_origem` | varchar(100) | NULL | NULL | Informações do dispositivo (user agent) |
| `tentativa_faixa_horaria` | varchar(50) | NULL | NULL | Faixa horária da tentativa |
| `sucesso` | tinyint(1) | NOT NULL | '0' | Indica se a tentativa foi bem-sucedida (1) ou falhou (0) |
| `metadata` | json | NULL | NULL | Metadados adicionais em formato JSON (ex: motivo da falha) |
| `criado_em` | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp da tentativa com precisão |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_tentativa`
- Únicas: -
- Estrangeiras: 
  - `fk_login_tentativa_usuario` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula tentativa ao usuário; exclui em cascata e atualiza em cascata

## Índices
- `idx_login_tentativa_login` (KEY) - Índice em `login`
- `idx_login_tentativa_ip` (KEY) - Índice em `ip_origem`
- `idx_login_tentativa_usuario` (KEY) - Índice em `id_usuario`
- `idx_login_tentativa_dispositivo` (KEY) - Índice em `dispositivo_origem`

## Constraints
- `fk_login_tentativa_usuario` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario` (ON DELETE CASCADE ON UPDATE CASCADE)

## Relacionamentos e Cardinalidade
- N:1 com `usuario` - Muitas tentativas podem ter sido feitas pelo mesmo usuário
- N:1 com `saas_entidade` - Muitas tentativas pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Toda tentativa de login gera um registro nesta tabela
2. IP e dispositivo são capturados para análise de segurança
3. Tentativas falhas têm `sucesso=0`
4. Sistema detecta múltiplas tentativas falhas do mesmo IP
5. O `metadata` contém detalhes como motivo da falha ou perfil usado
6. Usado para bloqueio automático de IPs maliciosos
7. Base para relatórios de segurança
8. Integração com kernel_identity_trust_chain para scoring de risco
9. Usado para detecção de ataques de força bruta
10. Logs são purgados após período de retenção (ex: 90 dias)