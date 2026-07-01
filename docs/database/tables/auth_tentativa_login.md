# auth_tentativa_login

Objetivo: Registrar todas as tentativas de login ao sistema, bem-sucedidas e falhas.
Descrição: Tabela que captura cada tentativa de login com login/email informado, IP de origem, user agent e resultado, para detecção de ataques de força bruta.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_tentativa | bigint | NOT NULL | - | Identificador único da tentativa, chave primária auto incrementada. |
| login | varchar(80) | NOT NULL | - | Login ou email informado na tentativa de login. |
| ip_origem | varchar(45) | NOT NULL | - | Endereço IP de origem da tentativa. |
| user_agent | text | Nullable | - | User agent do navegador/dispositivo utilizado. |
| sucesso | tinyint(1) | NOT NULL | '0' | Indicador se a tentativa foi bem-sucedida (1) ou falhou (0). |
| motivo_falha | varchar(100) | Nullable | - | Motivo da falha (ex: senha incorreta, usuário inativo, conta bloqueada). |
| criado_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de criação do registro da tentativa. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a tentativa pertence. |

## Chaves
- Primária: id_tentativa
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_tentativa)
- KEY idx_tentativa_login (login)
- KEY idx_tentativa_ip (ip_origem)
- KEY idx_tentativa_data (criado_em)

## Constraints
- PRIMARY KEY: id_tentativa

## Relacionamentos e Cardinalidade
- Própria tentativa está associada a id_entidade para identificar a organização
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em cada tentativa de login
- Usada para detecção de ataques de força bruta (múltiplas tentativas falhas)
- Permite bloquear IPs ou contas após tentativas excessivas
- Campos login e ip_origem usados para correlacionar tentativas suspeitas
- Integrada com auth_parametro para limitar tentativas e definir tempo de bloqueio