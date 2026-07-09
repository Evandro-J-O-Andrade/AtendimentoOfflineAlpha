# MD-CANONICO-IA-002 — Lei de Governança Arquitetural

## Status

```text
CANÔNICO
OBRIGATÓRIO
FREEZE 2
```

---

# Objetivo

Transformar a arquitetura do FCA/Midas em um sistema de governança vivo.

Esta lei complementa a MD-CANONICO-IA-001, que rege a evolução documental.

O foco aqui é a governança das decisões arquiteturais:

Quando uma descoberta vira Core?

Quando continua Legacy?

Quando vira APP?

Quando merece documento novo?

Quando apenas fortalece um documento existente?

Nenhuma dessas decisões ficará mais implícita.

---

# Relacionamento com outras leis

```text
000-CONSTITUICAO-IA       → Constituição operacional das IAs
        ↓
MD-CANONICO-IA-001        → Lei de Evolução Documental
        ↓
MD-CANONICO-IA-002        → Lei de Governança Arquitetural (este documento)
        ↓
MD-110                    → Leis Supremas da Plataforma
        ↓
LC-001 → LC-018           → Leis Canônicas Globais
        ↓
MDs, MAPs, BRs, FRONTs    → Arquitetura implementada
        ↓
Banco Enterprise          → Implementação canônica
        ↓
Dump Legado + Código      → Evidência e referência
```

Nenhuma camada inferior altera uma camada superior.

---

# Matriz de Autoridade

```text
Lei Canônica (MD-CANONICO-IA-*)
  └── Prevalece sobre tudo
  └── Nenhuma implementação pode contradizer

Leis Supremas (MD-110)
  └── Prevalece sobre MDs, MAPs, BRs, FRONTs
  └── Conflito → parar, documentar, propor solução

Leis Globais (LC-001 → LC-018)
  └── Integram MD-110
  └── Específicas por domínio

MAP / BR / FRONT
  └── Implementam as Leis
  └── Não podem contradizer o nível superior

Banco Enterprise
  └── Implementa a arquitetura
  └── Não define arquitetura

Dump Legado + Código
  └── Fonte de evidência
  └── Nunca fonte de decisão arquitetural
```

---

# Classificação de Maturidade Documental

Todo documento canônico deve declarar explicitamente sua maturidade.

```text
STATUS: RASCUNHO
STATUS: EM EVOLUÇÃO
STATUS: CANÔNICO
STATUS: FREEZE
STATUS: AUDITADO
STATUS: VALIDADO PELO DUMP
STATUS: VALIDADO PELO CÓDIGO
STATUS: VALIDADO PELO FRONT
STATUS: CONSOLIDADO
```

## RASCUNHO

Documento em formação.

Pode ser alterado livremente.

Ainda não é referência arquitetural.

## EM EVOLUÇÃO

Documento ativo em construção.

Pode ser expandido.

Não pode ser resumido.

Conteúdo pode mudar até estabilizar.

## CANÔNICO

Documento consolidado.

Define regra arquitetural.

Alterações apenas mediante análise.

## FREEZE

Documento congelado.

Somente mediante autorização explícita.

Processo formal de alteração.

## AUDITADO

Documento revisado por auditoria arquitetônica.

Conteúdo validado internamente.

## VALIDADO PELO DUMP

Documento confrontado com o legado.

Evidências do banco corroboram o documento.

## VALIDADO PELO CÓDIGO

Documento confrontado com implementação atual.

Código existente corrobora o documento.

## VALIDADO PELO FRONT

Documento confrontado com interface existente.

Comportamento do front corrobora o documento.

## CONSOLIDADO

Documento validado em todas as dimensões.

Referência máxima.

Alteração exige processo formal completo.

---

# Lei da Responsabilidade Arquitetural

Toda descoberta deve responder quatro perguntas obrigatórias.

Nenhum objeto do legado é promovido ao Core sem passar por esse interrogatório.

---

## Pergunta 1 — Responsabilidade ou Implementação?

```text
É uma RESPONSABILIDADE arquitetural?
ou
É apenas IMPLEMENTAÇÃO de uma responsabilidade?
```

Exemplos:

```text
"Orquestrar fluxo de atendimento"
  → RESPONSABILIDADE

"Usar cursor para percorrer tabela temporária"
  → IMPLEMENTAÇÃO

"Gerenciar contexto operacional"
  → RESPONSABILIDADE

"Declarar variável @id INT"
  → IMPLEMENTAÇÃO
```

Regra:

```text
Responsabilidades vão para arquitetura.
Implementações ficam no código.
```

