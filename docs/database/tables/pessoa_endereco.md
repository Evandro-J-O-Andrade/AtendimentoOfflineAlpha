# pessoa_endereco

Objetivo: Armazenar endereços de uma pessoa.
Descrição: Tabela que mantém os endereços de uma pessoa com georreferenciamento, permitindo armazenar múltiplos endereços (residencial, comercial, emergência) com datas de validade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_endereco | bigint | NOT NULL | - | Identificador único do endereço (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o endereço pertence |
| id_cidade | bigint | YES | NULL | ID da cidade do endereço |
| tipo | enum('RESIDENCIAL','COMERCIAL','CORRESPONDENCIA','EMERGENCIA','OUTRO') | YES | 'RESIDENCIAL' | Tipo de endereço: residencial, comercial, correspondência, emergência ou outro |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o endereço principal da pessoa |
| cep | varchar(10) | YES | NULL | CEP do endereço |
| logradouro | varchar(150) | YES | NULL | Nome da rua/avenida |
| numero | varchar(20) | YES | NULL | Número do imóvel |
| complemento | varchar(100) | YES | NULL | Complemento do endereço (ex: "apto 101", "casa 2") |
| bairro | varchar(120) | YES | NULL | Nome do bairro |
| referencia | varchar(200) | YES | NULL | Ponto de referência para localização |
| latitude | decimal(10,7) | YES | NULL | Latitude para georreferenciamento |
| longitude | decimal(10,7) | YES | NULL | Longitude para georreferenciamento |
| valido_de | date | YES | NULL | Data de início da validade do endereço |
| valido_ate | date | YES | NULL | Data de fim da validade do endereço |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o endereço está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o endereço pertence |

## Chaves
- Primária: id_pessoa_endereco
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pessoa_endereco_cidade: id_cidade → cidade (id_cidade)
  - fk_pessoa_endereco_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_endereco)
- KEY idx_pessoa_endereco_pessoa (id_pessoa)
- KEY idx_pessoa_endereco_cidade (id_cidade)
- KEY idx_pessoa_endereco_principal (principal)

## Constraints
- PRIMARY KEY: id_pessoa_endereco
- FOREIGN KEY: fk_pessoa_endereco_cidade
- FOREIGN KEY: fk_pessoa_endereco_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos endereços pertencem a uma pessoa
- N:1 com cidade: Muitos endereços podem ter uma cidade associada

## Dependências
- Esta tabela depende de: pessoa, cidade, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para armazenar todos os endereços de uma pessoa. Permite múltiplos endereços com diferentes tipos (residencial, comercial). O georreferenciamento (latitude/longitude) permite localização no mapa e cálculo de rotas. As datas de validade permitem histórico de endereços antigos.