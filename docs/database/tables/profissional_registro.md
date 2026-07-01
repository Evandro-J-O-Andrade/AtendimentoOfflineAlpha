# profissional_registro

Objetivo: Armazenar os registros profissionais dos funcionários com informações de conselhos, números de registro e validades.

Descrição: Tabela que mantém os registros profissionais dos funcionários vinculados a conselhos de classe (CRM, COREN, CRF, etc.), permitindo controle das validades e status dos registros.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_profissional_registro | bigint | NOT NULL | - | Chave primária da tabela, identificador único do registro profissional |
| id_funcionario | bigint | NOT NULL | - | Referência ao id do funcionário ao qual o registro está vinculado |
| tipo_conselho | enum('CRM','COREN','CRF','CREFITO','CRN','CRP','OUTRO') | NOT NULL | - | Tipo do conselho profissional: CRM (médico), COREN (enfermagem), CRF (farmácia), CREFITO (fisioterapia), CRN (nutrição), CRP (psicologia), OUTRO |
| numero_registro | varchar(50) | NOT NULL | - | Número do registro no conselho profissional |
| uf_registro | char(2) | NOT NULL | - | Unidade federativa da inscrição do conselho |
| data_emissao | date | YES | NULL | Data de emissão do registro profissional |
| data_validade | date | YES | NULL | Data de validade/renovação do registro |
| ativo | tinyint(1) | - | '1' | Flag indicando se o registro está ativo |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de cadastro do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o registro é mantido |

## Chaves
- Primária: id_profissional_registro
- Únicas: -
- Estrangeiras: fk_pr_funcionario (id_funcionario → funcionario.id_funcionario) - vincula o registro ao funcionário

## Índices
- PRIMARY KEY (id_profissional_registro)
- KEY idx_pr_funcionario (id_funcionario)

## Constraints
- CONSTRAINT fk_pr_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario)

## Relacionamentos e Cardinalidade
- N:1 com funcionario (um funcionário pode ter vários registros profissionais em conselhos diferentes)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: funcionario

## Fluxo de utilização dentro do sistema
- Criado ao vincular um registro profissional a um funcionário
- Permite controle de validade para renovação de registros
- Usado para validação de credenciais profissionais
- Integrado ao módulo de recursos humanos