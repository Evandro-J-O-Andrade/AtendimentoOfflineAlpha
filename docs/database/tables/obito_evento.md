# obito_evento

Objetivo: Registrar eventos e mudanças de status nos registros de óbito.
Descrição: Tabela de auditoria que rastreia mudanças no registro de óbito, permitindo histórico completo das atualizações.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_obito_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_obito` | bigint | NOT NULL | - | Referência ao registro de óbito |
| `tipo_evento` | enum('REGISTRADO','ATUALIZADO','CANCELADO') | NOT NULL | - | Tipo do evento ocorrido |
| `descricao` | text | NULL | NULL | Descrição do evento |
| `id_usuario` | bigint | NULL | NULL | Usuário que realizou a ação |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_obito_evento`
- Únicas: -
- Estrangeiras: 
  - `fk_ob_evt_obito` (`id_obito`) → `obito` (`id_obito`) - Vincula ao registro de óbito

## Índices
- `idx_ob_evt_obito` (KEY) - Índice em `id_obito`
- `idx_ob_evt_tipo` (KEY) - Índice composto em `tipo_evento` e `criado_em`
- `idx_ob_evt_obito_data` (KEY) - Índice composto em `id_obito` e `criado_em`

## Constraints
- `fk_ob_evt_obito` FOREIGN KEY - Relaciona `id_obito` com `obito`.`id_obito`

## Relacionamentos e Cardinalidade
- N:1 com `obito` - Muitos eventos pertencem a um registro de óbito
- N:1 com `usuario` - Muitos eventos podem ter sido feitos pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `obito`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança no registro de óbito gera um evento
2. Tipo REGISTRADO indica criação do registro
3. Tipo ATUALIZADO indica atualização dos dados
4. Tipo CANCELADO indica cancelamento do registro
5. Permite auditoria completa de alterações
6. Base para investigações de mortalidade
7. Usado para rastrear responsáveis por mudanças
8. Permite replay de eventos em sincronização