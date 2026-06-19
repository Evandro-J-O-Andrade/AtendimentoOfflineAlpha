# AUDITORIA_ARQUITETURA_BANCO_SP_MASTER_CANONICA.md

## STATUS

Documento Canônico de Auditoria Técnica.

Define o prompt oficial, neutro e reprodutível para auditoria externa de banco MySQL, stored procedures e arquitetura SP-FIRST.

Este documento deve ser usado quando houver necessidade de validar a arquitetura real do banco a partir do Dump Oficial, sem depender de interpretação informal.

---

# FINALIDADE

Este documento existe para transformar análise arquitetural em auditoria técnica reprodutível.

O objetivo é permitir que qualquer IA, engenheiro ou auditor técnico analise o Dump SQL e chegue às mesmas conclusões quando as evidências forem suficientes.

A auditoria deve separar:

* fatos observáveis
* inferências arquiteturais
* riscos técnicos
* recomendações técnicas

---

# LEI DE USO

Ao auditar o banco, a análise deve obedecer obrigatoriamente a estas leis:

1. Não inventar arquitetura.
2. Não assumir padrões externos, como Kafka, microservices, DDD, event sourcing ou workflow engine, sem evidência no dump.
3. Basear todas as conclusões exclusivamente no Dump SQL.
4. Não simplificar o sistema quando houver múltiplos padrões.
5. Não tratar divergência arquitetural como erro automaticamente.
6. Não sugerir rewrite completo sem evidência técnica suficiente.
7. Mapear todos os padrões encontrados, mesmo que coexistam.
8. Distinguir sempre o que é fato, inferência e risco.

---

# CONTEXTO

Este banco faz parte de uma plataforma crítica multi-domínio, incluindo assistencial, logística, financeiro e operacional, com alto volume de regras de negócio implementadas em stored procedures.

O banco deve ser analisado como parte de uma arquitetura SP-FIRST, onde stored procedures são a camada oficial de negócio.

---

# PROMPT MESTRE OFICIAL

Copiar e colar exatamente o bloco abaixo em outras IAs junto do Dump.sql:

