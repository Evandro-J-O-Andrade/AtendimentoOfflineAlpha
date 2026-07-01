# gaso_solicitacao

Objetivo: Gerenciar solicitações de gasoterapia (gases medicinais).

Descrição: Tabela que armazena as solicitações de gases medicinais (cilindros, redes, manutenção) para uso clínico. Controla o ciclo de vida da solicitação desde a abertura até a entrega ou cancelamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gaso | bigint | NOT NULL | - | Identificador único da solicitação, chave primária auto incrementada |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade que solicitou o gas |
| id_senha | bigint | DEFAULT NULL | - | Referência opcional à senha da fila |
| id_ffa | bigint | DEFAULT NULL | - | Referência opcional ao episódio FFA associado |
| tipo | enum('CILINDRO','REDE','MANUTENCAO','OUTRO') | NOT NULL | 'OUTRO' | Tipo de solicitação: cilindro, rede, manutenção ou outro |
| status | enum('ABERTO','EM_ATENDIMENTO','ENTREGUE','CANCELADO','FINALIZADO') | NOT NULL | 'ABERTO' | Status da solicitação no fluxo |
| local_destino | varchar(150) | DEFAULT NULL | - | Local onde o gas deve ser entregue |
| observacao | text | DEFAULT NULL | - | Observações sobre a solicitação |
| id_usuario_abertura | bigint | NOT NULL | - | Referência ao usuário que abriu a solicitação |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação da solicitação |
| atualizado_em | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE | CURRENT_TIMESTAMP | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gaso
- Únicas: -
- Estrangeiras: fk_gaso_solicitacao_unidade (id_unidade → unidade.id_unidade); fk_gaso_user (id_usuario_abertura → usuario.id_usuario)

## Índices
- idx_gaso_status (status)
- fk_gaso_unidade (id_unidade)
- fk_gaso_user (id_usuario_abertura)

## Constraints
- CONSTRAINT fk_gaso_solicitacao_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- CONSTRAINT fk_gaso_user FOREIGN KEY (id_usuario_abertura) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- gaso_solicitacao.id_unidade → unidade (id_unidade): N:1 (várias solicitações podem referenciar a mesma unidade)
- gaso_solicitacao.id_usuario_abertura → usuario (id_usuario): N:1 (várias solicitações podem ser abertas pelo mesmo usuário)

## Dependências
- Tabelas que dependem desta: gaso_evento
- Esta tabela depende de: unidade, usuario

## Fluxo de utilização dentro do sistema
1. Usuário abre solicitação de gasoterapia com tipo (CILINDRO, REDE, MANUTENCAO)
2. Status inicia como 'ABERTO'
3. local_destino indica onde deve ser entregue
4. Quando entra em atendimento: status muda para 'EM_ATENDIMENTO'
5. Após entrega: status muda para 'ENTREGUE'
6. Finaliza: status muda para 'FINALIZADO'
7. Se cancelado: status muda para 'CANCELADO'