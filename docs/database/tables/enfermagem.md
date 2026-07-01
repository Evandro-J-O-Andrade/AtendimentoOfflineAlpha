# enfermagem

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_usuario | bigint | NO |  | id usuario |
| coren | varchar(20) | NO |  | coren |
| uf_coren | char(2) | NO |  | uf coren |
| tipo | enum('ENFERMEIRO','TECNICO') | NO |  | tipo |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_usuario.
- Estrangeiras:
  - id_usuario referencia usuario.id_usuario

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)

## Relacionamentos e Cardinalidade

- enfermagem (id_usuario) -> usuario (id_usuario): N:1

## DependÃªncias

- Depende de: usuario.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

