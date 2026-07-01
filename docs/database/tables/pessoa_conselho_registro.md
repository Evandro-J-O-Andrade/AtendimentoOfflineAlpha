# pessoa_conselho_registro

Objetivo: Armazenar registros de profissionais em conselhos profissionais.
Descrição: Tabela que mantém os registros de profissionais de saúde nos conselhos (CRM, COREN, CRO, etc.), permitindo validar a qualificação e habilitação dos profissionais.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_conselho | bigint | NOT NULL | - | Identificador único do registro (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa/profissional registrado no conselho |
| id_conselho | int | NOT NULL | - | ID do tipo de conselho (CRM=medicina, COREN=enfermagem, etc.) |
| uf_registro | char(2) | NOT NULL | - | Unidade da federação onde está registrado (ex: "SP", "RJ") |
| registro | varchar(30) | NOT NULL | - | Número do registro no conselho (ex: "123456") |
| eh_principal | tinyint(1) | NOT NULL | '0' | Flag indicando se este é o registro principal do profissional |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se o registro está ativo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora do registro no sistema |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o registro pertence |

## Chaves
- Primária: id_pessoa_conselho
- Únicas: uk_pessoa_conselho (id_pessoa, id_conselho, uf_registro, registro)
- Estrangeiras: 
  - fk_pcr_conselho: id_conselho → conselho_profissional (id_conselho)
  - fk_pcr_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_conselho)
- UNIQUE KEY uk_pessoa_conselho (id_pessoa, id_conselho, uf_registro, registro)
- KEY idx_pessoa_principal (id_pessoa, eh_principal, ativo)
- KEY idx_conselho_registro (id_conselho, uf_registro, registro)

## Constraints
- PRIMARY KEY: id_pessoa_conselho
- UNIQUE: uk_pessoa_conselho
- FOREIGN KEY: fk_pcr_conselho
- FOREIGN KEY: fk_pcr_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos registros de conselho pertencem a uma pessoa
- N:1 com conselho_profissional: Muitos registros pertencem a um tipo de conselho

## Dependências
- Esta tabela depende de: pessoa, conselho_profissional, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para validar a habilitação dos profissionais de saúde. Ao cadastrar um médico ou enfermeiro, são registrados os conselhos onde está registrado. O campo eh_principal indica qual conselho é o principal para CRM do profissional. Permite verificar se o profissional está habilitado legalmente para exercer a função.