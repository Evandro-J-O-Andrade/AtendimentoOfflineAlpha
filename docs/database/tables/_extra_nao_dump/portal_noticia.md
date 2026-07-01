# portal_noticia

Objetivo: Gerenciar notícias e comunicados do portal corporativo com categorização, autoria, publicação e métricas de visualização.
Descrição: Tabela principal do módulo de notícias do portal corporativo que armazena o conteúdo completo de cada notícia. Gerencia todo o ciclo de vida: criação, edição, publicação, expiração e métricas de visualização. Suporta categorização, autoria por usuário, vinculação a unidade e entidade, além de campos JSON para anexos e tags. Controla publicação datada e expiração de conteúdo para newsletters e comunicados temporários.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_portal_noticia | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a notícia |
| titulo | varchar(255) | NO | NULL | Título da notícia exibido no portal e nos dispositivos |
| conteudo | longtext | YES | NULL | Conteúdo completo da notícia em formato HTML ou texto enriquecido |
| resumo | text | YES | NULL | Resumo ou chamada da notícia para exibição em listas e pré-visualizações |
| id_categoria | bigint | YES | NULL | Identificador da categoria de notícia à qual esta notícia pertence |
| id_autor | bigint unsigned | YES | NULL | Identificador do usuário autor da notícia |
| id_unidade | bigint unsigned | YES | NULL | Identificador da unidade à qual a notícia está vinculada (notícia setorial) |
| id_saas_entidade | bigint unsigned | YES | NULL | Identificador da entidade SaaS pública/divulgadora da notícia |
| publicado_em | datetime(6) | YES | DEFAULT CURRENT_TIMESTAMP(6) | Data e hora de publicação da notícia (define quando se torna visível) |
| expira_em | datetime(6) | YES | NULL | Data e hora de expiração da notícia (após essa data deixa de ser exibida) |
| ativo | tinyint | YES | 1 | Flag que indica se a notícia está ativa (1) para exibição ou inativa (0) |
| prioridade | tinyint | YES | 0 | Nível de prioridade para ordenação (maior valor = maior prioridade) |
| visualizacoes | int | YES | 0 | Contador de visualizações da notícia |
| anexos | json | YES | NULL | Objeto JSON contendo lista de anexos da notícia (arquivos, imagens, PDFs) |
| tags | json | YES | NULL | Array JSON de tags/palavras-chave para busca e filtragem |
| criado_em | datetime(6) | YES | DEFAULT CURRENT_TIMESTAMP(6) | Data e hora de criação do rascunho da notícia |
| atualizado_em | datetime(6) | YES | NULL | Data e hora da última atualização/edição da notícia |

## Chaves
- Primária: id_portal_noticia
- Únicas: Nenhuma
- Estrangeiras: fk_portal_noticia_categoria (id_categoria -> portal_categoria.id_portal_categoria), fk_portal_noticia_autor (id_autor -> usuario.id_usuario), fk_portal_noticia_unidade (id_unidade -> unidade.id_unidade), fk_portal_noticia_entidade (id_saas_entidade -> saas_entidade.id_entidade)

## Índices
- idx_portal_noticia_categoria (id_categoria)
- idx_portal_noticia_autor (id_autor)
- idx_portal_noticia_unidade (id_unidade)
- idx_portal_noticia_entidade (id_saas_entidade)
- idx_portal_noticia_publicado (publicado_em)

## Constraints
- fk_portal_noticia_categoria: FOREIGN KEY (id_categoria) REFERENCES portal_categoria (id_portal_categoria)
- fk_portal_noticia_autor: FOREIGN KEY (id_autor) REFERENCES usuario (id_usuario)
- fk_portal_noticia_unidade: FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- fk_portal_noticia_entidade: FOREIGN KEY (id_saas_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com portal_categoria (muitas notícias pertencem a uma categoria)
- N:1 com usuario como autor (muitas notícias podem ser escritas por um usuário)
- N:1 com unidade (muitas notícias podem pertencer a uma unidade)
- N:1 com saas_entidade (muitas notícias pertencem a uma entidade)

## Dependências
- Depende de: portal_categoria, usuario, unidade, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta, mas é consultada pelo portal e módulos de exibição

## Fluxo de utilização dentro do sistema
- Administradores ou usuários autorizados criam, editam e publicam notícias através do módulo Portal
- A lista de notícias é consultada filtrando por entidade, categoria, status ativo e data de publicação
- O campo publicado_em controla o agendamento de publicação (notícias futuras não aparecem)
- O campo expira_em permite notícias temporárias (comunicados de campanha, avisos de manutenção)
- O campo prioridade define ordem de exibição no portal corporativo e totens
- Tags em JSON permitem busca textual e filtragem por assunto
- Anexos em JSON permitem múltiplos arquivos por notícia sem tabela auxiliar
- O contador visualizacoes é incrementado a cada acesso para métricas de engajamento
- Permissões PORTAL.NOTICIA.CRIAR, PORTAL.NOTICIA.LISTAR e PORTAL.NOTICIA.EDITAR controlam acesso às operações
