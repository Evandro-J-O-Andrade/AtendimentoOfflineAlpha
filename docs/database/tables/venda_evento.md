# venda_evento

Objetivo: Registrar eventos e históricos de alterações ocorridas durante o ciclo de vida de uma venda.
Descrição: Tabela de log de eventos que armazena todas as ocorrências relevantes em uma venda, como aberturas, adições de itens, alterações de status, pagamentos e cancelamentos. Funciona como trilha de auditoria da venda, permitindo rastrear todo o fluxo operacional e detectar inconsistências ou fraudes.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o evento da venda |
| id_venda | bigint | NO | NULL | Identificador da venda à qual este evento pertence |
| tipo | varchar(40) | NO | NULL | Tipo do evento registrado (ex: ABERTURA, ITEM_ADICIONADO, PAGAMENTO, CANCELAMENTO) |
| descricao | text | YES | NULL | Descrição detalhada do evento ocorrido |
| criado_em | datetime | NO | DEFAULT CURRENT_TIMESTAMP | Data e hora em que o evento foi registrado |
| id_usuario | bigint | YES | NULL | Identificador do usuário que executou a ação que gerou o evento |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este evento pertence |

## Chaves
- Primária: id_evento
- Únicas: Nenhuma
- Estrangeiras: Nenhuma constraint FK explícita declarada na criação da tabela

## Índices
- idx_ve_venda (id_venda, criado_em)

## Constraints
- Nenhuma constraint explícita declarada (as relações com venda e usuario podem estar em nível de aplicação)

## Relacionamentos e Cardinalidade
- N:1 com venda (muitos eventos pertencem a uma venda)
- N:1 com usuario (muitos eventos foram executados por um usuário)

## Dependências
- Depende de: venda, usuario, saas_entidade (relações implícitas)
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Toda alteração significativa em uma venda gera um evento (abertura, item adicionado, pagamento recebido, cancelamento)
- Usado para reconstruir o histórico completo de uma venda para auditoria e suporte
- Permite identificar em que momento um problema ocorreu durante o fluxo de venda
- Consultado em relatórios de auditoria de vendas e fechamento de caixa
- Funciona como fonte de verdade para reconciliação financeira
