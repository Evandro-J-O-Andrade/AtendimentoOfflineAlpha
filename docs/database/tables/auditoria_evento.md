# auditoria_evento

Objetivo: Registrar todos os eventos ocorridos no sistema para auditoria completa e rastreabilidade.
Descrição: Tabela de auditoria central que registra qualquer evento relevante no sistema, incluindo domínio, tipo, payload e metadata para rastreio completo de atividades.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_auditoria | bigint | NOT NULL | - | Identificador único do evento de auditoria, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que realizou a ação/evento. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário no momento do evento. |
| dominio | varchar(50) | NOT NULL | - | Domínio/categoria do evento (ex: FILA, ASSISTENCIAL, FINANCEIRO, ESTOQUE). |
| tipo_evento | varchar(100) | NOT NULL | - | Tipo específico do evento dentro do domínio. |
| id_referencia | bigint | Nullable | - | Identificador do registro referenciado pelo evento. |
| payload | json | Nullable | - | Payload com dados completos do evento em formato JSON. |
| metadata | json | Nullable | - | Metadados complementares do evento em formato JSON. |
| criado_em | datetime(6) | NOT NULL | - | Timestamp de criação do evento com precisão de microsegundos. |
| status | varchar(20) | Nullable | 'OK' | Status do evento (OK, ERRO, PENDENTE, etc.). |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o evento pertence. |

## Chaves
- Primária: id_auditoria
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_auditoria)
- KEY idx_usuario (id_usuario)
- KEY idx_sessao (id_sessao_usuario)
- KEY idx_dominio_tipo (dominio, tipo_evento)
- KEY idx_referencia (id_referencia)

## Constraints
- PRIMARY KEY: id_auditoria

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario)
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, sessao_usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em todas as operações significativas do sistema
- Fornece rastreio completo de ações por usuário, sessão e domínio
- Payload e metadata permitem reconstrução completa do evento
- Base para análise de performance, bugs e atividades suspeitas