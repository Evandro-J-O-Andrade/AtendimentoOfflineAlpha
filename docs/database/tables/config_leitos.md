# config_leitos

Objetivo: Configurar e gerenciar leitos de internacao e observação por unidade.
Descrição: Tabela que define leitos disponíveis em cada unidade, com identificação, tipo e status de ocupação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Identificador único do leito, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o leito está localizado. |
| identificacao | varchar(50) | NOT NULL | - | Identificação do leito (ex: "UTI-01", "ENF-12A"). |
| tipo | enum('OBSERVACAO','EMERGENCIA','INTERNACAO','ISOLAMENTO') | Nullable | - | Tipo do leito: observação, emergência, internação ou isolamento. |
| status_ocupacao | enum('LIVRE','OCUPADO','RESERVADO','HIGIENIZACAO','MANUTENCAO') | Nullable | 'LIVRE' | Status: livre, ocupado, reservado, higienização ou manutenção. |
| id_atendimento_atual | bigint | Nullable | - | Referência ao atendimento atual no leito (se ocupado). |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_config_leitos_unidade: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id)
- KEY fk_config_leitos_unidade (id_unidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_config_leitos_unidade (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade) - muitos leitos podem pertencer a uma unidade
- 1:1 com atendimento (id_atendimento_atual) - opcional
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: unidade, atendimento, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Cadastrado durante configuração inicial da unidade
- Status controla disponibilidade para novos atendimentos
- Leitos reservados aguardando paciente
- Status higienização/manutenção impedem alocação
- Integrado ao sistema de internacao para alocação automática