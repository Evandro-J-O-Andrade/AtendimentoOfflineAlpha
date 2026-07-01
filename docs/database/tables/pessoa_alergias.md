# pessoa_alergias

Objetivo: Registrar alergias específicas de cada pessoa.
Descrição: Tabela que armazena substâncias às quais uma pessoa é alérgica, com grau de gravidade e informações sobre o registro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de alergia (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual a alergia está vinculada |
| substancia | varchar(255) | NOT NULL | - | Nome da substância à qual a pessoa é alérgica (ex: "Dipirona", "Penicilina") |
| gravidade | enum('LEVE','MODERADA','GRAVE/CHOQUE') | YES | NULL | Grau de gravidade da reação alérgica |
| registrado_por | bigint | YES | NULL | ID do usuário que registrou a alergia |
| data_registro | datetime | YES | CURRENT_TIMESTAMP | Data/hora do registro da alergia |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_alergia_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id)
- KEY fk_alergia_pessoa (id_pessoa)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_alergia_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitas alergias pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar alergias conhecidas de uma pessoa. Ao marcar alergia durante cadastro ou atendimento, o registro é armazenado aqui. O grau de gravidade é importante para alertas clínicos. Permite que ao criar prescrições ou administrar medicamentos, o sistema verifique as alergias e gere alertas de segurança.