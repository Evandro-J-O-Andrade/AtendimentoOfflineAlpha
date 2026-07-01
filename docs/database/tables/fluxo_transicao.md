# fluxo_transicao

Objetivo: Definir as regras de transição entre status no fluxo assistencial.

Descrição: Tabela que estabelece as regras de transição entre status de fluxo, vinculando contrato, perfil requerido e condições para mudança de estado no workflow assistencial. Controla quais perfis podem executar qual transição.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fluxo_transicao | bigint | NOT NULL | - | Identificador único da transição, chave primária auto incrementada |
| id_contrato | bigint | NOT NULL | - | Referência ao contrato que define a transição |
| id_status_origem | bigint | NOT NULL | - | Referência ao status de origem da transição |
| id_status_destino | bigint | NOT NULL | - | Referência ao status de destino da transição |
| id_perfil | bigint | NOT NULL | - | Referência ao perfil de usuário que pode executar a transição |
| obriga_justificativa | tinyint(1) | NOT NULL | '0' | Indicador se a transição exige justificativa (0=não, 1=sim) |
| bloqueia_retrocesso | tinyint(1) | NOT NULL | '0' | Indicador se a transição bloqueia retorno ao estado anterior (0=permite, 1=bloqueia) |
| ativo | tinyint(1) | NOT NULL | '1' | Indicador se a regra de transição está ativa |
| criado_em | datetime(6) | NOT NULL DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação da regra |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_fluxo_transicao
- Únicas: uk_fluxo_regra (id_contrato, id_status_origem, id_status_destino, id_perfil) - garante combinação única
- Estrangeiras: fk_fluxo_origem (id_status_origem → fluxo_status.id_fluxo_status); fk_fluxo_destino (id_status_destino → fluxo_status.id_fluxo_status); fk_fluxo_perfil (id_perfil → perfil.id_perfil)

## Índices
- idx_fluxo_contrato (id_contrato)
- idx_fluxo_origem (id_status_origem)
- idx_fluxo_destino (id_status_destino)
- idx_fluxo_perfil (id_perfil)

## Constraints
- CONSTRAINT fk_fluxo_destino FOREIGN KEY (id_status_destino) REFERENCES fluxo_status (id_fluxo_status)
- CONSTRAINT fk_fluxo_origem FOREIGN KEY (id_status_origem) REFERENCES fluxo_status (id_fluxo_status)
- CONSTRAINT fk_fluxo_perfil FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)

## Relacionamentos e Cardinalidade
- fluxo_transicao.id_contrato → contrato (id_contrato): N:1 (várias transições podem referenciar o mesmo contrato)
- fluxo_transicao.id_status_origem → fluxo_status (id_fluxo_status): N:1 (várias transições podem sair do mesmo status)
- fluxo_transicao.id_status_destino → fluxo_status (id_fluxo_status): N:1 (várias transições podem levar ao mesmo status)
- fluxo_transicao.id_perfil → perfil (id_perfil): N:1 (várias transições podem exigir o mesmo perfil)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: contrato, fluxo_status, perfil

## Fluxo de utilização dentro do sistema
1. Regras de transição são definidas entre pares de status
2. id_perfil define quais usuários podem executar a transição
3. obriga_justificativa força justificativa em casos específicos
4. bloqueia_retrocesso impede retorno ao estado anterior quando ativo
5. ativo controla se a regra está disponível para uso