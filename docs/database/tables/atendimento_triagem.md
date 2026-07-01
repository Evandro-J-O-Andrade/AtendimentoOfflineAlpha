# atendimento_triagem

Objetivo: Armazenar os dados de triagem médica realizados no início do atendimento assistencial.
Descrição: Tabela que registra as informações coletadas durante a triagem do paciente, incluindo sinais vitais, classificação de risco (escala de dor), dados antropométricos e informações do dispositivo/origem da triagem.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de triagem, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde a triagem foi realizada. |
| id_ffa | bigint | NOT NULL | - | Referência ao FFA (Ficha de Atendimento) associado à triagem. |
| escala_dor | int | Nullable | - | Escala de avaliação da dor do paciente (geralmente 0-10). |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário/profissional que realizou a triagem. |
| id_sessao_usuario | bigint | NOT NULL | - | Identificador da sessão do usuário que realizou a triagem. |
| peso | decimal(5,2) | Nullable | - | Peso do paciente em kg, usado para cálculos médicos. |
| altura | decimal(3,2) | Nullable | - | Altura do paciente em metros. |
| pressao_arterial | varchar(20) | Nullable | - | Pressão arterial sistólica/diastólica do paciente. |
| frequencia_cardiaca | int | Nullable | - | Frequência cardíaca em batimentos por minuto. |
| temperatura | decimal(4,2) | Nullable | - | Temperatura corporal do paciente em graus Celsius. |
| saturacao | int | Nullable | - | Saturação de oxigênio no sangue (% SpO2). |
| ip_origem | varchar(45) | Nullable | - | Endereço IP do dispositivo que registrou a triagem. |
| device_info | varchar(255) | Nullable | - | Informações do dispositivo/hardware utilizado na triagem. |
| criado_em | datetime(6) | Nullable | - | Timestamp de criação do registro de triagem. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento associado à triagem. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_atendimento_triagem_atendimento: id_atendimento → atendimento (id_atendimento) - Relacionamento N:1 com atendimento, deleta em cascata
  - fk_atendimento_triagem_entidade: id_entidade → saas_entidade (id_entidade)
  - fk_atri_unid: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id)
- KEY idx_ffa (id_ffa)
- KEY fk_atendimento_triagem_atendimento (id_atendimento)
- KEY fk_atri_unid (id_unidade)
- KEY fk_atendimento_triagem_entidade (id_entidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_atendimento_triagem_atendimento (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY: fk_atendimento_triagem_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)
- FOREIGN KEY: fk_atri_unid (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (id_atendimento)
- N:1 com saas_entidade (id_entidade)
- N:1 com unidade (id_unidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: atendimento, saas_entidade, unidade

## Fluxo de utilização dentro do sistema
- Criada no início do atendimento assistencial durante o processo de triagem
- Vinculada ao FFA e ao atendimento do paciente
- Usada para classificação de risco e encaminhamento do paciente
- Registra sinais vitais para avaliação clínica inicial