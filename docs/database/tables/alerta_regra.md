# alerta_regra

Objetivo: Definir regras para geração automática de alertas, vinculando códigos de alerta a sistemas e perfis de destino.

Descrição: Esta tabela armazena as regras de alertas do sistema, permitindo a configuração de como e para quem os alertas são destinados com base no código do alerta, sistema de origem e perfil de destino, com controle de status ativo e auditoria de criação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_alerta_regra | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da regra de alerta |
| codigo | varchar(60) | NOT NULL | - | Código identificador do tipo de alerta que esta regra define |
| id_sistema_destino | bigint | NOT NULL | - | Chave estrangeira que referencia o sistema de destino da regra |
| id_perfil_destino | bigint | NOT NULL | - | Chave estrangeira que referencia o perfil que receberá os alertas desta regra |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade à qual a regra está associada |
| ativo | tinyint(1) | YES | '1' | Flag que indica se a regra está ativa (1) ou inativa (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação da regra |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Timestamp automático de atualização da regra |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual a regra pertence |

## Chaves
- Primária: id_alerta_regra
- Únicas: uk_alerta_codigo_destino (codigo, id_sistema_destino, id_perfil_destino) - Garante que não existam duas regras com a mesma combinação de código, sistema e perfil
- Estrangeiras: fk_alerta_regra_perfil - id_perfil_destino → perfil(id_perfil) - Vincula o destino ao perfil; fk_alerta_regra_sistema - id_sistema_destino → sistema(id_sistema) - Vincula o destino ao sistema

## Índices
- fk_alerta_regra_sistema (KEY) - Índice para busca por sistema destino
- fk_alerta_regra_perfil (KEY) - Índice para busca por perfil destino
- fk_alerta_regra_unidade (KEY) - Índice para busca por unidade

## Constraints
- uk_alerta_codigo_destino - UNIQUE - Garante unicidade da combinação codigo/sistema/perfil
- fk_alerta_regra_perfil - FOREIGN KEY - Restringe id_perfil_destino à tabela perfil(id_perfil)
- fk_alerta_regra_sistema - FOREIGN KEY - Restringe id_sistema_destino à tabela sistema(id_sistema)

## Relacionamentos e Cardinalidade
- N:1 com sistema - Cada regra está associada a um sistema de destino
- N:1 com perfil - Cada regra está associada a um perfil de destinatário
- N:1 com unidade - Cada regra está associada a uma unidade

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para alerta_regra)
- Tabelas das quais esta depende: sistema, perfil

## Fluxo de utilização dentro do sistema
- Configuração de regras automáticas para geração de alertas
- Definição de quais perfis recebem quais tipos de alertas em quais sistemas
- Controle de status ativo/inativo para ativar ou desativar regras
- Auditoria de criação e atualização com timestamps
- Unicidade garantida para código/sistema/perfil evitando configurações duplicadas
- Índices para busca eficiente por sistema e perfil