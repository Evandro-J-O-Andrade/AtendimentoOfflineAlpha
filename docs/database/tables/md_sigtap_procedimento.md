# md_sigtap_procedimento

Objetivo: Armazenar procedimentos padronizados do SIGTAP para padronização de procedimentos médicos.
Descrição: Tabela que contém a lista de procedimentos padronizados do Sistema de Gerenciamento de Tabela de Procedimentos (SIGTAP), incluindo valores de referência e restrições clínicas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `competencia` | char(6) | NOT NULL | - | Competência da versão (ex: "202401") |
| `codigo` | varchar(10) | NOT NULL | - | Código do procedimento no SIGTAP |
| `nome` | varchar(255) | NOT NULL | - | Nome completo do procedimento |
| `complexidade` | enum('BASICA','MEDIA','ALTA') | NULL | NULL | Nível de complexidade do procedimento |
| `sexo_restricao` | enum('A','M','F') | NOT NULL | 'A' | Restrição de sexo: A (ambos), M (masculino), F (feminino) |
| `idade_min_meses` | int | NULL | NULL | Idade mínima em meses para o procedimento |
| `idade_max_meses` | int | NULL | NULL | Idade máxima em meses para o procedimento |
| `valor_sa` | decimal(10,2) | NULL | NULL | Valor SA (Sistema Agindo) do procedimento |
| `valor_sh` | decimal(10,2) | NULL | NULL | Valor SH (Sistema Honorário) do procedimento |
| `valor_sus` | decimal(10,2) | NULL | NULL | Valor SUS do procedimento |
| `ativo` | tinyint(1) | NOT NULL | '1' | Indica se o procedimento está ativo (1) ou inativo (0) |
| `atualizado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `competencia`,`codigo` (chave composta)
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_sigtap_codigo` (KEY) - Índice em `codigo`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `md_competencia` - Muitos procedimentos pertencem a uma competência
- N:1 com `saas_entidade` - Muitos procedimentos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `md_competencia`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Dados do SIGTAP são importados mensalmente do Ministério da Saúde
2. Cada procedimento tem código único e nome padronizado
3. Complexidade afeta tempo de realização e recursos necessários
4. Restrição de sexo e idade são usadas para validação clínica
5. Valores SA, SH e SUS são usados para faturamento e custos
6. Usado para padronização em solicitações de exames
7. Integração com sistema de faturamento e regulação
8. Base para cálculo de RAIM e custos operacionais