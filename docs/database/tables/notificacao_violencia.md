# notificacao_violencia

Objetivo: Registrar notificações de violência contra pacientes, especialmente crianças e idosos.
Descrição: Tabela que documenta casos suspeitos de violência contra pacientes, para notificação às autoridades competentes (ex: Conselho Tutelar, polícia).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da notificação |
| `id_atendimento` | bigint unsigned | NOT NULL | - | Referência ao atendimento onde a notificação foi feita |
| `categoria` | enum('VIOLENCIA','AGRESSAO','ABUSO','TRANSITO','OUTRA') | NOT NULL | - | Categoria da violência suspeita |
| `tipo` | varchar(80) | NULL | NULL | Tipo específico de violência |
| `data_ocorrencia` | datetime | NULL | NULL | Data e hora da ocorrência suspeita |
| `local_ocorrencia` | varchar(120) | NULL | NULL | Local onde ocorreu a violência |
| `suspeito_relacao` | varchar(120) | NULL | NULL | Relação com suspeito (ex: "pai", "cuidador") |
| `cid10_relacionado` | varchar(10) | NULL | NULL | CID10 relacionado à lesão |
| `status_notificacao` | enum('ABERTA','EM_INVESTIGACAO','ENVIADA','ARQUIVADA') | NOT NULL | 'ABERTA' | Status da notificação |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que criou a notificação |
| `id_usuario_criador` | bigint | NOT NULL | - | Usuário que criou a notificação |
| `observacao` | text | NULL | NULL | Observações sobre o caso |
| `protocolo_externo` | varchar(60) | NULL | NULL | Protocolo do órgão externo |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `atualizado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_nv_atendimento` (KEY) - Índice em `id_atendimento`
- `idx_nv_status` (KEY) - Índice em `status_notificacao`
- `idx_nv_sessao` (KEY) - Índice em `id_sessao_usuario`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `atendimento` - Muitas notificações podem pertencer a um atendimento
- N:1 com `sessao_usuario` - Muitas notificações podem estar associadas a uma sessão
- N:1 com `usuario` - Muitas notificações podem ter sido feitas pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: `notificacao_violencia_evento`
- Esta tabela depende de: `atendimento`, `sessao_usuario`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Caso suspeito é registrado durante atendimento com status ABERTA
2. Profissional deve investigar o caso (EM_INVESTIGACAO)
3. Após decisão, notificação é ENVIADA ao órgão competente
4. Protocolo externo é armazenado para acompanhamento
5. Caso não confirmado, é ARQUIVADA
6. Usado para cumprimento da lei de notificação de violência
7. Base para relatórios a Conselho Tutelar e autoridades
8. Integração com sistemas de segurança pública
9. Usado para proteção de vulneráveis (crianças, idosos)