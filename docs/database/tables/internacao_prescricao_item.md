# internacao_prescricao_item

Objetivo: Armazenar os itens individuais das prescrições médicas realizadas durante internações hospitalares.
Descrição: Tabela que detalha cada item prescrito no contexto de uma internação, incluindo medicamentos, dietas, cuidados e outros tipos de prescrições. Permite rastrear a dosagem, frequência, via de administração, período de validade e status de cada item prescrito.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_internacao_prescricao_item` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do item de prescrição |
| `id_internacao_prescricao` | bigint | NOT NULL | - | Referência à prescrição de internação à qual o item pertence |
| `tipo` | enum('MEDICAMENTO','DIETA','CUIDADO','OUTRO') | NOT NULL | - | Classificação do tipo de item prescrito: MEDICAMENTO, DIETA, CUIDADO ou OUTRO |
| `descricao` | varchar(255) | NOT NULL | - | Descrição textual do item prescrito |
| `dosagem` | varchar(60) | NULL | NULL | Dosagem do medicamento ou tratamento prescrito |
| `frequencia` | varchar(60) | NULL | NULL | Frequência com que o item deve ser administrado |
| `via_administracao` | varchar(60) | NULL | NULL | Via de administração do medicamento (oral, intravenosa, etc.) |
| `inicio_em` | datetime | NULL | NULL | Data e hora de início da prescrição do item |
| `fim_em` | datetime | NULL | NULL | Data e hora de término da prescrição do item |
| `status` | enum('ATIVO','SUSPENSO','ENCERRADO') | NOT NULL | 'ATIVO' | Status atual do item: ATIVO, SUSPENSO ou ENCERRADO |
| `observacoes` | text | NULL | NULL | Observações complementares sobre o item prescrito |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `id_atendimento` | bigint unsigned | NOT NULL | - | Referência ao atendimento hospitalar relacionado |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade (organização) proprietária do registro |

## Chaves
- Primária: `id_internacao_prescricao_item`
- Únicas: -
- Estrangeiras: 
  - `fk_internacao_prescricao_item_atendimento` (`id_atendimento`) → `atendimento` (`id_atendimento`) - Relaciona o item de prescrição ao atendimento; exclui em cascata e atualiza em cascata
  - `fk_internacao_prescricao_item_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula o registro à entidade proprietária
  - `fk_ipi_prescricao` (`id_internacao_prescricao`) → `internacao_prescricao` (`id_internacao_prescricao`) - Relaciona o item à prescrição de internação

## Índices
- `idx_ipi_prescricao` (KEY) - Índice na coluna `id_internacao_prescricao`
- `idx_ipi_tipo` (KEY) - Índice na coluna `tipo`
- `idx_ipi_status` (KEY) - Índice na coluna `status`
- `fk_internacao_prescricao_item_atendimento` (KEY) - Índice na coluna `id_atendimento`
- `idx_int_prescitem_ent` (KEY) - Índice na coluna `id_entidade`

## Constraints
- `fk_internacao_prescricao_item_atendimento` FOREIGN KEY - Relaciona `id_atendimento` com `atendimento`.`id_atendimento` (ON DELETE CASCADE ON UPDATE CASCADE)
- `fk_internacao_prescricao_item_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`
- `fk_ipi_prescricao` FOREIGN KEY - Relaciona `id_internacao_prescricao` com `internacao_prescricao`.`id_internacao_prescricao`

## Relacionamentos e Cardinalidade
- N:1 com `internacao_prescricao` - Muitos itens pertencem a uma prescrição
- N:1 com `atendimento` - Muitos itens de prescrição podem estar associados a um atendimento
- N:1 com `saas_entidade` - Muitos itens de prescrição pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (verificar tabelas que possuem FK para esta)
- Esta tabela depende de: `internacao_prescricao`, `atendimento`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Durante a internação, o médico cria uma prescrição na tabela `internacao_prescricao`
2. Cada item da prescrição é inserido como um registro nesta tabela
3. O enfermeiro/administração visualiza os itens com status ATIVO para execução
4. O sistema permite suspender ou encerrar itens conforme necessidade clínica
5. As observações são usadas para instruções específicas de administração