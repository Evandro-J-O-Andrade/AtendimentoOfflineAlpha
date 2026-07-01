# dispositivo_tipo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_dispositivo_tipo | bigint | NO |  | id dispositivo tipo |
| nome | varchar(50) | NO |  | nome |
| descricao | varchar(200) | YES | NULL | descricao |
| permite_login_usuario | tinyint(1) | YES | '1' | permite login usuario |
| requer_autenticacao | tinyint(1) | YES | '1' | requer autenticacao |
| usa_tts | tinyint(1) | YES | '0' | usa tts |
| exibe_painel | tinyint(1) | YES | '0' | exibe painel |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | YES | NULL | id entidade |

## Chaves

- PrimÃ¡ria: id_dispositivo_tipo.

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

