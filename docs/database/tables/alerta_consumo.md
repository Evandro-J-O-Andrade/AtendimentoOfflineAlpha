# alerta_consumo

Objetivo: Registrar o consumo e tratamento dos alertas pelos usuários destinatários, controlando ações tomadas e observações sobre o atendimento do alerta.

Descrição: Esta tabela registra as interações dos usuários com os alertas, permitindo o acompanhamento de quando um alerta foi lido, assumido, resolvido ou cancelado, com auditoria completa da sessão e ação realizada.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_alerta_consumo | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de consumo de alerta |
| id_alerta | bigint | NOT NULL | - | Chave estrangeira que referencia o alerta sendo consumido, vinculada à tabela alerta |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que consumiu o alerta |
| acao | enum('LIDO','ASSUMIDO','RESOLVIDO','CANCELADO') | NOT NULL | 'LIDO' | Ação realizada pelo usuário com o alerta: marcar como lido, assumir, resolver ou cancelar |
| observacao | varchar(240) | YES | NULL | Campo de texto para observações sobre a ação realizada |
| id_sessao_usuario | bigint | YES | NULL | Chave estrangeira que referencia a sessão do usuário no momento da ação |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que o consumo foi registrado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_alerta_consumo
- Únicas: ux_alerta_consumo (id_alerta, id_usuario) - Garante que um usuário não registre múltiplas ações para o mesmo alerta
- Estrangeiras: fk_alerta_consumo_alerta - id_alerta → alerta(id_alerta) ON DELETE CASCADE - Vincula o consumo ao alerta; fk_alerta_consumo_sessao - id_sessao_usuario → sessao_usuario(id_sessao_usuario) - Vincula o consumo à sessão; fk_alerta_consumo_usuario - id_usuario → usuario(id_usuario) - Vincula o consumo ao usuário

## Índices
- idx_alerta_consumo_alerta (KEY) - Índice para busca por alerta
- idx_alerta_consumo_usuario (KEY) - Índice para busca por usuário
- idx_alerta_consumo_acao (KEY) - Índice para busca por ação
- fk_alerta_consumo_sessao (KEY) - Índice para busca por sessão

## Constraints
- ux_alerta_consumo - UNIQUE - Garante unicidade da combinação alerta/usuário
- fk_alerta_consumo_alerta - FOREIGN KEY - Restringe id_alerta à tabela alerta(id_alerta) com exclusão em cascata
- fk_alerta_consumo_sessao - FOREIGN KEY - Restringe id_sessao_usuario à tabela sessao_usuario(id_sessao_usuario)
- fk_alerta_consumo_usuario - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com alerta - Cada consumo está associado a um alerta específico (com CASCADE DELETE)
- N:1 com usuario - Cada consumo é registrado por um único usuário
- N:1 com sessao_usuario - Cada consumo pode ter uma sessão associada (opcional)

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para alerta_consumo)
- Tabelas das quais esta depende: alerta, usuario, sessao_usuario

## Fluxo de utilização dentro do sistema
- Registro da interação do usuário com um alerta (LIDO, ASSUMIDO, RESOLVIDO, CANCELADO)
- Controle de unicidade para evitar duplicação de consumo por usuário
- Auditoria completa com sessão do usuário no momento da ação
- Cascade delete garante limpeza automática quando alerta é removido
- Busca eficiente por alerta, usuário ou tipo de ação via índices dedicados