# painel_config

Objetivo: Armazenar configurações personalizadas de cada painel.
Descrição: Tabela que armazena configurações específicas para cada painel, permitindo diferentes parâmetros por painel. Cada configuração tem uma chave e pode ter valores de diferentes tipos (boolean, inteiro, decimal, texto, JSON, enum).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel_config | bigint | NOT NULL | - | Identificador único da configuração (chave primária, auto incremento) |
| id_painel | bigint | YES | NULL | ID do painel à qual a configuração pertence |
| chave | varchar(80) | NOT NULL | - | Chave identificadora da configuração (ex: "EXIBIR_NOME_PACIENTE") |
| valor_bool | tinyint(1) | YES | NULL | Valor booleano da configuração (quando tipo=BOOL) |
| valor_int | int | YES | NULL | Valor inteiro da configuração (quando tipo=INT) |
| valor_decimal | decimal(12,4) | YES | NULL | Valor decimal da configuração (quando tipo=DECIMAL) |
| valor_text | text | YES | NULL | Valor textual da configuração (quando tipo=TEXT) |
| valor_json | json | YES | NULL | Valor JSON da configuração (quando tipo=JSON) |
| valor_enum | varchar(80) | YES | NULL | Valor enum da configuração (quando tipo=ENUM) |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data/hora da última atualização |
| id_sessao_usuario | bigint | YES | NULL | ID da sessão do usuário que atualizou a configuração |
| id_usuario | bigint | YES | NULL | ID do usuário que atualizou a configuração |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a configuração pertence |

## Chaves
- Primária: id_painel_config
- Únicas: uk_painel_config_painel_chave (id_painel, chave)
- Estrangeiras: 
  - fk_painel_config_painel: id_painel → painel (id_painel) com CASCADE

## Índices
- PRIMARY KEY (id_painel_config)
- UNIQUE KEY uk_painel_config_painel_chave (id_painel, chave)
- KEY idx_painel_config_chave (chave)
- KEY idx_painel_config_painel (id_painel)
- KEY idx_painel_config_atualizado_em (atualizado_em)

## Constraints
- PRIMARY KEY: id_painel_config
- UNIQUE: uk_painel_config_painel_chave
- FOREIGN KEY: fk_painel_config_painel

## Relacionamentos e Cardinalidade
- N:1 com painel: Muitas configurações pertencem a um painel
- N:1 com usuario: Muitas configurações podem ser atualizadas por um usuário
- N:1 com sessao_usuario: Muitas configurações podem ter uma sessão associada
- N:1 com saas_entidade: Muitas configurações pertencem a uma entidade

## Dependências
- Esta tabela depende de: painel, usuario, sessao_usuario, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para armazenar configurações dinâmicas de cada painel. Por exemplo, pode configurar se deve exibir o nome do paciente no painel público (EXIBIR_NOME_PACIENTE), quais locais filtrar (FILTRO_LOCAIS_CODIGOS_JSON), entre outros. As configurações são carregadas dinamicamente pelos painéis e totens.