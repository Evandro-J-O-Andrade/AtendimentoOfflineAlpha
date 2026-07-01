# portal_categoria

Objetivo: Cadastrar e gerenciar categorias de notícias do portal corporativo para organização e exibição de conteúdo.
Descrição: Tabela que armazena as categorias de notícias do portal corporativo, permitindo classificar, agrupar e filtrar notícias por tema. Cada categoria possui nome, descrição, cor de etiqueta para exibição e status ativo/inativo. Está associada a uma entidade SaaS para suporte multi-tenant, permitindo que cada entidade tenha seu próprio conjunto de categorias.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_portal_categoria | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a categoria de notícia |
| nome | varchar(100) | NO | NULL | Nome da categoria de notícia (ex: Comunicados, Eventos, Atualizações) |
| descricao | text | YES | NULL | Descrição detalhada do propósito da categoria |
| cor_etiqueta | varchar(20) | YES | NULL | Cor da etiqueta/badge utilizada na exibição da categoria no portal (ex: #FF0000, AZUL) |
| ativo | tinyint | YES | 1 | Flag que indica se a categoria está ativa (1) ou desativada (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação da categoria |
| atualizado_em | datetime(6) | YES | NULL | Data e hora da última atualização da categoria |
| id_entidade | bigint unsigned | YES | NULL | Identificador da entidade SaaS à qual esta categoria pertence |

## Chaves
- Primária: id_portal_categoria
- Únicas: Nenhuma
- Estrangeiras: fk_portal_categoria_entidade (id_entidade -> saas_entidade.id_entidade)

## Índices
- idx_portal_categoria_entidade (id_entidade)

## Constraints
- fk_portal_categoria_entidade: FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade (muitas categorias pertencem a uma entidade)
- 1:N com portal_noticia (uma categoria pode conter muitas notícias)

## Dependências
- Depende de: saas_entidade
- Dependências reversas: portal_noticia (através de fk_portal_noticia_categoria)

## Fluxo de utilização dentro do sistema
- Administradores do portal criam e gerenciam categorias para organizar o conteúdo de notícias
- Usuários do frontend consultam categorias ativas para filtrar notícias publicadas
- Cada notícia deve ser associada a uma categoria existente no momento da criação/edição
- Categorias inativas não aparecem para seleção no frontend mas mantêm suas notícias históricas
- Utilizada em conjunto com permissões PORTAL.NOTICIA.CRIAR e PORTAL.NOTICIA.EDITAR
