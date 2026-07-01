# notificacao_violencia_evento

Objetivo: Registrar eventos e mudanças de status nas notificações de violência.
Descrição: Tabela de auditoria que registra todas as mudanças ocorridas em notificações de violência, mantendo histórico completo para investigação e compliance.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_notificacao` | bigint | NOT NULL | - | Referência à notificação de violência |
| `tipo_evento` | enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','ANEXO','EXPORTACAO','ERRO') | NOT NULL | - | Tipo do evento ocorrido |
| `status_anterior` | varchar(30) | NULL | NULL | Status anterior antes da mudança |
| `status_novo` | varchar(30) | NULL | NULL | Status novo após a mudança |
| `detalhes` | text | NULL | NULL | Detalhes adicionais do evento |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que realizou a ação |
| `id_usuario` | bigint | NOT NULL | - | Usuário que realizou a ação |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp do evento |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_evento`
- Únicas: -
- Estrangeiras: 
  - `fk_nve_notif` (`id_notificacao`) → `notificacao_violencia` (`id`) - Vincula ao evento; exclui em cascata

## Índices
- `idx_nve_notif` (KEY) - Índice em `id_notificacao`
- `idx_nve_sessao` (KEY) - Índice em `id_sessao_usuario`

## Constraints
- `fk_nve_notif` FOREIGN KEY - Relaciona `id_notificacao` com `notificacao_violencia`.`id` (ON DELETE CASCADE)

## Relacionamentos e Cardinalidade
- N:1 com `notificacao_violencia` - Muitos eventos pertencem a uma notificação
- N:1 com `sessao_usuario` - Muitos eventos podem estar associados a uma sessão
- N:1 com `usuario` - Muitos eventos podem ter sido feitos pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `notificacao_violencia`, `sessao_usuario`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança na notificação gera um evento
2. Tipo_evento indica a natureza da mudança
3. Status_anterior e status_novo permitem rastrear evolução
4. Anexos podem ser registrados para documentação
5. Exportação registra envio a órgãos externos
6. Usado para compliance com leis de proteção
7. Base para relatórios de investigação
8. Permite rastrear responsáveis por cada etapa
9. Usado para auditoria de processos de notificação