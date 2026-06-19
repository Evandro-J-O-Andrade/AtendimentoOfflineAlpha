# DIVERGENCIAS_CONHECIDAS.md

## Status

Documento de auditoria documental.

Este registro centraliza divergências conhecidas entre o estado real do repositório, o README principal e a documentação canônica.

Data do registro: 2026-06-19.

## Propósito

Preservar visibilidade sobre inconsistências documentais e arquiteturais sem quebrar o Freeze Arquitetural 2026.

Este documento não aprova mudanças de código. Ele apenas registra fatos observados para decisão posterior por arquitetura e governança.

## Divergência 1 — Event store fragmentado versus event store canônico

### Estado real

`docs/canonical/MD6_eventos_atual.md` registra eventos fragmentados em domínios distintos.

Exemplos citados:

- `atendimento_evento`
- `senha_eventos`
- `estoque_audit_stream`
- `fila_operacional_evento`

### Estado canônico

`docs/canonical/MD9_event_store.md` define o alvo `kernel_event_store`.

`docs/canonical/ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md:156-171` declara que a plataforma possui um único motor canônico de eventos e proíbe motores paralelos.

### Risco

Múltiplas fontes de verdade dificultam replay, auditoria global, BI centralizado e reconstrução temporal.

### Tratamento seguro durante o freeze

Nenhuma alteração de banco. Manter o registro documental e planejar migração por dupla escrita quando o freeze for liberado.

## Divergência 2 — API Layer híbrida no MD1 antigo

### Estado real anterior

`docs/canonical/MD1_arquitetura_canonica.md` citava `API Layer Node/PHP`.

### Correção aplicada

O MD1 foi alinhado com `docs/canonical/ARQUITETURA_SP_FIRST_CANONICA.md`, que define o backend como fachada de transporte, autenticação, autorização, contexto e chamada de Stored Procedures.

### Risco

Ambiguidade tecnológica poderia gerar decisões conflitantes entre Node, PHP ou outras camadas de aplicação.

### Tratamento seguro durante o freeze

Documentação corrigida. Nenhuma decisão de runtime deve ser tomada sem atualização do README, estrutura canônica e contrato de backend.

## Divergência 3 — README principal desalinhado do freeze

### Estado real

`README.md` descreve instalação, módulos, roadmap e credenciais de teste com linguagem de projeto em desenvolvimento ativo.

### Estado canônico

`docs/canonical/FREEZE_ARQUITETURAL_2026.md:3-11` declara freeze arquitetural ativo e proíbe novas telas, APIs, tabelas e stored procedures até homologação.

### Correção aplicada

O `README.md` foi atualizado para declarar o Freeze Arquitetural 2026 e apontar `docs/canonical/` como fonte oficial de arquitetura.

### Risco

Desenvolvedores podem tratar o README como autoridade arquitetural em vez dos documentos canônicos.

### Tratamento seguro durante o freeze

Manter o README como porta de entrada de alto nível e redirecionar decisões arquiteturais para `docs/canonical/`.

## Divergência 4 — MDs MD1-MD12 fora do índice canônico

### Estado real anterior

`docs/canonical/FREEZE_ARQUITETURAL_2026.md` e `docs/canonical/README_CANONICO.md` listavam 30 documentos canônicos, sem incluir os MDs MD1-MD12.

### Correção aplicada

Os MDs MD1-MD12 foram matriculados em:

- `docs/canonical/README_CANONICO.md`
- `docs/canonical/FREEZE_ARQUITETURAL_2026.md`
- `docs/canonical/PLANO_DIRETOR_DA_DOCUMENTACAO_CANONICA.md`

### Risco

Os MDs poderiam ser tratados como rascunhos ou documentos auxiliares, apesar de definirem leis arquiteturais críticas.

### Tratamento seguro durante o freeze

Os MDs agora constam como documentos canônicos. Alterações futuras devem seguir governança documental.