---

## Pergunta 2 — Reutilizável ou Específico?

```text
É REUTILIZÁVEL em múltiplas aplicações da plataforma?
ou
É ESPECÍFICO do HIS?
```

Exemplos:

```text
"Autenticar usuário"
  → REUTILIZÁVEL → CORE (IAM)

"Calcular score Manchester"
  → ESPECÍFICO do HIS → APP

"Emitir evento de auditoria"
  → REUTILIZÁVEL → CORE (Event Store)

"Formatar prontuário médico"
  → ESPECÍFICO do HIS → APP
```

Regra:

```text
Reutilizável → CORE / PLATFORM
Específico → APP
```

---

## Pergunta 3 — Core ou Aplicação?

```text
Pertence ao CORE da plataforma?
ou
Pertence a uma APLICAÇÃO específica?
```

Exemplos:

```text
Pessoa           → CORE
Tenant           → CORE
Workflow         → CORE
Ledger           → CORE
Event Store      → CORE
Dispatcher       → CORE
Portal           → PLATFORM

Senha            → APP HIS
Triagem          → APP HIS
Internação       → APP HIS
Prescrição       → APP HIS
Faturamento      → APP HIS
CRM Lead         → APP CRM
Escala           → APP RH
```

Regra:

```text
Core nunca nasce do legado.
Core é descoberto e formalizado.
```

---

## Pergunta 4 — Regra Arquitetural ou Decisão de Implementação?

```text
É uma REGRA ARQUITETURAL?
ou
É uma DECISÃO DE IMPLEMENTAÇÃO?
```

Exemplos:

```text
"Toda escrita passa por SP"
  → REGRA ARQUITETURAL

"Usar VARCHAR(255) para nome"
  → DECISÃO DE IMPLEMENTAÇÃO

"Multi-tenant por id_tenant"
  → REGRA ARQUITETURAL

"Incluir índice em tabela X"
  → DECISÃO DE IMPLEMENTAÇÃO
```

Regra:

```text
Regras arquiteturais → arquitetura.
Decisões de implementação → código.
```

---

# Classificação de Promoção

Após responder às 4 perguntas, a descoberta recebe uma classificação de promoção.

## CORE

Componente fundamental da plataforma.

Reutilizável por qualquer aplicação.

Exemplos: Pessoa, Tenant, IAM, Portal, Workflow, Ledger, Event Store, Runtime.

## INFRA

Infraestrutura técnica.

Suporta o Core e as Apps.

Exemplos: filas, jobs, sync engine, runtime_execution_queue, caches.

## PLATFORM

Serviços transversais da plataforma.

Componentes que servem a múltiplas aplicações.

Exemplos: Design System, App Registry, API Gateway, Dispatcher.

## APP

Aplicação específica de um domínio.

Não reutilizável fora do seu contexto.

Exemplos: Triagem, Internação, Prescrição, CRM, RH.

## LEGACY

Objeto do legado ainda em análise.

Ainda não classificado ou aguardando validação.

Todo objeto legado começa como LEGACY.

Só sai de LEGACY após passar pela Lei da Responsabilidade Arquitetural.

---

# Regra do Knowledge Graph

Todo documento canônico deve declarar seus relacionamentos.

Documentos deixam de ser arquivos isolados.

Passam a formar um grafo de conhecimento navegável.

## Estrutura de Relacionamento

Cada documento deve conter uma seção:

```text
## Relacionamentos

### Depende de
- MD-005 (Dispatcher)
- MAP-002 (Event Architecture)

### Relacionado com
- BR-003 (HIS Clinical Rules)
- FRONT-007 (Triagem Experience)
- DB tabela senha
- SP sp_dispatcher_execute

### Usado por
- MAP-004 (Atendimento Flow)
- FRONT-011 (Atendimento Interface)
- Workflow Atendimento
```

## Relacionamentos Obrigatórios

| Tipo | Descrição |
|------|-----------|
| Depende de | Documentos que este documento referencia |
| Relacionado com | Documentos, tabelas, SPs, workflows relacionados |
| Usado por | Documentos, apps, workflows que consomem este documento |
| Estende | Documentos que este documento complementa |
| Substitui | Documentos que este documento torna obsoleto (somente com autorização) |

---

# Regra de Promoção de Documentos

## Quando criar MAP novo?

Somente quando:

- o domínio ainda não existir na arquitetura;
- o domínio não puder ser absorvido por um MAP existente;
- o domínio representar uma capacidade nova da plataforma.

Caso contrário:

```text
Atualizar MAP existente.
```

