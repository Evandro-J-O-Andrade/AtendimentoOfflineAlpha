# log_acesso_prontuario

Objetivo: Registrar logs de acesso ao prontuário eletrônico dos pacientes para conformidade LGPD e auditoria.
Descrição: Tabela que registra cada acesso ao prontuário do paciente, mantendo o histórico de acesso para fins de auditoria e conformidade com regulamentação de privacidade de dados (LGPD).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do log de acesso |
| `id_usuario` | bigint | NOT NULL | - | Usuário que acessou o prontuário |
| `id_atendimento` | bigint | NOT NULL | - | Atendimento cujo prontuário foi acessado |
| `ip_maquina` | varchar(45) | NULL | NULL | IP da máquina que fez o acesso (IPv4 ou IPv6) |
| `data_hora_acesso` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp do acesso ao prontuário |
| `modulo_acessado` | varchar(100) | NULL | NULL | Módulo do sistema acessado (ex: "PRESCRICAO", "EXAMES") |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: -
| Estrangeiras: -

## Índices
- `idx_lgpd_paciente` (KEY) - Índice em `id_atendimento`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `usuario` - Muitos acessos podem ter sido feitos pelo mesmo usuário
- N:1 com `atendimento` - Muitos acessos podem ter sido ao mesmo atendimento
- N:1 com `saas_entidade` - Muitos logs pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `usuario`, `atendimento`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Toda visualização de prontuário gera um registro nesta tabela
2. O IP da máquina é capturado para auditoria de acesso
3. O módulo acessado permite rastrear quais partes do prontuário foram visualizadas
4. Usado para conformidade com LGPD - registro de acesso a dados pessoais
5. Permite investigação de vazamentos de informações
6. Relatórios de acesso são gerados para auditoria clínica
7. Alertas podem ser configurados para acessos suspeitos
8. Usado como evidência em investigações de privacidade