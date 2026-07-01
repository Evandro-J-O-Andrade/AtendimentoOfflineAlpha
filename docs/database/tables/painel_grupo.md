# painel_grupo

Objetivo: Agrupar painéis para controle coletivo de exibição.
Descrição: Tabela que permite agrupar múltiplos painéis sob um mesmo grupo, facilitando a gestão de configurações e mensagens em lote para conjuntos de painéis.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_grupo | bigint | NOT NULL | - | Identificador único do grupo (chave primária, auto incremento) |
| codigo | varchar(50) | NOT NULL | - | Código único do grupo para identificação |
| nome | varchar(120) | NOT NULL | - | Nome descritivo do grupo de painéis |
| descricao | varchar(255) | YES | NULL | Descrição do propósito do grupo |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se o grupo está ativo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do grupo |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o grupo pertence |

## Chaves
- Primária: id_grupo
- Únicas: uk_grupo_codigo (codigo)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_grupo)
- UNIQUE KEY uk_grupo_codigo (codigo)

## Constraints
- PRIMARY KEY: id_grupo
- UNIQUE: uk_grupo_codigo

## Relacionamentos e Cardinalidade
- 1:N com painel_grupo_local: Um grupo pode ter muitos locais associados
- N:1 com saas_entidade: Muitos grupos pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: painel_grupo_local

## Fluxo de utilização dentro do sistema
Utilizada para agrupar múltiplos locais/painéis que compartilham configurações similares. Por exemplo, todos os totens de uma unidade podem pertencer ao mesmo grupo. Permite aplicar configurações ou enviar mensagens para todos os painéis do grupo de uma só vez.