# cat_notificacao

Objetivo: Registrar notificações de CAT (Comunicação de Acidente do Trabalho) para acompanhamento.
Descrição: Tabela que gerencia notificações de acidentes de trabalho, armazenando informações do evento, responsável e protocolos internos/externos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cat | bigint | NOT NULL | - | Identificador único da notificação, chave primária auto incrementada. |
| id_ffa | bigint | NOT NULL | - | Referência à FFA (Ficha de Atendimento) associada à notificação. |
| id_gpat | bigint | NOT NULL | - | Referência ao GPAT (Grupo de Atendimento) relacionado. |
| id_pedido_item | bigint | Nullable | - | Referência ao item de pedido associado (opcional). |
| id_usuario_responsavel | bigint | NOT NULL | - | Referência ao usuário responsável pela notificação. |
| status | enum('ABERTA','EM_PREENCHIMENTO','ENVIADA','CANCELADA','CONCLUIDA') | NOT NULL | 'ABERTA' | Status: aberta, em preenchimento, enviada, cancelada ou concluída. |
| data_evento | datetime | Nullable | - | Data do evento notificado. |
| local_evento | varchar(255) | Nullable | - | Local onde ocorreu o evento. |
| ocupacao | varchar(120) | Nullable | - | Ocupação/profissão do trabalhador afetado. |
| empresa | varchar(255) | Nullable | - | Nome da empresa contratante do trabalhador. |
| cnpj | varchar(20) | Nullable | - | CNPJ da empresa para identificação. |
| detalhes | text | Nullable | - | Detalhes adicionais sobre o evento notificado. |
| protocolo_interno | varchar(50) | Nullable | - | Protocolo interno gerado para rastreamento. |
| protocolo_externo | varchar(80) | Nullable | - | Protocolo externo (ex: do MTE ou órgão regulador). |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação da notificação. |
| atualizado_em | datetime | Nullable | - | Timestamp da última atualização. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual a notificação pertence. |

## Chaves
- Primária: id_cat
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_cat)
- KEY ix_cat_ffa (id_ffa)
- KEY ix_cat_gpat (id_gpat)
- KEY ix_cat_status (status)

## Constraints
- PRIMARY KEY: id_cat

## Relacionamentos e Cardinalidade
- N:1 com FFA (id_ffa) - opcional
- N:1 com GPAT (id_gpat) - opcional
- N:1 com pedido_item (id_pedido_item) - opcional
- N:1 com usuario (id_usuario_responsavel)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: FFA, GPAT, pedido_item, usuario, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Criada quando há necessidade de notificar acidente de trabalho
- Status acompanha o progresso da notificação
- Protocolos permitem rastreamento interno e externo
- Integrada ao processo de preenchimento da CAT completa