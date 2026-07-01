# painel_config_def

Objetivo: Definir as configurações disponíveis para painéis (catálogo de configurações).
Descrição: Tabela que define as configurações possíveis para painéis, totens e TVs, especificando o tipo de valor aceito, valores padrão e descrição de cada configuração.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_painel_config_def | bigint | NOT NULL | - | Identificador único da definição (chave primária, auto incremento) |
| chave | varchar(80) | NOT NULL | - | Chave identificadora da configuração |
| aplica_em | enum('PAINEL','TOTEM','TV','TODOS') | NOT NULL | 'TODOS' | Tipo de equipamento onde aplica: painel, totum, TV ou todos |
| tipo_valor | enum('BOOL','INT','DECIMAL','TEXT','JSON','ENUM') | NOT NULL | - | Tipo de dado aceito: boolean, inteiro, decimal, texto, JSON ou enum |
| default_bool | tinyint(1) | YES | NULL | Valor padrão booleano |
| default_int | int | YES | NULL | Valor padrão inteiro |
| default_decimal | decimal(12,4) | YES | NULL | Valor padrão decimal |
| default_text | text | YES | NULL | Valor padrão texto |
| default_json | json | YES | NULL | Valor padrão JSON |
| default_enum | varchar(80) | YES | NULL | Valor padrão para enums |
| categoria | varchar(50) | YES | NULL | Categoria da configuração para agrupamento |
| descricao | varchar(255) | YES | NULL | Descrição da configuração e seu propósito |
| enum_opcoes_json | json | YES | NULL | Opções disponíveis para configurações do tipo enum |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se a definição está ativa |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação da definição |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data/hora da última atualização |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para configurações globais) |

## Chaves
- Primária: id_painel_config_def
- Únicas: uk_painel_config_def_chave (chave), uk_painel_cfgdef_aplica_chave (aplica_em, chave)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_painel_config_def)
- UNIQUE KEY uk_painel_config_def_chave (chave)
- UNIQUE KEY uk_painel_cfgdef_aplica_chave (aplica_em, chave)
- KEY idx_painel_config_def_categoria (categoria)
- KEY idx_painel_config_def_ativo (ativo)

## Constraints
- PRIMARY KEY: id_painel_config_def
- UNIQUE: uk_painel_config_def_chave
- UNIQUE: uk_painel_cfgdef_aplica_chave

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade: Muitas definições pertencem a uma entidade (ou são globais)

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada como catálogo de configurações disponíveis para os painéis do sistema. Cada configuração é definida aqui com seu tipo, valor padrão, descrição e opções. Usuários administradores podem sobrescrever as configurações padrão na tabela painel_config. Permite documentar e padronizar todas as opções configuráveis dos painéis.