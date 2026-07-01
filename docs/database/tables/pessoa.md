# pessoa

Objetivo: Armazenar dados pessoais de todas as pessoas do sistema (pacientes, funcionários, profissionais).
Descrição: Tabela mestre que contém informações de todas as pessoas envolvidas no sistema, incluindo pacientes, profissionais de saúde, funcionários, acompanhantes e outros tipos. Serve como base para demais tabelas de identificação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa | bigint | NOT NULL | - | Identificador único da pessoa (chave primária, auto incremento) |
| nome | varchar(200) | NOT NULL | - | Nome completo da pessoa |
| nome_social | varchar(200) | YES | NULL | Nome social (para pessoas que usam nome diferente do registrado) |
| sexo | enum('MASCULINO','FEMININO','NAO_INFORMADO') | YES | 'NAO_INFORMADO' | Sexo da pessoa |
| identidade_genero | enum('CIS_MASCULINO','CIS_FEMININO','TRANS_MASCULINO','TRANS_FEMININO','NAO_BINARIO','NAO_INFORMADO') | YES | 'NAO_INFORMADO' | Identidade de gênero da pessoa |
| data_nascimento | date | YES | NULL | Data de nascimento da pessoa |
| nacionalidade | varchar(100) | YES | NULL | Nacionalidade da pessoa |
| naturalidade | varchar(150) | YES | NULL | Naturalidade (cidade de nascimento) da pessoa |
| nome_mae | varchar(200) | YES | NULL | Nome completo da mãe da pessoa |
| nome_pai | varchar(200) | YES | NULL | Nome completo do pai da pessoa |
| estado_civil | enum('SOLTEIRO','CASADO','DIVORCIADO','VIUVO','UNIAO_ESTAVEL','NAO_INFORMADO') | YES | 'NAO_INFORMADO' | Estado civil da pessoa |
| tipo_pessoa | enum('PACIENTE','FUNCIONARIO','PROFISSIONAL_SAUDE','ACOMPANHANTE','RESPONSAVEL','CLIENTE','FORNECEDOR','OUTRO') | YES | 'OUTRO' | Tipo de pessoa: paciente, funcionário, profissional de saúde, etc. |
| foto_url | varchar(500) | YES | NULL | URL da foto da pessoa |
| ativo | tinyint(1) | YES | '1' | Flag indicando se a pessoa está ativa no sistema |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a pessoa pertence |

## Chaves
- Primária: id_pessoa
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pessoa_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id_pessoa)
- KEY idx_pessoa_nome (nome)
- KEY idx_pessoa_nome_social (nome_social)
- KEY idx_pessoa_nascimento (data_nascimento)
- KEY idx_pessoa_tipo (tipo_pessoa, ativo)
- KEY idx_pessoa_entidade (id_entidade)

## Constraints
- PRIMARY KEY: id_pessoa
- FOREIGN KEY: fk_pessoa_entidade

## Relacionamentos e Cardinalidade
- 1:1 com paciente: Uma pessoa pode ser paciente
- 1:N com paciente_alertas: Uma pessoa pode ter muitos alertas
- 1:N com pessoa_alergias: Uma pessoa pode ter muitas alergias
- 1:N com pessoa_conselho_registro: Uma pessoa pode ter muitos registros em conselhos
- 1:N com pessoa_contato: Uma pessoa pode ter muitos contatos
- 1:N com pessoa_documento: Uma pessoa pode ter muitos documentos
- 1:N com pessoa_email: Uma pessoa pode ter muitos emails
- 1:N com pessoa_endereco: Uma pessoa pode ter muitos endereços
- 1:N com pessoa_identificador: Uma pessoa pode ter muitos identificadores
- 1:N com pessoa_logradouro: Uma pessoa pode ter muitos logradouros
- 1:N com pessoa_telefone: Uma pessoa pode ter muitos telefones
- 1:N com pessoa_vinculo: Uma pessoa pode ter muitos vínculos familiares

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: paciente, paciente_alertas, pessoa_alergias, pessoa_conselho_registro, pessoa_contato, pessoa_documento, pessoa_email, pessoa_endereco, pessoa_identificador, pessoa_logradouro, pessoa_telefone, pessoa_vinculo

## Fluxo de utilização dentro do sistema
Utilizada como cadastro principal de todas as pessoas. Quando um paciente chega, é criado ou atualizado um registro aqui. Profissionais de saúde também são cadastrados como pessoas com tipo_pessoa=PROFISSIONAL_SAUDE. As tabelas específicas (paciente, paciente_alertas, etc.) complementam com informações detalhadas. Permite manter um registro único de identidade para cada pessoa.