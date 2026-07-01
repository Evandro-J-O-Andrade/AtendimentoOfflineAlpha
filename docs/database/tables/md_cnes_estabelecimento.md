# md_cnes_estabelecimento

Objetivo: Manter cadastro de estabelecimentos de saúde (CNES) para integração e referência.
Descrição: Tabela que armazena informações de estabelecimentos de saúde obtidas do Cadastro Nacional de Estabelecimentos (CNES), incluindo dados de localização e tipo de gestão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `cnes` | char(7) | NOT NULL | - | Código CNES do estabelecimento (7 dígitos) |
| `competencia` | char(6) | NULL | NULL | Competência da versão dos dados |
| `nome_fantasia` | varchar(255) | NULL | NULL | Nome fantasia do estabelecimento |
| `razao_social` | varchar(255) | NULL | NULL | Razão social completa |
| `cnpj` | varchar(20) | NULL | NULL | CNPJ do estabelecimento |
| `uf` | char(2) | NULL | NULL | Unidade da Federação |
| `municipio_ibge` | varchar(10) | NULL | NULL | Código IBGE do município |
| `logradouro` | varchar(255) | NULL | NULL | Logradouro do estabelecimento |
| `numero` | varchar(30) | NULL | NULL | Número do estabelecimento |
| `bairro` | varchar(120) | NULL | NULL | Bairro do estabelecimento |
| `cep` | varchar(12) | NULL | NULL | CEP do estabelecimento |
| `telefone` | varchar(30) | NULL | NULL | Telefone do estabelecimento |
| `tipo_gestao` | varchar(30) | NULL | NULL | Tipo de gestão (ex: "Municipal", "Estadual", "Privada") |
| `esfera_adm` | varchar(30) | NULL | NULL | Esfera administrativa |
| `ativo` | tinyint(1) | NOT NULL | '1' | Indica se o estabelecimento está ativo (1) ou inativo (0) |
| `atualizado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `cnes`
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_cnes_comp` (KEY) - Índice em `competencia`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `md_competencia` - Muitos estabelecimentos pertencem a uma competência
- N:1 com `saas_entidade` - Muitos estabelecimentos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `md_competencia`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Arquivo CNES é baixado mensalmente do Ministério da Saúde
2. Dados são importados e atualizados nesta tabela
3. O código CNES é usado para integração com sistemas municipais/estaduais
4. Usado para validação de estabelecimentos em notificações
5. Permite buscar unidades de referência para encaminhamentos
6. Usado para geolocalização de serviços de saúde
7. Base para relatórios de redes de atenção à saúde
8. Integração com sistema de regulação para validação de unidades