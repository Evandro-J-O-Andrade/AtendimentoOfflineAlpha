# farm_dispensacao

Objetivo: Controle de dispensação de medicamentos

Descrição: Dispensação de receitas controladas, com suporte a dupla baixa (segundo conferente) e status de fluxo de dispensação.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_dispensacao | bigint AUTO_INCREMENT | NO | — | Identificador da dispensação |
| id_receita | bigint | NO | — | Identificador da receita médica |
| tipo | enum('INTERNO','VENDA','CONVENIO') | NO | — | Endereço IP de origem da requisição |
| id_usuario_primeira_baixa | bigint DEFAULT | YES | NULL | Usuário responsável pela baixa |
| primeira_baixa_em | datetime DEFAULT | YES | NULL | Usuário responsável pela baixa |
| id_usuario_segunda_baixa | bigint DEFAULT | YES | NULL | Usuário responsável pela baixa |
| segunda_baixa_em | datetime DEFAULT | YES | NULL | Usuário responsável pela baixa |
| status | enum('ABERTA','PARCIAL','FINALIZADA','CANCELADA') | NO | 'ABERTA' | Status atual conforme enumeração definida |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_dispensacao
- Estrangeira (fk_disp_receita): coluna id_receita -> tabela farm_receita_controlada(id_receita): Referencia a tabela farm_receita_controlada (coluna id_receita) para garantir integridade referencial

## Indices

- fk_disp_receita (id_receita)

## Constraints

- FOREIGN KEY fk_disp_receita: id_receita references farm_receita_controlada(id_receita)
- PRIMARY KEY (id_dispensacao)

## Relacionamentos e Cardinalidade

- farm_dispensacao (1) -> farm_receita_controlada (1): campo id_receita

## Dependencias

- Depende de:
  - farm_receita_controlada
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Recebe receitas controladas para dispensação.
- Permite dupla baixa com dois usuários conferentes.
- Ao ser finalizada, gera itens de dispensação e atualiza saldos de estoque.
- Integra com auditoria e log de dispensação.
