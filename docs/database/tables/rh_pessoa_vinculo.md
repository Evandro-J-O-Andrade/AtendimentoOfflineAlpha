# rh_pessoa_vinculo

Objetivo: Gerenciar vínculos de pessoas no sistema de recursos humanos, incluindo funcionários, terceirizados, estagiários e prestadores de serviço.

Descrição: Tabela que mantém os vínculos de pessoas com a instituição, permitindo diferentes tipos de vínculo (funcionário, terceiro, estagiário, prestador, voluntário) e controle de matrícula, CPF, RG, datas e status do vínculo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_rh_vinculo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do vínculo RH |
| id_pessoa | bigint | NOT NULL | - | Referência ao id da pessoa vinculada |
| tipo_vinculo | enum('FUNCIONARIO','TERCEIRO','ESTAGIARIO','PRESTADOR','VOLUNTARIO') | NOT NULL | 'FUNCIONARIO' | Tipo de vínculo: FUNCIONARIO, TERCEIRO, ESTAGIARIO, PRESTADOR ou VOLUNTARIO |
| matricula | varchar(40) | YES | NULL | Número da matrícula do funcionário |
| cpf | varchar(14) | YES | NULL | CPF da pessoa vinculada |
| rg | varchar(30) | YES | NULL | RG da pessoa vinculada |
| orgao_emissor | varchar(20) | YES | NULL | Órgão emissor do RG |
| pis_pasep | varchar(20) | YES | NULL | PIS/PASEP do funcionário |
| data_admissao | date | YES | NULL | Data de admissão no vínculo |
| data_demissao | date | YES | NULL | Data de demissão ou término do vínculo |
| status | enum('ATIVO','INATIVO','AFASTADO') | NOT NULL | 'ATIVO' | Status do vínculo: ATIVO, INATIVO ou AFASTADO |
| id_unidade_lotacao | bigint | YES | NULL | Referência ao id da unidade onde a pessoa está lotada |
| id_local_lotacao | bigint | YES | NULL | Referência ao id do local de lotação |
| cargo | varchar(120) | YES | NULL | Cargo ocupado pela pessoa |
| setor | varchar(120) | YES | NULL | Setor onde a pessoa trabalha |
| email | varchar(120) | YES | NULL | Email de contato da pessoa |
| telefone | varchar(40) | YES | NULL | Telefone de contato da pessoa |
| endereco | varchar(255) | YES | NULL | Endereço da pessoa |
| observacao | text | YES | NULL | Observações sobre o vínculo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do vínculo |
| atualizado_em | datetime | YES | NULL | Data e hora da última atualização do vínculo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o vínculo ocorre |

## Chaves
- Primária: id_rh_vinculo
- Únicas: uk_rh_matricula (matricula)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_rh_vinculo)
- UNIQUE KEY uk_rh_matricula (matricula)
- KEY ix_rh_pessoa (id_pessoa)
- KEY ix_rh_status (status)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com pessoa (uma pessoa pode ter vários vínculos na instituição)
- 1:N com rh_registro_profissional (um vínculo pode ter vários registros profissionais)

## Dependências
- Tabelas que dependem desta: rh_evento
| Esta tabela depende de: pessoa

## Fluxo de utilização dentro do sistema
- Criado ao vincular uma pessoa ao sistema de RH
- Permite diferentes tipos de vínculo (funcionário, terceiro, etc.)
- Matrícula única permite identificação rápida
- Status permite controle de afastamentos e inatividades