```text
Você é um Staff Engineer / Principal Architect especializado em bancos MySQL de alta complexidade e sistemas event-driven enterprise, nível hospitalar, ERP ou fintech.

Sua tarefa é realizar uma auditoria técnica completa, neutra e imparcial do banco de dados fornecido, usando exclusivamente o dump SQL.

Não use suposições externas. Não invente arquitetura. Não assuma padrões como Kafka, microservices, DDD, event sourcing ou workflow engine se não houver evidência direta no dump.

Separe claramente:

1. fatos observáveis
2. inferências arquiteturais
3. riscos técnicos
4. recomendações técnicas

# Objetivo da análise

Identificar e documentar a arquitetura real do banco a partir das tabelas, stored procedures, funções, views, triggers, eventos, logs, auditoria, workflows e convenções observáveis.

# Regras críticas

1. Toda conclusão deve apontar evidência concreta: nome de tabela, procedure, coluna, índice, trigger, comentário, padrão de nomeação ou estrutura de parâmetros.
2. Se não houver evidência suficiente, declare explicitamente: "sem evidência observável no dump".
3. Se houver múltiplos padrões, mapeie todos. Não simplifique.
4. Não trate divergência arquitetural como erro automático. Descreva o risco técnico.
5. Não recomende rewrite completo sem justificativa técnica forte.
6. Não use termos como "gateway interno", "event store", "state machine" ou "workflow engine" como afirmação sem evidência.
7. Se um termo for inferido, marque como inferência.
8. Se um termo for sugerido como melhoria, marque como recomendação.

# 1. Estrutura global do sistema

Mapear:

* domínios existentes
* módulos funcionais
* agrupamentos naturais de tabelas
* sistemas paralelos, se existirem
* padrões de nomeação
* separação por contexto funcional
* dependências entre domínios

Responder:

1. Quais domínios são observáveis no dump?
2. Existem módulos funcionais claros?
3. Existem sistemas paralelos ou ilhas de dados?
4. Há separação entre dados assistenciais, logísticos, financeiros e operacionais?
5. Há evidência de núcleo comum, como sessão, usuário, empresa, unidade, permissão, auditoria ou evento?

# 2. Camada de orquestração

Investigar se existem:

* stored procedures de entrada central
* dispatcher
* roteadores de fluxo
* switch/case
* dynamic call
* routing tables
* validação de sessão
* validação de permissões
* mecanismos de idempotência
* execução dinâmica de stored procedures
* tabelas de rotas, ações, eventos, workflows ou comandos

Responder:

1. Existe uma procedure de entrada única ou central?
2. Existe separação entre entrada, decisão e execução?
3. Existe um padrão de dispatcher/orquestrador?
4. Existe execução dinâmica de procedures?
5. Há roteamento baseado em tabela, JSON, rota, método ou evento?
6. Há validação de sessão e permissões antes da execução?
7. Há evidência de idempotência?
8. Há risco de múltiplas entradas para a mesma operação?

# 3. Camada de execução em stored procedures

Mapear todas as stored procedures observáveis e classificá-las em grupos:

* master
* dispatcher
* orquestradora
* domínio
* executor
* autenticação
* autorização
* sessão
* evento
* auditoria
* workflow
* utilitária
* relatório
* migração
* manutenção

Para cada grupo, documentar:

* nomes
* parâmetros de entrada
* parâmetros de saída
* uso de JSON
* uso de transações
* uso de dynamic SQL, incluindo PREPARE e EXECUTE
* chamadas a outras procedures
* chamadas a funções
* inserções em tabelas de evento
* inserções em tabelas de auditoria
* validações de sessão e permissão

Responder:

1. Existe padrão consistente de assinatura?
2. Toda procedure pública recebe contexto de sessão?
3. Existe separação entre procedures master e procedures de domínio?
4. Existem executores especializados por domínio?
5. Há múltiplos estilos de procedure coexistindo?
6. Há procedures que fazem tudo: validar, decidir, executar e persistir?
7. Há procedures que apenas delegam?
8. Há procedures que executam SQL dinâmico?
9. Há risco de contrato instável entre frontend, backend e banco?

# 4. Sistema de eventos

Mapear todas as tabelas com padrão:

* *_evento
* *_eventos
* *_log
* *_logs
* *_audit
* *_auditoria
* *_stream
* *_workflow
* *_fila
* *_queue
* *_job
* *_task

Para cada tabela, documentar:

* nome
* colunas principais
* chaves
* índices
* relação com sessão/usuário/empresa/unidade
* relação com entidade de negócio
* payload JSON, se houver
* tipo de evento ou log
* granularidade
* retenção ou purge, se houver

Responder:

1. Existe um event store único?
2. Ou existem múltiplos logs por domínio?
3. Existe fragmentação de eventos?
4. Existe rastreabilidade global de eventos?
5. Eventos preservam sessão, usuário, contexto operacional e payload?
6. Eventos são imutáveis ou podem ser alterados?
7. Há correlação entre eventos e estado atual?
8. Há ordem, sequência ou versionamento?
9. Há evidência de processamento assíncrono?

# 5. Sistema de estado

Investigar:

* snapshots
* tabelas de estado global
* hash de estado
* auditoria de mudança
* versionamento lógico
* controle de versão de entidade
* status
* workflow_state
* histórico
* versões
* estado distribuído

Mapear tabelas com padrão:

* *_estado
* *_status
* *_snapshot
* *_historico
* *_versao
* *_state
* *_workflow
* *_auditoria
* *_log
* *_evento

Responder:

1. Existe state machine global?
2. Ou existe estado distribuído sem coordenação central?
3. Estado é derivado de eventos?
4. Estado é persistido diretamente?
5. Há hash, checksum ou fingerprint de estado?
6. Há versionamento lógico?
7. Há rastreabilidade de mudança?
8. Há risco de divergência entre estado atual, evento e auditoria?

# 6. Fluxo end-to-end

Reconstruir o fluxo completo a partir das evidências:

Frontend → API → Service → Stored Procedure → Evento → Auditoria → Persistência

Responder:

1. Existe um fluxo único?
2. Existem múltiplos fluxos paralelos?
3. O backend chama procedures diretamente?
4. O backend chama dispatcher?
5. O frontend tem acesso direto ao banco?
6. Há procedures públicas além do dispatcher?
7. Há procedures privadas usadas apenas por outras procedures?
8. Há consultas diretas para leitura?
9. Há escrita direta em tabelas?
10. Há separação entre comando e consulta?

# 7. Avaliação do nível arquitetural

Classificar o sistema em um dos níveis abaixo. A classificação deve ser justificada com evidências, não por opinião.

Níveis:

A. CRUD system simples

B. Modular monolith

C. Event-driven parcial

D. Distributed workflow engine DB-driven

E. Plataforma complexa com múltiplos motores

Para classificar, avaliar:

* centralização de entrada
* existência de dispatcher
* existência de executores especializados
* event store ou logs distribuídos
* state machine central ou distribuída
* separação de domínios
* contrato de procedures
* idempotência
* auditoria global
* rastreabilidade
* acoplamento entre domínios
* complexidade de workflow
* volume de regras de negócio no banco

Responder:

1. Qual nível é mais compatível com as evidências?
2. Quais evidências sustentam essa classificação?
3. Quais evidências contradizem essa classificação?
4. O sistema é uma plataforma complexa, um workflow engine, um monolito modular, um event-driven parcial ou um CRUD?
5. Há mais de uma classificação aplicável por domínio?

# 8. Riscos arquiteturais

Identificar riscos reais com base em evidências.

Avaliar:

* duplicidade de motores
* múltiplas entradas para mesma operação
* procedures com responsabilidades misturadas
* ausência de contrato de dados
* ausência de sessão em procedures públicas
* ausência de permissões
* eventos sem rastreabilidade
* logs fragmentados
* auditoria incompleta
* estado distribuído sem coordenação
* divergência entre evento e estado atual
* SQL dinâmico sem contrato
* transações ausentes ou mal delimitadas
* acoplamento entre domínios
* falta de idempotência
* tabelas sem auditoria
* tabelas sem índices críticos
* procedures sem padronização
* procedures duplicadas ou sobrepostas

Para cada risco, informar:

* fato observável
* impacto técnico
* severidade: baixa, média, alta ou crítica
* evidência
* recomendação

# 9. Padrão de stored procedures master

Verificar se existem procedures com papel de:

* dispatcher
* orquestrador
* executor dinâmico
* roteador de domínio
* roteador por rota
* roteador por evento
* roteador por método
* roteador por contexto operacional

Responder:

1. Existe uma espinha dorsal de procedures master?
2. Qual procedure atua como entrada principal?
3. Quais procedures atuam como orquestradoras?
4. Quais procedures atuam como executores?
5. Qual é a arquitetura lógica observável?
6. Há separação entre entrada, decisão e execução?
7. Há execução dinâmica?
8. Há roteamento por tabela?
9. Há roteamento por JSON?
10. Há roteamento por nome de procedure?
11. Há risco de segurança por dynamic SQL?
12. Há contrato estável entre backend e banco?

# 10. Evidências e contraevidências

Criar uma seção obrigatória com:

* evidências que confirmam a arquitetura inferida
* evidências que contradizem a arquitetura inferida
* lacunas do dump
* dados ausentes que impediriam conclusão definitiva

Responder:

1. O que o dump prova?
2. O que o dump apenas sugere?
3. O que o dump não permite concluir?
4. Quais arquivos ou metadados adicionais seriam necessários para fechar a auditoria?

# Formato obrigatório de saída

Responder sempre neste formato:

## 1. Visão geral do sistema

Listar fatos observáveis, inferências e riscos.

## 2. Arquitetura identificada - diagrama textual

Desenhar a arquitetura com base nas evidências.

## 3. Camadas reais detectadas

Listar camadas observáveis: entrada, orquestração, execução, eventos, auditoria, estado, persistência.

## 4. Stored procedures críticas - mapa

Mapear procedures master, dispatcher, orquestradoras, executoras, domínio, evento, auditoria e utilitárias.

## 5. Sistema de eventos

Mapear tabelas de evento, log, audit, stream, workflow, fila e job.

## 6. Sistema de estado

Mapear tabelas de estado, status, snapshot, histórico, versão, workflow e auditoria.

## 7. Grau de maturidade arquitetural

Classificar em A, B, C, D ou E, com justificativa baseada em evidências.

## 8. Problemas reais - fatos, não opinião

Listar apenas problemas sustentados por evidências.

## 9. Recomendações técnicas

Listar recomendações priorizadas, distinguindo correções obrigatórias, melhorias de governança e evoluções futuras.

## 10. Evidências e contraevidências

Listar evidências que sustentam, contradizem ou limitam a análise.

# Importante

Não tentar simplificar o sistema.

Não assumir que divergência é erro.

Não assumir que coexistência de padrões é arquitetura ruim.

Não sugerir rewrite completo sem necessidade.

Não usar hype arquitetural.

Não afirmar existência de event store, workflow engine, gateway interno, state machine ou microserviços sem evidência direta.

A análise deve ser técnica, neutra, reprodutível e baseada exclusivamente no Dump.sql.
```

