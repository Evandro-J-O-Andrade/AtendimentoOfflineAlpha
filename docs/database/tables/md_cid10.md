# md_cid10

Objetivo: Armazenar códigos e descrições do CID10 (Classificação Internacional de Doenças) para classificação clínica.
Descrição: Tabela que contém a lista completa de códigos CID10 importados do Ministério da Saúde, incluindo descrição, categoria, restrições de sexo e idade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `competencia` | char(6) | NOT NULL | - | Competência da versão (ex: "202401") |
| `codigo` | varchar(10) | NOT NULL | - | Código CID10 (ex: "J45", "E11") |
| `descricao` | varchar(255) | NOT NULL | - | Descrição completa da doença |
| `categoria` | varchar(10) | NULL | NULL | Categoria da doença (ex: "NEOPLASIA", "DOENÇA CARDIOVASCULAR") |
| `subcategoria` | varchar(10) | NULL | NULL | Subcategoria do código CID |
| `capitulo` | varchar(20) | NULL | NULL | Capítulo da classificação CID |
| `sexo_restricao` | enum('A','M','F') | NOT NULL | 'A' | Restrição de sexo: A (ambos), M (masculino), F (feminino) |
| `idade_min_meses` | int | NULL | NULL | Idade mínima em meses para a doença |
| `idade_max_meses` | int | NULL | NULL | Idade máxima em meses para a doença |
| `ativo` | tinyint(1) | NOT NULL | '1' | Indica se o código está ativo (1) ou inativo (0) |
| `atualizado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `competencia`,`codigo` (chave composta)
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_cid10_codigo` (KEY) - Índice em `codigo`
- `idx_cid10_comp` (KEY) - Índice em `competencia`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `md_competencia` - Muitos códigos pertencem a uma competência
- N:1 com `saas_entidade` - Muitos códigos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: `notificacao_epidemiologica`, `notificacao_violencia`
- Esta tabela depende de: `md_competencia`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Arquivo CID10 é baixado e processado periodicamente
2. Cada código é armazenado com descrição e restrições
3. A restrição de sexo permite validação clínica
4. Idade mínima/máxima permite alertas de inconsistência
5. Usado para classificação de diagnósticos em prontuários
6. Base para notificações epidemiológicas obrigatórias
7. Integração com sistema de regulação para códigos válidos
8. Usado para geração de códigos QR para prontuários
9. Permite busca por descrição parcial