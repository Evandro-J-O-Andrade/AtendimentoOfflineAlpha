# gpat_dispensacao

Objetivo: Controlar a dispensação de itens do GPAT.

Descrição: Tabela que registra a dispensação de medicamentos/fármacos do GPAT, controlando quantidade, lote, local de estoque e status de entrega ou estorno. Utilizada no fluxo de farmácia para registrar entregas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gpat_dispensacao | bigint | NOT NULL | - | Identificador único da dispensação, chave primária auto incrementada |
| id_gpat_item | bigint | NOT NULL | - | Referência ao item do GPAT que foi dispensado |
| id_lote | bigint | NOT NULL | - | Referência ao lote do fármaco utilizado |
| quantidade | decimal(10,2) | NOT NULL | - | Quantidade dispensada |
| id_local_estoque | bigint | NOT NULL | - | Referência ao local de estoque onde foi dispensado |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário responsável pela dispensação |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que realizou a dispensação |
| status | enum('ENTREGUE','ESTORNADO') | NOT NULL | 'ENTREGUE' | Status: entregue ou estornado |
| observacao | text | DEFAULT NULL | - | Observações sobre a dispensação |
| entregue_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora da entrega |
| estornado_em | datetime | DEFAULT NULL | - | Data e hora do estorno (se aplicável) |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gpat_dispensacao
- Únicas: -
- Estrangeiras: fk_gpat_disp_item (id_gpat_item → gpat_item.id_gpat_item ON DELETE CASCADE); fk_gpat_disp_local (id_local_estoque → local_atendimento.id_local); fk_gpat_disp_lote (id_lote → farmaco_lote.id_lote); fk_gpat_disp_usuario (id_usuario → usuario.id_usuario)

## Índices
- idx_gpat_disp_item (id_gpat_item)
- idx_gpat_disp_lote (id_lote)
- idx_gpat_disp_status (status)
- fk_gpat_disp_usuario (id_usuario)
- fk_gpat_disp_sessao (id_sessao_usuario)
- fk_gpat_disp_local (id_local_estoque)

## Constraints
- CONSTRAINT fk_gpat_disp_item FOREIGN KEY (id_gpat_item) REFERENCES gpat_item (id_gpat_item) ON DELETE CASCADE
- CONSTRAINT fk_gpat_disp_local FOREIGN KEY (id_local_estoque) REFERENCES local_atendimento (id_local)
- CONSTRAINT fk_gpat_disp_lote FOREIGN KEY (id_lote) REFERENCES farmaco_lote (id_lote)
- CONSTRAINT fk_gpat_disp_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- gpat_dispensacao.id_gpat_item → gpat_item (id_gpat_item): N:1
- gpat_dispensacao.id_lote → farmaco_lote (id_lote): N:1
- gpat_dispensacao.id_usuario → usuario (id_usuario): N:1

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: gpat_item, farmaco_lote, usuario, local_atendimento

## Fluxo de utilização dentro do sistema
1. Item do GPAT é dispensado da farmácia
2. Registro criado com id_lote do fármaco e quantidade
3. id_local_estoque indica onde foi retirado
4. Usuario registra a dispensação
5. Status inicia como 'ENTREGUE'
6. Se houver erro: status muda para 'ESTORNADO', estornado_em preenchido