# log_auditoria

Objetivo: Manter registro imutável de todas as ações críticas realizadas no sistema para auditoria completa.
Descrição: Tabela que registra todas as operações de INSERT, UPDATE e DELETE realizadas em tabelas críticas do sistema, permitindo auditoria completa e replay de mudanças.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_log` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do log de auditoria |
| `id_usuario` | bigint | NULL | NULL | Usuário que realizou a ação sendo auditada |
| `acao` | varchar(100) | NULL | NULL | Tipo de ação (INSERT, UPDATE, DELETE) |
| `tabela_afetada` | varchar(100) | NULL | NULL | Nome da tabela onde a ação ocorreu |
| `id_registro` | bigint | NULL | NULL | ID do registro afetado pela ação |
| `antes` | text | NULL | NULL | Snapshot JSON do registro antes da alteração |
| `depois` | text | NULL | NULL | Snapshot JSON do registro após a alteração |
| `justificativa` | varchar(255) | NULL | NULL | Justificativa fornecida pelo usuário para a ação |
| `data_hora` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp da ação auditada |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_log`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `usuario` - Muitas ações podem ter sido feitas pelo mesmo usuário
- N:1 com `saas_entidade` - Muitos logs pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Triggers nas tabelas críticas gravam ações nesta tabela
2. O campo `antes` contém snapshot da linha antes de mudanças
3. O campo `depois` contém snapshot da linha após mudanças
4. A `justificativa` é obrigatória para operações sensíveis
5. Usado para investigação de inconsistências
6. Permite replay de ações para recuperação
7. Base para relatórios de compliance e auditoria
8. Usado para tracking de edições não autorizadas
9. Integração com kernel_ledger para ledger unificado