# lab_pedido

Objetivo: Representar pedidos de exames laboratoriais solicitados durante atendimentos médicos.
Descrição: Tabela central dos pedidos de laboratório, vinculando exames ao atendimento do paciente via senha e FFA. Controla o ciclo de vida do pedido desde solicitação até conclusão, com protocolo interno único para identificação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_pedido` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do pedido |
| `protocolo_interno` | varchar(30) | NOT NULL | - | Protocolo interno único do pedido (identificador legível) |
| `id_senha` | bigint | NOT NULL | - | Referência à senha do atendimento |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `id_atendimento` | bigint | NULL | NULL | Referência ao atendimento médico |
| `id_laboratorio` | int | NOT NULL | - | Identificador do laboratório onde será processado |
| `status` | enum('SOLICITADO','COLETADO','ENVIADO','RECEBIDO_LAB','FINALIZADO','CANCELADO') | NULL | 'SOLICITADO' | Status do pedido no fluxo de trabalho |
| `impresso` | tinyint(1) | NULL | '0' | Indica se o pedido foi impresso (1) ou não (0) |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de criação do pedido |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_pedido`
- Únicas: `protocolo_interno` (`protocolo_interno`) - Garante unicidade do protocolo do pedido
- Estrangeiras: -

## Índices
- `fk_lab_senha` (KEY) - Índice em `id_senha`
- `fk_lab_ffa` (KEY) - Índice em `id_ffa`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `senha` - Muitos pedidos podem estar associados a uma senha
- N:1 com `ffa` - Muitos pedidos podem estar associados a um FFA
- N:1 com `atendimento` - Muitos pedidos podem estar associados a um atendimento
- N:1 com `laboratorio` - Muitos pedidos podem estar associados a um laboratório

## Dependências
- Esta tabela é referenciada por: `lab_evento`, `lab_amostra`, `laboratorio_protocolo`
- Esta tabela depende de: `senha`, `ffa`, `atendimento`, `laboratorio`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Pedido é criado quando médico solicita exame via senha do atendimento
2. Protocolo interno é gerado como identificador único do pedido
3. Status SOLICITADO indica pedido aguardando coleta de amostra
4. Após coleta, status muda para COLETADO
5. ENVIADO indica amostra em transporte ao laboratório
6. RECEBIDO_LAB indica que laboratório recebeu a amostra
7. FINALIZADO após resultado disponibilizado
8. CANCELADO em caso de erro ou desistência
9. Usado para controle de fluxo e SLA de exames laboratoriais