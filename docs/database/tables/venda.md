# venda

Objetivo: Registrar transações de venda de produtos e serviços no sistema, controlando status e valores financeiros.
Descrição: Tabela principal do módulo de vendas/PDV que armazena o cabeçalho de cada transação comercial. Controla o fluxo de uma venda desde sua abertura até pagamento ou cancelamento, vinculando-a a um caixa, cliente e usuário operador. Gerencia totais de itens, descontos e valores finais para integração com módulo financeiro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_venda | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica a venda |
| id_caixa | bigint | NO | NULL | Identificador do caixa onde a venda foi realizada |
| id_cliente | bigint | YES | NULL | Identificador do cliente associado à venda (nulo para vendas sem cliente cadastrado) |
| origem | enum('PDV_RUA','ATENDIMENTO_INTERNO') | NO | 'PDV_RUA' | Origem da venda: PDV de rua (balcão/ambulatório) ou atendimento interno (internação/enfermaria) |
| status | enum('ABERTA','PAGA','CANCELADA') | NO | 'ABERTA' | Status atual da venda: aberta (em andamento), paga (finalizada) ou cancelada |
| total_itens | decimal(10,2) | NO | '0.00' | Soma dos valores dos itens antes de descontos |
| total_desconto | decimal(10,2) | NO | '0.00' | Valor total de descontos aplicados na venda |
| total_final | decimal(10,2) | NO | '0.00' | Valor final da venda após descontos |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora de abertura da venda |
| pago_em | datetime | YES | NULL | Data e hora em que a venda foi completamente paga |
| cancelado_em | datetime | YES | NULL | Data e hora em que a venda foi cancelada |
| criado_por | bigint | YES | NULL | Identificador do usuário que abriu/criou a venda |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual esta venda pertence |

## Chaves
- Primária: id_venda
- Únicas: Nenhuma
- Estrangeiras: fk_venda_caixa (id_caixa -> caixa.id_caixa), fk_venda_cliente (id_cliente -> cliente.id_cliente), fk_venda_criado_por (criado_por -> usuario.id_usuario)

## Índices
- idx_venda_status (status, criado_em)
- fk_venda_caixa (id_caixa)
- fk_venda_cliente (id_cliente)
- fk_venda_criado_por (criado_por)

## Constraints
- fk_venda_caixa: FOREIGN KEY (id_caixa) REFERENCES caixa (id_caixa)
- fk_venda_cliente: FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
- fk_venda_criado_por: FOREIGN KEY (criado_por) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com caixa (muitas vendas pertencem a um caixa)
- N:1 com cliente (muitas vendas pertencem a um cliente)
- N:1 com usuario (muitas vendas foram criadas por um usuário)
- 1:N com venda_item (uma venda possui muitos itens)
- 1:N com venda_evento (uma venda gera muitos eventos)
- 1:N com venda_pagamento (uma venda pode ter muitos pagamentos)

## Dependências
- Depende de: caixa, cliente, usuario, saas_entidade
- Dependências reversas: venda_item, venda_pagamento, venda_evento

## Fluxo de utilização dentro do sistema
- Atendente abre uma venda no PDV informando a origem e vinculando a um caixa
- Itens são adicionados à venda através da tabela venda_item
- A venda pode receber múltiplas formas de pagamento registradas em venda_pagamento
- Quando todos os pagamentos são confirmados, status muda para PAGA e pago_em é preenchido
- Se necessário cancelar, status muda para CANCELADA e cancelado_em é preenchido
- Eventos importantes são registrados em venda_evento para auditoria
- Usado para fechamento de caixa e relatórios financeiros
