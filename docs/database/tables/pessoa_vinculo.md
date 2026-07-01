# pessoa_vinculo

Objetivo: Registrar vínculos familiares e responsáveis entre pessoas.
Descrição: Tabela que mantém relações familiares e de responsabilidade entre pessoas, como responsável legal, cuidador, familiar, cônjuge, pai, mãe, filho ou tutor.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_vinculo | bigint | NOT NULL | - | Identificador único do vínculo (chave primária, auto incremento) |
| id_pessoa_origem | bigint | NOT NULL | - | ID da pessoa que origina o vínculo (ex: paciente) |
| id_pessoa_destino | bigint | NOT NULL | - | ID da pessoa de destino do vínculo (ex: responsável) |
| tipo_vinculo | enum('RESPONSAVEL','ACOMPANHANTE','FAMILIAR','CONJUGE','PAI','MAE','FILHO','TUTOR','CUIDADOR','RESPONSAVEL_CLINICO','OUTRO') | NOT NULL | - | Tipo do vínculo: responsável, acompanhante, familiar, cônjuge, pai, mãe, filho, tutor, cuidador, responsável clínico ou outro |
| observacao | text | YES | NULL | Observações sobre o vínculo |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o vínculo está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do vínculo |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o vínculo pertence |

## Chaves
- Primária: id_pessoa_vinculo
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_vinculo_pessoa_destino: id_pessoa_destino → pessoa (id_pessoa)
  - fk_vinculo_pessoa_origem: id_pessoa_origem → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_vinculo)
- KEY idx_vinculo_origem (id_pessoa_origem)
- KEY idx_vinculo_destino (id_pessoa_destino)

## Constraints
- PRIMARY KEY: id_pessoa_vinculo
- FOREIGN KEY: fk_vinculo_pessoa_destino
- FOREIGN KEY: fk_vinculo_pessoa_origem

## Relacionamentos e Cardinalidade
- N:1 com pessoa (origem): Muitos vínculos podem ter uma pessoa origem
- N:1 com pessoa (destino): Muitos vínculos podem ter uma pessoa destino

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar responsáveis legais por menores, acompanhantes, cuidadores ou familiares. Ao cadastrar um paciente menor de idade, é criado um vínculo com o responsável legal. Permite acompanhar entradas familiares e identificar pessoas autorizadas a tomar decisões. O campo RESPONSAVEL_CLINICO é usado para indicar profissional responsável pelo caso.