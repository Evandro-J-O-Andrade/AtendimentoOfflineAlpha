# auditoria_visualizacao_prontuario

Objetivo: Registrar auditoria de visualizações do prontuário do paciente.
Descrição: Tabela que registra cada acesso ao prontuário do paciente, permitindo controle de quem visualizou o prontuário, quando e de onde.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que visualizou o prontuário. |
| id_atendimento | bigint | NOT NULL | - | Referência ao atendimento cujo prontuário foi visualizado. |
| ip_acesso | varchar(45) | Nullable | - | Endereço IP de onde ocorreu a visualização. |
| data_hora | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora da visualização do prontuário. |
| contexto | varchar(100) | Nullable | - | Contexto da visualização (ex: CONSULTA, TRIAGEM, etc.). |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario) - inferido
- N:1 com atendimento (id_atendimento) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, atendimento, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Registrada automaticamente quando há acesso ao prontuário do paciente
- Usada para compliance e controle de acesso a dados sensíveis
- Permite identificar acessos não autorizados ou suspeitos
- Base para relatórios de HIPAA/compliance de privacidade