---

# Critérios de aceitação da auditoria

Uma auditoria produzida com este prompt é considerada válida quando:

1. cita evidências concretas do dump;
2. separa fato, inferência e risco;
3. não afirma padrões inexistentes;
4. mapeia múltiplos estilos quando eles coexistem;
5. classifica maturidade arquitetural com justificativa;
6. identifica procedimentos master, dispatcher, orquestradores e executores;
7. identifica eventos, logs, auditoria e estado;
8. diferencia problemas reais de preferências arquiteturais;
9. recomenda evolução sem propor rewrite sem necessidade;
10. lista lacunas e contraevidências.

---

# Resultado esperado

O resultado da auditoria deve permitir responder com segurança:

* existe dispatcher central?
* existe orquestrador?
* existem executores especializados?
* existe uma espinha dorsal de SPs master?
* existe API Gateway interno em SQL?
* existe separação entre entrada, decisão e execução?
* existe event store único ou logs fragmentados?
* existe state machine global ou estado distribuído?
* existe fluxo único ou múltiplos fluxos paralelos?
* qual é o nível real de maturidade arquitetural?

---

# Relação com documentos canônicos

Este documento complementa:

* BANCO_FONTE_DA_VERDADE_CANONICO.md
* ARQUITETURA_SP_FIRST_CANONICA.md
* EVENTOS_E_WORKFLOW_CANONICO.md
* MODELO_DOMINIO_CANONICO.md
* SEGURANCA_E_IDENTIDADE_CANONICO.md
* WORKFLOW_CANONICO.md
* DICIONARIO_CANONICO_DE_DADOS.md
