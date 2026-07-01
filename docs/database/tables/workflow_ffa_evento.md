# workflow_ffa_evento

Objetivo: Registrar a trilha de eventos do workflow de FFA (Fluxo de Fluxo Assistencial) para auditoria e rastreamento.
Descrição: Tabela de log de eventos do workflow de FFA que armazena todos os eventos ocorridos durante o processamento de fluxos assistenciais. Registra origem, entidade, tipo de evento, detalhes, sessão e payload JSON para reconstrução completa do histórico. Funciona como sistema de trilha de auditoria do motor de workflow assistencial.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_workflow_evento | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o evento do workflow |
| id_ffa | bigint | NO | NULL | Identificador do FFA (Fluxo de Fluxo Assistencial) ao qual este evento pertence |
| origem | varchar(20) | NO | NULL | Origem do evento (ex: API, WORKER, HEARTBEAT) |
| entidade | varchar(50) | YES | NULL | Nome da entidade ou tabela de origem do evento |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este evento pertence |
| tipo_evento | varchar(60) | NO | NULL | Tipo do evento do workflow (ex: CRIADO, ATUALIZADO, FINALIZADO, ERRO) |
| detalhe | text | YES | NULL | Descrição textual detalhada do evento ocorrido |
| id_sessao_usuario | bigint | YES | NULL | Identificador da sessão de usuário que originou ou está associada ao evento |
| criado_em | datetime | NO | NULL | Data e hora de criação do evento |
| payload_json | json | YES | NULL | Dados estruturados em JSON com detalhes adicionais do evento |

## Chaves
- Primária: id_workflow_evento
- Únicas: Nenhuma
- Estrangeiras: fk_workflow_sessao (id_sessao_usuario -> sessao_usuario.id_sessao_usuario)

## Índices
- ix_wf_ffa (id_ffa, criado_em)
- ix_wf_tipo (tipo_evento)
- ix_wf_origem (origem)
- ix_wf_entidade (entidade, id_entidade)
- fk_workflow_sessao (id_sessao_usuario)

## Constraints
- fk_workflow_sessao: FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- N:1 com ffa (muitos eventos pertencem a um FFA)
- N:1 com sessao_usuario (muitos eventos podem estar associados a uma sessão)
- N:1 com saas_entidade (muitos eventos pertencem a uma entidade)

## Dependências
- Depende de: ffa (implícito), sessao_usuario, saas_entidade
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- O motor de workflow FFA insere eventos aqui para cada transição de estado ou ação relevante
- Usado para reconstruir o histórico completo de um fluxo assistencial para auditoria e suporte
- Permite rastrear em que ponto um fluxo parou ou falhou
- Consultado em ferramentas de monitoramento e debugging de workflows
- O payload_json armazena dados contextuais específicos de cada evento para análise detalhada
