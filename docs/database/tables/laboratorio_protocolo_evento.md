# laboratorio_protocolo_evento

Objetivo: Registrar eventos e mudanças de estado dos protocolos de integração laboratorial.
Descrição: Tabela de auditoria que registra todas as mudanças de status e eventos ocorridos nos protocolos de laboratório, permitindo rastrear o histórico completo de cada protocolo desde a criação até o resultado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_evento` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do evento |
| `id_laboratorio_protocolo` | bigint | NOT NULL | - | Referência ao protocolo de laboratório |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que realizou a ação |
| `evento` | varchar(40) | NOT NULL | - | Tipo do evento (ex: STATUS_ALTERADO, RESULTADO_RECEBIDO) |
| `detalhe` | varchar(255) | NULL | NULL | Detalhes do evento em formato texto |
| `payload_json` | json | NULL | NULL | Payload JSON com dados adicionais do evento |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do evento |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_evento`
- Únicas: -
- Estrangeiras: -

## Índices
- `ix_lab_evt_proto` (KEY) - Índice em `id_laboratorio_protocolo`
- `ix_lab_evt_evt` (KEY) - Índice em `evento`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `laboratorio_protocolo` - Muitos eventos pertencem a um protocolo
- N:1 com `sessao_usuario` - Muitos eventos podem estar associados a uma sessão

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `laboratorio_protocolo`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada mudança de status em protocolo gera um evento
2. O tipo evento classifica a ação realizada
3. O detalhe fornece informações adicionais sobre a mudança
4. O payload_json contém dados estruturados para auditoria completa
5. Usado para rastrear histórico de protocolos laboratoriais
6. Permite replay de mudanças em sincronização distribuída
7. Base para relatórios de SLA e tempos de processamento