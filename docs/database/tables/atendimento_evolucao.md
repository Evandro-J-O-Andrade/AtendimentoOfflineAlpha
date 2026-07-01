# atendimento_evolucao

Objetivo: Registrar evoluções clínicas durante atendimentos, permitindo o acompanhamento evolutivo do paciente com texto, escala de dor e auditoria completa.

Descrição: Esta tabela armazena as evoluções clínicas dos pacientes durante atendimentos, contendo o texto da evolução, escala de dor, tipo de profissional que realizou a evolução, informações de segurança (hash) e auditoria completa.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da evolução clínica |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde a evolução foi registrada |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual a evolução pertence |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a evolução pertence |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário que realizou a evolução |
| id_sessao_usuario | bigint | NOT NULL | - | Identificador da sessão do usuário no momento da evolução |
| tipo_profissional | enum('MEDICO','ENFERMEIRO','TECNICO','OUTROS') | NOT NULL | - | Tipo de profissional que realizou a evolução: médico, enfermeiro, técnico ou outros |
| texto_evolucao | text | NOT NULL | - | Texto completo da evolução clínica do paciente |
| escala_dor | int | YES | NULL | Escala numérica de avaliação da dor do paciente (ex: 0-10) |
| hash_seguranca | char(64) | YES | NULL | Hash de segurança para verificação de integridade do registro |
| ip_origem | varchar(45) | YES | NULL | Endereço IP de origo da requisição |
| device_info | varchar(255) | YES | NULL | Informações do dispositivo utilizado |
| criado_em | datetime(6) | NOT NULL | - | Timestamp da data/hora de criação da evolução (NOT NULL, sem default automático explícito) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual a evolução pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_aevol_unid - id_unidade → unidade(id_unidade) - Vincula a evolução à unidade; fk_atendimento_evolucao_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a evolução ao atendimento; fk_atendimento_evolucao_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a evolução à entidade |

## Índices
- idx_ffa (KEY) - Índice para busca por FFA
- idx_usuario (KEY) - Índice para busca por usuário
- idx_sessao (KEY) - Índice para busca por sessão
- fk_atendimento_evolucao_atendimento (KEY) - Índice para busca por atendimento
- fk_aevol_unid (KEY) - Índice para busca por unidade
- fk_atendimento_evolucao_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_aevol_unid - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)
- fk_atendimento_evolucao_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_evolucao_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada evolução está associada a uma unidade
- N:1 com atendimento - Cada evolução está associada a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada evolução pertence a uma entidade SaaS
- N:1 com usuario - Cada evolução é realizada por um usuário
- N:1 com sessao_usuario - Cada evolução tem uma sessão associada

## Dependências
- Tabelas que dependem desta: assinatura_digital_prontuario (via id_ffa_evolucao)
- Tabelas das quais esta depende: unidade, atendimento, saas_entidade, usuario, sessao_usuario

## Fluxo de utilização dentro do sistema
- Registro de evoluções clínicas durante o atendimento
- Tipo de profissional para identificação do responsável
- Escala de dor para acompanhamento da dor do paciente
- Hash de segurança para verificação de integridade do registro
- Auditoria completa com IP, dispositivo, sessão e usuário
- Assinatura digital opcional via assinatura_digital_prontuario
- Índices para busca eficiente por FFA, atendimento, usuário e sessão