## Quando criar BR novo?

Somente quando:

- a regra de negócio não estiver coberta por nenhum BR existente;
- a regra pertencer a um domínio novo;
- a regra representar uma decisão arquitetônica nova.

Caso contrário:

```text
Atualizar BR existente.
```

## Quando criar FRONT novo?

Somente quando:

- a experiência não estiver documentada em nenhum FRONT existente;
- a experiência corresponder a uma aplicação nova;
- a experiência representar um padrão visual novo da plataforma.

Caso contário:

```text
Atualizar FRONT existente.
```

---

# Regra da Síntese Contínua

Todo documento canônico deve ser revisado periodicamente contra:

```text
Dump SQL atualizado
↓
Código fonte atualizado
↓
Frontend atualizado
↓
Novas descobertas do legado
↓
Novas evidências arquiteturais
```

Fluxo de atualização:

```text
Documento atual
↓
Comparar com nova evidência
↓
Existe informação nova relevante?
↓
SIM
↓
Fortalecer documento
↓
NÃO
↓
Manter como está
```

Nunca substituir.

Nunca resumir.

Sempre enriquecer.

---

# Fluxo de Governança para qualquer IA

```text
Ler 000-CONSTITUICAO-IA.md
↓
Ler MD-CANONICO-IA-001 (Lei de Evolução Documental)
↓
Ler MD-CANONICO-IA-002 (este documento)
↓
Ler Leis Canônicas (MD-110, LC-001-LC-018)
↓
Ler MD-CANONICO-IA-007 (Banco Fonte da Verdade + Knowledge Graph Vivo)
↓
Ler MAPs existentes do domínio
↓
Ler BRs existentes do domínio
↓
Ler FRONTs existentes do domínio
↓
Analisar nova descoberta
↓
Aplicar Lei da Responsabilidade Arquitetural (4 perguntas)
↓
Classificar: CORE / INFRA / PLATFORM / APP / LEGACY
↓
Consultar Knowledge Graph (relacionamentos)
↓
Aplicar Regra do Gap: existe? falta? atualizar? criar?
↓
Aplicar Regra do Documento Vivo: existe? atualiza? fortalece? cria?
↓
Verificar FREEZE do documento alvo
↓
Atualizar ou criar conforme regras
↓
Atualizar Knowledge Graph do documento
↓
Registrar maturidade atualizada
```

---

# Regras de Proibição

```text
❌ Promover objeto LEGACY para CORE sem passar pela Lei da Responsabilidade
❌ Criar documento novo quando documento equivalente existe
❌ Remover decisão canônica
❌ Submeter documento a downgrade de FREEZE
❌ Contradizer documento de nível superior
❌ Criar conhecimento isolado (sem relacionamentos)
❌ Promover implementação a arquitetura
❌ Copiar estrutura legada para o Core
```

---

# Integrações

| Documento | Finalidade |
|-----------|------------|
| 000-CONSTITUICAO-IA.md | Constituição operacional das IAs |
| MD-CANONICO-IA-001 | Lei de Evolução Documental |
| MD-CANONICO-IA-007 | Lei do Banco Fonte da Verdade + Knowledge Graph Vivo |
| MD-110 — Canonical Laws | Leis supremas da plataforma |
| LC-001 → LC-018 | Leis Canônicas Globais |
| MD-001 até MD-110 | Documentos arquiteturais complementares |
| MAP-001 → MAP-020 | Mapas de domínio |
| BR-001 → BR-* | Regras de negócio |
| FRONT-001 → FRONT-* | Arquitetura frontend |
| docs/PLANO_DIRETOR_DA_DOCUMENTACAO_CANONICA.md | Diretrizes de documentação |

---

# Matriz de Aplicação

| IA | Aplicação |
|----|-----------|
| Gemini | Obrigatória em todas as tarefas de governança arquitetural |
| KiloCode | Obrigatória em todas as tarefas de governança arquitetural |
| ChatGPT | Obrigatória em todas as tarefas de governança arquitetural |
| Claude | Obrigatória em todas as tarefas de governança arquitetural |
| Copilot | Obrigatória em sugestões de arquitetura e documentação |

---

# Status Final

```text
MD-CANONICO-IA-002: ✅ CANONIZADA
APLICAÇÃO: Obrigatória para todas as IAs do projeto
ESCOPO: Toda governança arquitetural — MD, MAP, BR, FRONT
VERSÃO: 1.0
```

---

Documento Canônico — MD-CANONICO-IA-002

**Esta lei governa a governança arquitetural do projeto FCA/Midas Enterprise.**
