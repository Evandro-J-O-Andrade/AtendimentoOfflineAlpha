# pep_registro

Objetivo: Armazenar registros clínicos tipo PEP (Procedimentos, Exames e Prescrições).
Descrição: Tabela que registra entradas clínicas realizadas durante o atendimento, podendo ser evoluções, anamneses, exames físicos, hipóteses diagnósticas, prescrições, solicitações, resultados ou altas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pep_registro | bigint | NOT NULL | - | Identificador único do registro (chave primária, auto incremento) |
| id_ffa | bigint | NOT NULL | - | ID do Fluxo de Atendimento Assistencial (FFA) associado |
| id_gpat | bigint | NOT NULL | - | ID do GPAT (atendimento presencial) associado |
| id_usuario_autor | bigint | NOT NULL | - | ID do usuário que criou o registro |
| id_local_operacional | bigint | YES | NULL | ID do local operacional onde o registro foi criado |
| tipo_registro | enum('EVOLUCAO','ANAMNESE','EXAME_FISICO','HIPOTESE','DIAGNOSTICO','PRESCRICAO','SOLICITACAO','RESULTADO','ALTA','TRANSFERENCIA','OUTRO') | NOT NULL | - | Tipo do registro clínico realizado |
| texto | mediumtext | YES | NULL | Texto do registro clínico |
| payload_json | json | YES | NULL | Dados estruturados adicionais em formato JSON |
| assinado | tinyint(1) | NOT NULL | '0' | Flag indicando se o registro foi assinado digitalmente |
| assinado_em | datetime | YES | NULL | Data/hora da assinatura digital |
| hash_assinatura | varchar(128) | YES | NULL | Hash da assinatura digital para validação |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação do registro |
| atualizado_em | datetime | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o registro pertence |

## Chaves
- Primária: id_pep_registro
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id_pep_registro)
- KEY ix_pep_ffa (id_ffa)
- KEY ix_pep_gpat (id_gpat)
- KEY ix_pep_tipo (tipo_registro)
- KEY ix_pep_autor (id_usuario_autor)

## Constraints
- PRIMARY KEY: id_pep_registro

## Relacionamentos e Cardinalidade
- N:1 com ffa: Muitos registros pertencem a um FFA
- N:1 com gpat: Muitos registros pertencem a um GPAT
- N:1 com usuario: Muitos registros são criados por um usuário
- N:1 com local_operacional: Muitos registros podem ter um local associado

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar todas as entradas clínicas durante um atendimento. O profissional seleciona o tipo de registro (evolução, diagnóstico, prescrição) e preenche os campos. O campo assinado controla se precisa de assinatura digital. Registros são vinculados ao FFA para rastrear toda a jornada clínica.