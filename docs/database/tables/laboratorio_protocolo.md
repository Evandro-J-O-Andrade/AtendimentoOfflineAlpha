# laboratorio_protocolo

Objetivo: Gerenciar protocolos de integração entre o sistema interno e sistemas laboratoriais externos (LIMS).
Descrição: Tabela que mantém os registros de protocolos de integração com sistemas laboratoriais externos, mapeando pedidos internos para códigos e barcodes externos. Controla o status da sincronização com o laboratório.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_laboratorio_protocolo` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do protocolo de laboratório |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `id_gpat` | bigint | NOT NULL | - | Identificador do GPAT (Grupo de Procedimentos Assistenciais) |
| `id_pedido_item` | bigint | NOT NULL | - | Referência ao item do pedido de exame |
| `id_codigo_universal` | bigint | NOT NULL | - | Identificador do código universal do exame no laboratório |
| `codigo` | varchar(60) | NOT NULL | - | Código do exame no laboratório externo |
| `barcode` | varchar(60) | NOT NULL | - | Código de barras para identificação da amostra |
| `status` | enum('GERADO','COLETADO','ENVIADO','RECEBIDO','RESULTADO','CANCELADO') | NOT NULL | 'GERADO' | Status do protocolo no fluxo laboratorial |
| `sistema_externo` | varchar(50) | NULL | NULL | Nome do sistema laboratorial externo (ex: LIMS, HCE) |
| `codigo_externo` | varchar(80) | NULL | NULL | Código de integração no sistema externo |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `atualizado_em` | datetime | NULL | NULL | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_laboratorio_protocolo`
- Únicas: `uk_lab_codigo` (`codigo`) - Garante unicidade do código do exame
- Únicas: `uk_lab_item` (`id_pedido_item`) - Garante unicidade do item do pedido
- Estrangeiras: -

## Índices
- `ix_lab_ffa` (KEY) - Índice em `id_ffa`
- `ix_lab_gpat` (KEY) - Índice em `id_gpat`
- `ix_lab_status` (KEY) - Índice em `status`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `ffa` - Muitos protocolos podem estar associados a um FFA
- N:1 com `gpat` - Muitos protocolos podem estar associados a um GPAT
- N:1 com `procedimento_pedido_item` - Cada item de pedido tem um protocolo único

## Dependências
- Esta tabela é referenciada por: `lab_amostra`
- Esta tabela depende de: `ffa`, `gpat`, `procedimento_pedido_item`, `procedimento_codigo_universal`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Protocolo é criado quando FFA gera solicitação de exame laboratorial
2. Código e barcode são gerados para identificação da amostra
3. Status GERADO indica protocolo criado aguardando coleta
4. COLETADO após coleta física da amostra
5. ENVIADO quando amostra é enviada ao laboratório
6. RECEBIDO quando laboratório confirma recebimento
7. RESULTADO quando resultado é recebido do laboratório
8. CANCELADO em caso de erro ou desistência
9. Integração com LIMS via sistema_externo e codigo_externo