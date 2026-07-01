# auditoria_estoque_sanitario

Objetivo: Auditar o estoque de produtos sanitários com foco na segurança e validade.
Descrição: Tabela que registra auditorias de estoque de produtos sanitários, classificando o nível de risco (OK, CRITICO, VENCIDO) para controle de qualidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_farmaco | bigint | NOT NULL | - | Referência ao fármaco/produto sanitário auditado. |
| id_lote | bigint | NOT NULL | - | Referência ao lote do produto sanitário. |
| id_local | int | NOT NULL | - | Referência ao local/armazém onde o produto está armazenado. |
| quantidade | int | NOT NULL | - | Quantidade de itens no lote auditado. |
| nivel_risco | enum('OK','CRITICO','VENCIDO') | NOT NULL | - | Classificação do risco: OK (normal), CRITICO (estoque baixo/crítico) ou VENCIDO (produto vencido). |
| criado_por | bigint | NOT NULL | - | Referência ao usuário que realizou a auditoria. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora da auditoria. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com farmaco (id_farmaco) - inferido
- N:1 com lote (id_lote) - inferido
- N:1 com local (id_local) - inferido
- N:1 com usuario (criado_por) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: farmaco, lote, local, usuario, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Registrada durante auditorias de estoque sanitário
- Usada para monitorar produtos vencidos ou com estoque crítico
- Permite ação corretiva imediata com base no nível de risco
- Integra-se com sistema de alertas de validade de produtos