# auth_parametro

Objetivo: Armazenar parâmetros de configuração do sistema de autenticação e segurança.
Descrição: Tabela de parâmetros que controla configurações de senha, sessão, token e bloqueio de usuários, permitindo ajustes sem alterações no código.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_parametro | bigint | NOT NULL | - | Identificador único do parâmetro, chave primária auto incrementada. |
| chave | varchar(100) | NOT NULL | - | Chave única do parâmetro (ex: senha_tamanho_minimo, sessao_duracao_horas). |
| valor | text | NOT NULL | - | Valor do parâmetro em formato texto. |
| descricao | text | Nullable | - | Descrição do propósito e uso do parâmetro. |
| tipo_parametro | enum('SENHA','SESSAO','TOKEN','BLOQUEIO','GERAL') | Nullable | 'GERAL' | Tipo: senha, sessão, token, bloqueio ou geral. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o parâmetro está ativo. |
| id_entidade | bigint unsigned | Nullable | - | Referência à entidade (pode ser nulo para parâmetros globais). |

## Chaves
- Primária: id_parametro
- Únicas: uk_parametro_chave (chave)
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_parametro)
- UNIQUE KEY uk_parametro_chave (chave)

## Constraints
- PRIMARY KEY: id_parametro
- UNIQUE: uk_parametro_chave (chave)

## Relacionamentos e Cardinalidade
- N:1 com saas_entidade (id_entidade) - opcional

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: saas_entidade (opcional)

## Fluxo de utilização dentro do sistema
- Lida durante validação de senha para aplicar regras configuráveis
- Usada para definir duração de sessão, tentativas de login e tempo de bloqueio
- Permite ajustes de política de segurança sem deployment
- Parâmetros comuns incluem: tamanho mínimo de senha, exigência de maiúscula, minúscula, números, dias até expiração