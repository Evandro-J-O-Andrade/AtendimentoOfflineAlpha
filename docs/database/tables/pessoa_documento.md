# pessoa_documento

Objetivo: Armazenar documentos oficiais de uma pessoa (CPF, RG, CNS, CRM, etc.).
Descrição: Tabela que mantém todos os documentos oficiais de uma pessoa, incluindo CPF, RG, CNS, CRM, CNH, passaporte, PIS, NIS e outros tipos, com informações de validade e emissão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_documento | bigint | NOT NULL | - | Identificador único do documento (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o documento pertence |
| tipo_documento | enum('CPF','RG','CNS','CRM','COREN','CRO','CRF','CNH','PASSAPORTE','PIS','NIS','OUTRO') | NOT NULL | - | Tipo do documento: CPF, RG, CNS, CRM, etc. |
| numero | varchar(50) | NOT NULL | - | Número do documento |
| orgao_emissor | varchar(50) | YES | NULL | Órgão emissor do documento (ex: "SSP", "CRM-SP") |
| uf_emissor | char(2) | YES | NULL | Unidade da federação do emissor (ex: "SP", "RJ") |
| data_emissao | date | YES | NULL | Data de emissão do documento |
| data_validade | date | YES | NULL | Data de validade do documento (para documentos com validade) |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o documento principal da pessoa |
| observacao | varchar(300) | YES | NULL | Observações sobre o documento |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o documento está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o documento pertence |

## Chaves
- Primária: id_pessoa_documento
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pessoa_documento_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_documento)
- KEY idx_doc_pessoa (id_pessoa)
- KEY idx_doc_tipo (tipo_documento)
- KEY idx_doc_numero (numero)

## Constraints
- PRIMARY KEY: id_pessoa_documento
- FOREIGN KEY: fk_pessoa_documento_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos documentos pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar todos os documentos oficiais de uma pessoa. Ao cadastrar paciente ou profissional, são inseridos CPF, RG, CNS, etc. O campo principal indica o documento principal para identificação. Permite validar documentos e detectar duplicidades. A data de validade é importante para documentos como CNH ou CRM que precisam ser renovados.