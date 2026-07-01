# procedimento_protocolo

Objetivo: Gerenciar protocolos de procedimentos médicos como exames e raio-x, com status de execução e vínculo com fichas de atendimento.

Descrição: Tabela que controla protocolos de procedimentos realizados no contexto de atendimento assistido, permitindo rastreamento completo do ciclo de vida do procedimento desde a criação até finalização ou cancelamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_protocolo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do protocolo de procedimento |
| tipo | enum('EXAME','RX') | NOT NULL | - | Tipo de procedimento: EXAME ou RX (raio-x) |
| codigo | varchar(50) | NOT NULL | - | Código identificador do protocolo de procedimento |
| barcode | varchar(50) | NOT NULL | - | Código de barras para identificação rápida do protocolo |
| status | enum('CRIADO','EM_EXECUCAO','FINALIZADO','CANCELADO') | NOT NULL | 'CRIADO' | Status do protocolo: CRIADO, EM_EXECUCAO, FINALIZADO ou CANCELADO |
| id_ffa | bigint | NOT NULL | - | Referência ao id da ficha de atendimento assistido (FFA) à qual o protocolo está vinculado |
| id_fila | bigint | NOT NULL | - | Referência ao id da fila operacional onde o protocolo está enfileirado |
| id_sessao_criacao | bigint | NOT NULL | - | Referência ao id da sessão do usuário que criou o protocolo |
| id_usuario_criacao | bigint | NOT NULL | - | Referência ao id do usuário que criou o protocolo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do protocolo |
| atualizado_em | datetime | YES | NULL | Data e hora da última atualização do protocolo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o protocolo foi criado |

## Chaves
- Primária: id_protocolo
- Únicas: uk_protocolo_codigo (codigo), uk_protocolo_fila (id_fila, tipo)
- Estrangeiras: fk_prot_fila (id_fila → fila_operacional.id_fila) - vincula o protocolo à fila operacional; fk_prot_usuario (id_usuario_criacao → usuario.id_usuario) - identifica o usuário que criou o protocolo

## Índices
- PRIMARY KEY (id_protocolo)
- UNIQUE KEY uk_protocolo_codigo (codigo)
- UNIQUE KEY uk_protocolo_fila (id_fila, tipo)
- KEY idx_prot_ffa (id_ffa)
- KEY idx_prot_status (tipo, status, criado_em)
- KEY fk_prot_sessao (id_sessao_criacao)
- KEY fk_prot_usuario (id_usuario_criacao)

## Constraints
- CONSTRAINT fk_prot_fila FOREIGN KEY (id_fila) REFERENCES fila_operacional (id_fila)
- CONSTRAINT fk_prot_usuario FOREIGN KEY (id_usuario_criacao) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com ffa (uma ficha pode ter vários protocolos de procedimento)
- N:1 com fila_operacional (uma fila pode ter vários protocolos)
- N:1 com usuario (um usuário pode criar vários protocolos)

## Dependências
- Tabelas que dependem desta: procedimento_protocolo_evento, procedimento_protocolo_resultado
- Esta tabela depende de: ffa, fila_operacional, usuario

## Fluxo de utilização dentro do sistema
- Criado quando um exame ou raio-x é solicitado durante um atendimento
- Entra em uma fila operacional para execução
- Permite acompanhamento de status ao longo do processo
- Eventos de execução são registrados em procedimento_protocolo_evento