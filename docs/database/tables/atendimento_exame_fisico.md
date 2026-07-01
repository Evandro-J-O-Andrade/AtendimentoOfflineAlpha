# atendimento_exame_fisico

Objetivo: Registrar o exame físico completo do paciente durante atendimentos, permitindo o registro estruturado de avaliações por sistema corporal.

Descrição: Esta tabela armazena os resultados do exame físico realizado durante atendimentos médicos, registrando avaliações por sistema (cabeça/pescoço, tórax, abdômen, membros, neurologico) com auditoria completa.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de exame físico |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde o exame foi realizado |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o exame pertence |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário que realizou o exame |
| id_sessao_usuario | bigint | NOT NULL | - | Identificador da sessão do usuário no momento do exame |
| cabeca_pescoco | text | YES | NULL | Avaliação do sistema cabeça e pescoço |
| torax | text | YES | NULL | Avaliação do sistema tórax |
| abdome | text | YES | NULL | Avaliação do sistema abdômen |
| membros | text | YES | NULL | Avaliação dos membros (braços e pernas) |
| neurologico | text | YES | NULL | Avaliação neurológica do paciente |
| ip_origem | varchar(45) | YES | NULL | Endereço IP de origem da requisição |
| device_info | varchar(255) | YES | NULL | Informações do dispositivo utilizado |
| criado_em | datetime(6) | YES | NULL | Timestamp da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o exame pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_aexf_unid - id_unidade → unidade(id_unidade) - Vincula o exame à unidade; fk_atendimento_exame_fisico_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o exame ao atendimento; fk_atendimento_exame_fisico_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o exame à entidade |

## Índices
- fk_atendimento_exame_fisico_atendimento (KEY) - Índice para busca por atendimento
- fk_aexf_unid (KEY) - Índice para busca por unidade
- fk_atendimento_exame_fisico_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_aexf_unid - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)
- fk_atendimento_exame_fisico_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_exame_fisico_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada exame físico está associado a uma unidade
- N:1 com atendimento - Cada exame está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada exame pertence a uma entidade SaaS
- N:1 com usuario - Cada exame é realizado por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_exame_fisico)
- Tabelas das quais esta depende: unidade, atendimento, saas_entidade, usuario, sessao_usuario

## Fluxo de utilização dentro do sistema
- Registro estruturado do exame físico por sistemas corporais
- Avaliação completa: cabeça/pescoço, tórax, abdômen, membros, neurologia
- Auditoria de IP e dispositivo para rastreio de origem
- Vinculação ao atendimento e usuário para contexto clínico
- Timestamp automático para controle de quando o exame foi realizado
- Cascade delete remove exames quando atendimento é excluído