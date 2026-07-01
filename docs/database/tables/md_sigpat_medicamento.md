# md_sigpat_medicamento

Objetivo: Armazenar medicamentos padronizados do SIGPAT para padronização de medicamentos no sistema.
Descrição: Tabela que contém a lista de medicamentos padronizados do Ministério da Saúde (SIGPAT), incluindo apresentação, forma farmacêutica, concentração e via de administração.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `competencia` | char(6) | NOT NULL | - | Competência da versão (ex: "202401") |
| `codigo` | varchar(20) | NOT NULL | - | Código do medicamento no SIGPAT |
| `descricao` | varchar(255) | NOT NULL | - | Descrição completa do medicamento |
| `apresentacao` | varchar(160) | NULL | NULL | Apresentação do medicamento (ex: "Comprimido 500mg") |
| `forma_farmaceutica` | varchar(80) | NULL | NULL | Forma farmacêutica (ex: "Comprimido", "Xarope") |
| `concentracao` | varchar(60) | NULL | NULL | Concentração do medicamento |
| `unidade_medida` | varchar(30) | NULL | NULL | Unidade de medida (ex: "mg", "ml", "g") |
| `via_administracao` | varchar(60) | NULL | NULL | Via de administração (ex: "Oral", "Intravenosa") |
| `ativo` | tinyint(1) | NOT NULL | '1' | Indica se o medicamento está ativo (1) ou inativo (0) |
| `atualizado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `competencia`,`codigo` (chave composta)
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_sigpat_codigo` (KEY) - Índice em `codigo`
- `idx_sigpat_comp` (KEY) - Índice em `competencia`
- `idx_sigpat_desc` (KEY) - Índice em `descricao`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `md_competencia` - Muitos medicamentos pertencem a uma competência
- N:1 com `saas_entidade` - Muitos medicamentos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `md_competencia`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Dados são importados mensalmente do SIGPAT do Ministério da Saúde
2. Medicamentos são usados para padronização em prescrições
3. Via de administração ajuda na validação de prescrições
4. Forma farmacêutica e concentração são usados em dispensação
5. Campo `ativo` permite desativar medicamentos removidos do padrão
6. Usado para evitar nomes genéricos em prescrições
7. Integração com sistema de farmácia para validação de medicamentos
8. Base para alertas de terapia ambígua