## Divergência 5 — Documento de auditoria do banco fora do índice do freeze

### Estado real anterior

`docs/canonical/AUDITORIA_ARQUITETURA_BANCO_SP_MASTER_CANONICA.md` era um documento canônico, mas não constava na tabela do freeze.

### Correção aplicada

O documento foi incluído em:

- `docs/canonical/README_CANONICO.md`
- `docs/canonical/FREEZE_ARQUITETURAL_2026.md`
- `docs/canonical/PLANO_DIRETOR_DA_DOCUMENTACAO_CANONICA.md`

### Risco

Auditoria do banco poderia ser desconsiderada em decisões de arquitetura.

### Tratamento seguro durante o freeze

Manter o documento como referência de auditoria e evidência técnica.

## Divergência 6 — Estrutura real com artefatos órfãos

### Estado real

Auditorias em `docs/auditoria/ESTRUTURA_FINAL_ALVO.md` e `docs/auditoria/RELATORIO_INVENTARIO_REAL.md` apontam artefatos órfãos, duplicatas e diretórios inconsistentes.

### Estado canônico

`docs/canonical/ESTRUTURA_ENTERPRISE_CANONICA_NEW_WAVE_SAAS.md` define a estrutura alvo da Plataforma New Wave SaaS.

### Risco

Desenvolvimento ou recuperação de artefatos pode reintroduzir código não homologado.

### Tratamento seguro durante o freeze

Nenhuma recuperação de código. Manter auditoria documental e planejar homologação pós-freeze.

## Divergência 7 — Diagramas e nomenclatura de banco

### Estado real

Diagramas em `docs/diagrams/` utilizam entidades e nomenclaturas que nem sempre seguem a ontologia canônica.

Exemplos de tensão:

- tabelas em maiúsculas versus convenção lowercase com underscore
- `ATENDIMENTO` versus sequência canônica `Pessoa -> Senha -> FFA -> GPAT`
- campos de contexto local não alinhados ao modelo `contexto_operacional`

### Estado canônico

`docs/canonical/BANCO_FONTE_DA_VERDADE_CANONICO.md` define convenções de banco e fonte da verdade.

`docs/canonical/MODELO_DOMINIO_CANONICO.md` define a ontologia de domínio.

### Risco

Diagramas desalinhados podem orientar decisões de schema ou procedures em direção ao legado.

### Tratamento seguro durante o freeze

Nenhuma alteração de schema. Atualizar diagramas apenas como documentação, se aprovado por governança.

## Divergência 8 — Contrato de API documentado versus rotas reais

### Estado real

`docs/canonical/BACKEND_CANONICO.md` apresenta contratos como `/api/auth/login`, `/api/portal/aplicacoes`, `/api/contexto/selecionar` e `/api/eventos`.

Auditorias em `docs/auditoria/MAPA_APIS.md`, `docs/auditoria/MAPA_BACKEND.md` e `docs/auditoria/RELATORIO_DEPENDENCIAS.md` registram rotas reais como `dispatcherRoutes.js`, `filaRoutes.js`, `totemRoutes.js` e `spRoutes.js`.

### Risco

Contratos documentados podem não refletir a superfície atual da API.

### Tratamento seguro durante o freeze

Nenhuma nova rota. Registrar divergência e alinhar contrato com inventário real antes de retomar desenvolvimento.

## Regra de uso

Este documento deve ser consultado antes de qualquer retomada de desenvolvimento, recuperação de artefatos, alteração de schema ou criação de novas stored procedures.

Qualquer ação corretiva deve ser aprovada por:

- arquitetura
- governança
- responsável técnico do domínio afetado

## Status de resolução

Nenhuma divergência listada aqui deve ser considerada resolvida por este registro.

A resolução exige uma das ações abaixo, conforme aplicável:

- atualização documental aprovada
- homologação de artefato legado
- migração planejada
- alteração de schema aprovada
- criação ou alteração de stored procedure aprovada
