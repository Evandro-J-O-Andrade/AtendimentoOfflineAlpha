# integracao_mensageria_externa

Objetivo: Integrar mensagens externas ao sistema via HL7 ou FHIR.

Descrição: Tabela que armazena mensagens recebidas de sistemas externos (HL7 ORU, HL7 ADT, FHIR JSON) para processamento e integração de dados assistenciais. Controla o status de processamento das mensagens.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da mensagem, chave primária auto incrementada |
| id_atendimento | bigint | NOT NULL | - | Referência ao atendimento ao qual a mensagem está associada |
| provedor_externo | varchar(100) | DEFAULT NULL | - | Nome do provedor/sistema externo que enviou a mensagem |
| tipo_mensagem | enum('HL7_ORU','HL7_ADT','FHIR_JSON') | DEFAULT NULL | - | Tipo de mensagem: HL7 ORU (resultado), HL7 ADT (evento) ou FHIR JSON |
| conteudo_raw | longtext | DEFAULT NULL | - | Conteúdo bruto da mensagem recebida |
| status_processamento | enum('PENDENTE','PROCESSADO','ERRO') | DEFAULT NULL | - | Status do processamento: pendente, processado ou erro |
| data_recebimento | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora de recebimento da mensagem |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- integracao_mensageria_externa.id_atendimento → atendimento (id_atendimento): N:1 (várias mensagens podem referenciar o mesmo atendimento)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento

## Fluxo de utilização dentro do sistema
1. Sistema externo envia mensagem HL7 ou FHIR
2. Registro é criado com tipo_mensagem e provedor_externo
3. conteudo_raw armazena a mensagem completa
4. Status inicia como 'PENDENTE'
5. Processamento automático ou manual muda status para 'PROCESSADO'
6. Se houver erro: status muda para 'ERRO'