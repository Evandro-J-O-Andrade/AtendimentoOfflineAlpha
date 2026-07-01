# prescritor_externo

Objetivo: Registrar profissionais externos que podem prescrever medicamentos ou serviços fora da instituição, com dados de registro profissional.

Descrição: Tabela que armazena informações de profissionais externos (médicos de clínicas externas, profissionais de convênios, etc.) que realizam prescrições ou encaminhamentos para a instituição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_prescritor_externo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do prescritor externo |
| nome | varchar(150) | NOT NULL | - | Nome completo do profissional externo |
| conselho | enum('CRM','CRO','COREN','CRF','OUTRO') | NOT NULL | 'CRM' | Tipo de conselho profissional: CRM (médico), CRO (dentista), COREN (enfermagem), CRF (farmácia), OUTRO |
| numero_conselho | varchar(30) | NOT NULL | - | Número do registro no conselho profissional |
| uf | char(2) | YES | NULL | Unidade federativa da inscrição do conselho |
| documento | varchar(30) | YES | NULL | Documento de identificação do profissional (CPF, RG, etc.) |
| telefone | varchar(30) | YES | NULL | Telefone de contato do profissional externo |
| ativo | tinyint(1) | NOT NULL | '1' | Flag indicando se o prescritor externo está ativo no sistema |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de cadastro do prescritor externo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o prescritor está cadastrado |

## Chaves
- Primária: id_prescritor_externo
- Únicas: uk_prescritor_conselho (conselho, numero_conselho, uf)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_prescritor_externo)
- UNIQUE KEY uk_prescritor_conselho (conselho, numero_conselho, uf)
- KEY idx_prescritor_nome (nome)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com outras tabelas que referenciem prescritores externos (ex: receitas, encaminhamentos)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Cadastrado quando um profissional externo precisa ser identificado
- Usado para validar receitas e encaminhamentos de clínicas externas
- Permite contato com profissionais externos
- Referenciado em documentos e receitas médicas