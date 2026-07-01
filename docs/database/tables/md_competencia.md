# md_competencia

Objetivo: Controlar as competências (períodos) para as quais os arquivos de dados fonte são válidos.
Descrição: Tabela que mantém o registro das competências de processamento de arquivos fonte, permitindo o controle de múltiplas versões de tabelas auxiliares.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `competencia` | char(6) | NOT NULL | - | Código da competência (ex: "202401" para jan/2024) |
| `descricao` | varchar(80) | NULL | NULL | Descrição da competência (ex: "Janeiro/2024") |
| `dt_inicio` | date | NULL | NULL | Data de início da competência |
| `dt_fim` | date | NULL | NULL | Data de fim da competência |
| `ativa` | tinyint(1) | NOT NULL | '1' | Indica se a competência está ativa (1) ou inativa (0) |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `competencia`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- 1:N com `md_cid10` - Uma competência pode ter muitos códigos
- 1:N com `md_cnes_estabelecimento` - Uma competência pode ter muitos estabelecimentos
- 1:N com `md_sigpat_medicamento` - Uma competência pode ter muitos medicamentos
- 1:N com `md_sigtap_procedimento` - Uma competência pode ter muitos procedimentos
- 1:N com `md_arquivo_fonte` - Uma competência pode ter muitos arquivos fonte
- N:1 com `saas_entidade` - Muitas competências pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: `md_cid10`, `md_cnes_estabelecimento`, `md_sigpat_medicamento`, `md_sigtap_procedimento`, `md_arquivo_fonte`
- Esta tabela depende de: `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Competências são criadas manualmente ou automáticas via script
2. Arquivos fonte são associados a uma competência
3. Múltiplas versões podem coexistir (ex: 202301, 202401)
4. Apenas uma competência é marcada como `ativa=1` por tipo
5. Sistema usa competência ativa para busca padrão
6. Histórico permite busca em versões anteriores
7. Usado para versionamento de tabelas auxiliares
8. Base para relatórios comparativos entre períodos