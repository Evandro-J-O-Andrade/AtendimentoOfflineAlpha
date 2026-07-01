# protocolo_assistencial_global

Objetivo: Gerenciar protocolos assistenciais globais vinculados a atendimentos, com controle de versão, hash e estado de validade para orquestração de fluxos clínicos.

Descrição: Tabela que mantém os protocolos assistenciais globais aplicados a atendimentos, permitindo versionamento, controle de hash para integridade e gerenciamento de estado (ativo, obsoleto, revogado) para orquestração de workflows clínicos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_protocolo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do protocolo assistencial |
| dominio_fluxo | varchar(50) | NOT NULL | - | Domínio de fluxo ao qual o protocolo pertence (ex: TRIAGEM, ENFERMAGEM, MEDICACAO) |
| versao_protocolo | bigint | NOT NULL | - | Versão numérica do protocolo para controle de alterações |
| hash_protocolar | char(64) | NOT NULL | - | Hash para verificação de integridade do protocolo |
| payload_protocolo | json | NOT NULL | - | Payload JSON contendo os dados do protocolo em formato estruturado |
| estado_protocolo | enum('ATIVO','OBSOLETO','REVOGADO') | - | 'ATIVO' | Estado do protocolo: ATIVO, OBSOLETO ou REVOGADO |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do protocolo |
| atualizado_em | datetime(6) | - | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data e hora da última atualização do protocolo |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento ao qual o protocolo está vinculado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o protocolo foi criado |

## Chaves
- Primária: id_protocolo
- Únicas: uk_protocolo_hash (hash_protocolar)
- Estrangeiras: fk_protocolo_assistencial_global_atendimento (id_atendimento → atendimento.id_atendimento) - vincula o protocolo ao atendimento; fk_protocolo_assistencial_global_entidade (id_entidade → saas_entidade.id_entidade) - vincula o protocolo à entidade

## Índices
- PRIMARY KEY (id_protocolo)
- UNIQUE KEY uk_protocolo_hash (hash_protocolar)
- KEY idx_protocolo_dominio (dominio_fluxo, versao_protocolo)
- KEY fk_protocolo_assistencial_global_atendimento (id_atendimento)
- KEY idx_pag_ent (id_entidade)

## Constraints
- CONSTRAINT fk_protocolo_assistencial_global_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_protocolo_assistencial_global_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter vários protocolos assistenciais)
- N:1 com saas_entidade (uma entidade pode ter vários protocolos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado quando um protocolo assistencial é aplicado a um atendimento
- Permite versionamento e controle de integridade via hash
- Protocolos podem ser revogados ou tornados obsoletos
- Usado como base para orquestração de workflows clínicos