# documento_tipo_config

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| codigo | varchar(60) | NO |  | codigo |
| descricao | varchar(200) | NO |  | descricao |
| destino | enum('PACIENTE','FARMACIA','ENFERMAGEM','ADMIN','ARQUIVO') | NO | 'PACIENTE' | destino |
| exige_farmaceutico | tinyint(1) | NO | '0' | exige farmaceutico |
| template_codigo | varchar(80) | YES | NULL | template codigo |
| ativo | tinyint(1) | NO | '1' | ativo |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | YES | NULL | id entidade |

## Chaves

- PrimÃ¡ria: codigo.

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

