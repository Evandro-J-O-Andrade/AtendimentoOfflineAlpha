# alerta_destinatario

Objetivo: Registrar os destinatários de alertas, permitindo notificações a diferentes tipos de destinos (usuários, perfis, painéis, locais, unidades, sistemas).

Descrição: Esta tabela controla a distribuição de alertas para diferentes destinos, permitindo que alertas sejam direcionados a usuários específicos, perfis de usuário, painéis de monitoramento, locais operacionais, unidades ou sistemas inteiros, com controle de status e auditoria de ações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_alerta_destinatario | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de destinatário |
| id_alerta | bigint | NOT NULL | - | Chave estrangeira que referencia o alerta sendo destinado, vinculada à tabela alerta |
| tipo_destino | enum('USUARIO','PERFIL','PAINEL','LOCAL','UNIDADE','SISTEMA') | NOT NULL | - | Tipo de destino que receberá o alerta: usuário, perfil, painel, local, unidade ou sistema |
| codigo_destino | varchar(60) | YES | NULL | Código identificador do destino, utilizado dependendo do tipo (ex: código do perfil, painel, etc.) |
| id_destino | bigint | YES | NULL | Identificador numérico do destino (FK dependendo do tipo_destino) |
| status | enum('NOVO','LIDO','EM_ATENDIMENTO','RESOLVIDO','CANCELADO') | NOT NULL | 'NOVO' | Status de consumo do alerta pelo destinatário: novo, lido, em atendimento, resolvido, cancelado |
| lido_em | datetime | YES | NULL | Timestamp da data/hora em que o alerta foi marcado como lido pelo destinatário |
| id_sessao_usuario_acao | bigint | YES | NULL | Identificador da sessão do usuário que realizou a ação de consumo |
| id_usuario_acao | bigint | YES | NULL | Identificador do usuário que realizou a ação de consumo ou resolução do alerta |
| atualizado_em | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp automático de atualização do registro |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp automático da data/hora de criação do registro de destinatário |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_alerta_destinatario
- Únicas: Nenhuma
- Estrangeiras: fk_ad_alerta - id_alerta → alerta(id_alerta) ON DELETE CASCADE - Vincula o destinatário ao alerta; fk_ad_usuario - id_usuario_acao → usuario(id_usuario) - Vincula a ação ao usuário responsável

## Índices
- idx_ad_alerta (KEY) - Índice para busca por alerta
- idx_ad_tipo_codigo_status (KEY) - Índice composto por tipo_destino, codigo_destino e status para busca por tipo e estado
- idx_ad_tipo_id_status (KEY) - Índice composto por tipo_destino, id_destino e status para busca por tipo/id
- idx_ad_lido_em (KEY) - Índice para busca por data de leitura
- fk_ad_sessao (KEY) - Índice para busca por sessão
- fk_ad_usuario (KEY) - Índice para busca por usuário ação

## Constraints
- fk_ad_alerta - FOREIGN KEY - Restringe id_alerta à tabela alerta(id_alerta) com exclusão em cascata
- fk_ad_usuario - FOREIGN KEY - Restringe id_usuario_acao à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com alerta - Cada destinatário está associado a um alerta (com CASCADE DELETE)
- N:1 com usuario (ação) - Cada registro pode ter um usuário que realizou ação (opcional)

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para alerta_destinatario)
- Tabelas das quais esta depende: alerta, usuario

## Fluxo de utilização dentro do sistema
- Distribuição de alertas para múltiplos destinatários simultâneos
- Suporte a diferentes tipos de destinatários: usuários individuais, perfis, painéis, unidades, sistemas
- Controle de status para cada destinatário independentemente
- Registro de data de leitura para acompanhamento de consumo
- Auditoria de ações com usuário e sessão
- Índices compostos para busca eficiente por tipo, código, id e status
- Cascade delete remove destinatários automaticamente quando alerta é excluído