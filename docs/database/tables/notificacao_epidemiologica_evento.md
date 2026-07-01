# notificacao_epidemiologica_evento

Objetivo: Registrar eventos e mudanças de status nas notificações epidemiológicas.
Descrição: Tabela de auditoria que registra todas as mudanças ocorridas em notificações epidemiológicas, permitindo rastrear histórico completo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_notificacao` | bigint | NOT NULL | - | Referência à notificação epidemiológica |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que realizou a ação |
| `tipo` | varchar(50) | NOT NULL | - | Tipo do evento (ex: "STATUS_ALTERADO", "ENVIADO") |
| `detalhe` | text | NULL | NULL | Detalhes do evento |
| `id_usuario` | bigint | NOT NULL | - | Usuário que realizou a ação |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_evento`
- Únicas: -
- Estrangeiras: 
  - `fk_ne_evento_notif` (`id_notificacao`) → `notificacao_epidemiologica` (`id`) - Vincula ao evento
  - `fk_ne_evento_usuario` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula ao usuário

## Índices
- `idx_ne_evento_notif` (KEY) - Índice composto em `id_notificacao` e `criado_em`
- `idx_ne_evento_sessao` (KEY) - Índice composto em `id_sessao_usuario` e `criado_em`
- `idx_ne_evento_usuario` (KEY) - Índice composto em `id_usuario` e `criado_em`

## Constraints
- `fk_ne_evento_notif` FOREIGN KEY - Relaciona `id_notificacao` com `notificacao_epidemiologica`.`id`
- `fk_ne_evento_usuario` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `notificacao_epidemiologica` - Muitos eventos pertencem a uma notificação
- N:1 com `sessao_usuario` - Muitos eventos podem estar associados a uma sessão
- N:1 com `usuario` - Muitos eventos podem ter sido feitos pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `notificacao_epidemiologica`, `sessao_usuario`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança de status na notificação gera um evento
2. Tipo indica a natureza da mudança
3. Detalhe fornece informações adicionais
4. Usado para auditoria completa de notificações
5. Permite replay de eventos para integração com outros sistemas
6. Base para relatórios de cumprimento de prazos
7. Usado para investigação de falhas no envio
8. Integra com kernel_runtime_evento para sincronização