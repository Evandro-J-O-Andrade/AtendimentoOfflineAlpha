# logradouro

Objetivo: Manter cadastro de logradouros para endereçamento de pacientes e unidades de saúde.
Descrição: Tabela que armazena informações de logradouros (ruas, avenidas) com CEP, complemento, bairro, cidade e UF. Usada como referência para endereços em todo o sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_logradouro` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do logradouro |
| `cep` | varchar(9) | NOT NULL | - | CEP do logradouro (formato com máscara) |
| `logradouro` | varchar(200) | NOT NULL | - | Nome do logradouro (rua, avenida, etc.) |
| `numero` | varchar(20) | NULL | NULL | Número do imóvel (pode ser texto para "s/n") |
| `complemento` | varchar(100) | NULL | NULL | Complemento do endereço (ex: "apto 101") |
| `bairro` | varchar(100) | NULL | NULL | Nome do bairro |
| `cidade` | varchar(100) | NULL | NULL | Nome da cidade |
| `uf` | char(2) | NULL | NULL | Unidade da Federação (ex: "SP", "RJ") |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_logradouro`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Muitos logradouros pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Logradouros são cadastrados ou importados via integração com serviço de CEP
2. Usados como referência para endereços de pacientes
3. Usados para endereços de unidades de saúde (UPA, hospitais)
4. O CEP permite integração com sistemas externos
5. Usado para geolocalização e cálculo de distâncias
6. Base para relatórios geográficos de atendimentos
7. Usado em integração com sistemas de regulação
8. Permite autocomplete de endereços no frontend