# permissao

Objetivo: Definir permissões individuais do sistema (telas, recursos, APIs).
Descrição: Tabela que lista todas as permissões disponíveis no sistema, incluindo acesso a painéis, funcionalidades, APIs e recursos específicos. Cada permissão tem código, nome, domínio e metadados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_permissao | bigint | NOT NULL | - | Identificador único da permissão (chave primária, auto incremento) |
| codigo | varchar(80) | NOT NULL | - | Código único da permissão (ex: "PAINEL_MEDICO", "EXAME_LANCAR") |
| nome | varchar(120) | NOT NULL | - | Nome descritivo da permissão |
| descricao | text | YES | NULL | Descrição detalhada da permissão e sua finalidade |
| dominio | varchar(40) | YES | 'GERAL' | Domínio da permissão (ex: "ATENDIMENTO", "FARMACIA", "LABORATORIO") |
| nome_procedure | varchar(120) | YES | NULL | Nome da procedure stored que a permissão autoriza executar |
| acao_frontend | varchar(80) | YES | NULL | Ação frontend que a permissão autoriza (ex: "painel_medico") |
| metadata | json | YES | NULL | Metadados adicionais da permissão em formato JSON |
| ativo | tinyint | YES | '1' | Flag indicando se a permissão está ativa |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação da permissão |
| grupo_menu | varchar(60) | YES | NULL | Grupo do menu onde a permissão aparece (ex: "ADMIN", "AMBULANCIA") |
| icone | varchar(60) | YES | NULL | Ícone a ser exibido no menu |
| ordem_menu | int | YES | NULL | Ordem de exibição no menu |
| visivel_menu | tinyint | YES | '1' | Flag indicando se a permissão deve aparecer no menu |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant (NULL para permissões globais) |

## Chaves
- Primária: id_permissao
- Únicas: uk_permissao_codigo (codigo)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_permissao)
- UNIQUE KEY uk_permissao_codigo (codigo)
- KEY idx_perm_dominio (dominio)
- KEY idx_perm_ativo (ativo)

## Constraints
- PRIMARY KEY: id_permissao
- UNIQUE: uk_permissao_codigo

## Relacionamentos e Cardinalidade
- 1:N com perfil_permissao: Uma permissão pode pertencer a muitos perfis
- N:1 com saas_entidade: Muitas permissões pertencem a uma entidade (ou são globais)

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: perfil_permissao

## Fluxo de utilização dentro do sistema
Utilizada como catálogo de todas as permissões do sistema. Perfis são associados às permissões via perfil_permissao. O campo dominio agrupa permissões por módulo (ATENDIMENTO, FARMACIA, etc.). O campo grupo_menu, icone e ordem_menu controlam a exibição no menu da interface. Permite controle granular de acesso.