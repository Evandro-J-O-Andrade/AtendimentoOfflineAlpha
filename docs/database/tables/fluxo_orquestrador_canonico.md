# fluxo_orquestrador_canonico

Objetivo: Controlar o orquestrador canônico de estados assistenciais.

Descrição: Tabela que define as regras de transição entre estados em um fluxo assistencial, armazenando o domínio, estado atual, próximo estado e as regras de execução em formato JSON. Funciona como motor de workflow que controla o andamento dos atendimentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_orquestrador | bigint | NOT NULL | - | Identificador único do orquestrador, chave primária auto incrementada |
| dominio_fluxo | varchar(50) | NOT NULL | - | Domínio do fluxo (ex: ASSISTENCIAL) |
| estado_atual | varchar(50) | NOT NULL | - | Estado atual no fluxo |
| estado_proximo | varchar(50) | NOT NULL | - | Estado seguinte no fluxo |
| regra_execucao | json | NOT NULL | - | Regras de execução em formato JSON que definem condições para transição |
| criticidade_fluxo | tinyint | NOT NULL | '1' | Nível de criticidade do fluxo (1=baixo, valores maiores indicam maior criticidade) |
| exige_assinatura_digital | tinyint(1) | DEFAULT | '0' | Indicador se a transição exige assinatura digital (0=não, 1=sim) |
| timeout_execucao_segundos | int | DEFAULT NULL | - | Timeout em segundos para execução da transição |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se a regra está ativa |
| criado_em | datetime(6) | NOT NULL DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento ao qual o orquestrador pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_orquestrador
- Únicas: uk_ffa_orquestrador_fluxo (dominio_fluxo, estado_atual, estado_proximo) - garante combinação única
- Estrangeiras: fk_fluxo_orquestrador_canonico_atendimento (id_atendimento → atendimento.id_atendimento ON DELETE CASCADE ON UPDATE CASCADE); fk_fluxo_orquestrador_canonico_entidade (id_entidade → saas_entidade.id_entidade)

## Índices
- fk_fluxo_orquestrador_canonico_atendimento (id_atendimento)
- idx_foc_ent (id_entidade)

## Constraints
- CONSTRAINT fk_fluxo_orquestrador_canonico_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_fluxo_orquestrador_canonico_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- fluxo_orquestrador_canonico.id_atendimento → atendimento (id_atendimento): N:1 (vários orquestradores podem referenciar o mesmo atendimento)
- fluxo_orquestrador_canonico.id_entidade → saas_entidade (id_entidade): N:1 (vários orquestradores podem referenciar a mesma entidade)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
1. Orquestrador é criado para cada atendimento com domínio_fluxo e estado inicial
2. regra_execucao define condições para transições entre estados
3. criticidade_fluxo classifica a importância do fluxo
4. exige_assinatura_digital força assinatura digital em transições críticas
5. timeout_execucao_segundos define limite de tempo para a transição
6. ao avançar estado: novo registro com estado_atual e estado_proximo atualizados