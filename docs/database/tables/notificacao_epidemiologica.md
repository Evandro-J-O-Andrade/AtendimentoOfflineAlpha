# notificacao_epidemiologica

Objetivo: Registrar notificações epidemiológicas obrigatórias ao Ministério da Saúde.
Descrição: Tabela que armazena notificações de doenças notificáveis e suspeitas epidemiológicas, como sarampo, dengue, tuberculose, para transmissão ao MS.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da notificação |
| `id_atendimento` | bigint | NOT NULL | - | Referência ao atendimento onde a notificação foi feita |
| `cid_10` | varchar(10) | NOT NULL | - | Código CID10 da doença suspeita/notificada |
| `doenca_suspeita` | varchar(100) | NULL | NULL | Nome da doença suspeita (texto livre) |
| `status_notificacao` | enum('PENDENTE','ENVIADO_MS','ARQUIVADO') | NULL | 'PENDENTE' | Status da notificação ao MS |
| `data_evento` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp do evento/notificação |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que criou a notificação |
| `id_usuario_criador` | bigint | NULL | NULL | Usuário que criou a notificação |
| `observacao` | text | NULL | NULL | Observações sobre a notificação |
| `protocolo_ms` | varchar(50) | NULL | NULL | Protocolo gerado pelo Ministério da Saúde |
| `atualizado_em` | datetime | NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_notif_epid_sessao` (KEY) - Índice em `id_sessao_usuario`
- `idx_notif_epid_usuario` (KEY) - Índice em `id_usuario_criador`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `atendimento` - Muitas notificações podem pertencer a um atendimento
- N:1 com `sessao_usuario` - Muitas notificações podem estar associadas a uma sessão
- N:1 com `usuario` - Muitas notificações podem ter sido feitas pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: `notificacao_epidemiologica_evento`
- Esta tabela depende de: `atendimento`, `sessao_usuario`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Médico identifica caso notificável durante atendimento
2. Notificação é criada com status PENDENTE
3. Sistema verifica notificações pendentes para envio ao MS
4. Após envio, status muda para ENVIADO_MS
5. Protocolo MS é armazenado para referência
6. Casos negados podem ser ARQUIVADO
7. Usado para conformidade com vigilância epidemiológica
8. Base para relatórios de vigilância e alertas de surtos
9. Integração com sistemas de saúde pública para envio automático