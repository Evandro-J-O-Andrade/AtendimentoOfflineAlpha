# MD-CANONICO-IA-004 — Matriz de Evolução do Projeto

## Status

```text
CANÔNICO
OBRIGATÓRIO
FREEZE 2
```

---

# Objetivo

Definir o ciclo oficial de evolução do FCA/Midas Enterprise.

Cada descoberta, cada proposta, cada alteração deve passar por este ciclo.

Não há atalhos.

Não há exceções.

---

# Ciclo de Evolução Canônico

```text
DESCOBERTA
↓
ANÁLISE
↓
CLASSIFICAÇÃO
↓
GENERALIZAÇÃO
↓
VALIDAÇÃO
↓
ATUALIZAÇÃO DOS MDs
↓
ATUALIZAÇÃO DOS MAPs
↓
ATUALIZAÇÃO DOS BRs
↓
ATUALIZAÇÃO DOS FRONTs
↓
IMPLEMENTAÇÃO
↓
AUDITORIA
↓
FREEZE
```

Cada fase tem regras, critérios de saída e responsáveis.

Nenhuma fase pode ser pulada.

---

# Fase 1 — Descoberta

## O que é

Identificação de objeto, comportamento, regra ou padrão no legado ou no código.

## O que faz

```text
Analisa dump SQL.
Analisa código fonte.
Analisa procedures.
Analisa views, functions, eventos.
Analisa frontend existente.
Analisa integrações.
Analisa N8N workflows.
Analisa logs e auditorias.
```

## Critérios de entrada

```text
Qualquer informação nova sobre a plataforma.
Qualquer objeto não classificado.
Qualquer proposta de nova funcionalidade.
Qualquer divergência entre documentação e implementação.
```

## Critérios de saída

```text
Objeto identificado e nomeado.
Propósito documentado.
Origem registrada (dump / código / proposta).
Pronto para Análise.
```

## Regras

```text
❌ Não classificar nesta fase.
❌ Não alterar documento nesta fase.
✅ Apenas descobrir e registrar.
✅ Registrar evidência de origem.
```

---

# Fase 2 — Análise

## O que é

Aplicação da Lei da Responsabilidade Arquitetural.

## O que faz

Aplica as 4 perguntas obrigatórias do MD-CANONICO-IA-002:

```text
1. Responsabilidade ou Implementação?
2. Reutilizável ou Específico?
3. Core ou Aplicação?
4. Regra Arquitetural ou Decisão de Implementação?
```

## Critérios de entrada

```text
Objeto descoberto e nomeado.
```

## Critérios de saída

```text
Classificação definida: CORE / INFRA / PLATFORM / APP / INTEGRAÇÃO / LEGACY.
Papel arquitetural identificado.
Contratos identificados.
Dependências mapeadas.
Pronto para Classificação.
```

## Regras

```text
❌ Não promover automaticamente ao Core.
❌ Não copiar estrutura legada.
✅ Sempre aplicar síntese arquitetural.
✅ Sempre classificar conforme Regra 14 do MD-CANONICO-IA-001.
```

---

# Fase 3 — Classificação

## O que é

Atribuição formal do objeto a um domínio da plataforma.

## O que faz

```text
Aplica classificação de maturidade (RASCUNHO → CONSOLIDADO).
Atribui ao domínio: CORE / INFRA / PLATFORM / APP / INTEGRAÇÃO / LEGACY.
Registra no Radar de Arquitetura.
Atualiza Knowledge Graph.
```

## Critérios de entrada

```text
Objeto analisado e classificado.
```

## Critérios de saída

```text
Classificação formal registrada.
Domínio definido.
Maturidade definida.
Knowledge Graph atualizado.
Pronto para Generalização.
```

## Regras

```text
❌ Não atribuir APP ao CORE.
❌ Não atribuir implementação a arquitetura.
✅ Todo objeto deve ter exatamente uma classificação.
✅ Todo objeto deve ser registrado no Radar.
```

---

# Fase 4 — Generalização

## O que é

Transformar a descoberta em arquitetura canônica.

Não copiar.

Sintetizar.

## O que faz

```text
Extrai o papel arquitetural, não a estrutura concreta.
Responde: "Qual é a responsabilidade genérica?"
Reconstrói no padrão Enterprise.
Gera documento canônico (MD, MAP, BR, FRONT) ou atualiza existente.
Gera ADR se decisão arquitetural.
```

## Critérios de entrada

```text
Objeto classificado.
Domínio definido.
```

## Critérios de saída

```text
Documento canônico criado ou atualizado.
ADR criado (se decisão arquitetural).
Knowledge Graph atualizado.
Pronto para Validação.
```

## Regras

```text
❌ Não transcrever estrutura legada.
❌ Não criar V2 de documento existente.
❌ Não resumir documento existente.
✅ Sempre sintetizar.
✅ Sempre atualizar documento existente quando houver equivalente.
✅ Sempre registrar decisão em ADR.
```

---

# Fase 5 — Validação

## O que é

Confrontar a arquitetura com evidências.

## O que faz

```text
Compara documento com dump SQL.
Compara documento com código fonte.
Compara documento com frontend.
Valida consistência com Leis Canônicas.
Valida consistência com outros documentos canônicos.
Atualiza maturidade do documento.
```

## Critérios de entrada

```text
Documento canônico criado ou atualizado.
```

## Critérios de saída

```text
Documento validado em pelo menos uma dimensão.
Maturidade atualizada.
Evidências registradas.
Pronto para Atualização dos MDs.
```

## Regras

```text
❌ Não declarar CONSOLIDADO sem validação.
❌ Não validar apenas uma dimensão e considerar completo.
✅ Validar contra dump quando disponível.
✅ Validar contra código quando disponível.
✅ Validar contra front quando disponível.
```

Níveis de validação:

```text
VALIDADO PELO DUMP       → Confrontado com banco legado
VALIDADO PELO CÓDIGO     → Confrontado com implementação
VALIDADO PELO FRONT      → Confrontado com interface
CONSOLIDADO              → Validado em todas as dimensões disponíveis
```

---

# Fase 6 — Atualização dos MDs

## O que é

Atualizar os Documentos Arquiteturais canônicos.

## O que faz

```text
Identifica MDs relacionados ao objeto.
Atualiza cada MD afetado.
Nunca resumir — sempre expandir.
Registra mudança no histórico do documento.
Atualiza maturidade.
Atualiza Knowledge Graph.
```

## Critérios de entrada

```text
Documento validado na Fase 5.
```

## Critérios de saída

```text
Todos os MDs afetados atualizados.
Maturidade atualizada.
Knowledge Graph atualizado.
Pronto para atualizar MAPs, BRs e FRONTs.
```

## Regras

```text
❌ Não apagar conteúdo existente.
❌ Não resumir.
❌ Não criar V2.
✅ Sempre expandir.
✅ Sempre registrar relacionamentos.
✅ Sempre atualizar maturidade.
```

---

# Fase 7 — Atualização dos MAPs, BRs e FRONTs

## O que é

Atualizar os demais documentos canônicos afetados.

## O que faz

```text
Identifica MAPs afetados → atualiza.
Identifica BRs afetados → atualiza.
Identifica FRONTs afetados → atualiza.
Em cada documento:
  - Atualiza relacionamentos.
  - Expande conteúdo.
  - Atualiza maturidade.
  - Atualiza Knowledge Graph.
```

## Critérios de entrada

```text
MDs atualizados na Fase 6.
```

## Critérios de saída

```text
Todos os documentos canônicos afetados atualizados.
Knowledge Graph completo.
Pronto para Implementação.
```

## Regras

```text
Mesmas regras da Fase 6.
❌ Nunca criar novo documento quando existente pode ser atualizado.
✅ Sempre verificar FREEZE antes de alterar.
```

---

# Fase 8 — Implementação

## O que é

Aplicar a arquitetura no código, banco e frontend.

## O que faz

```text
Implementa SPs no padrão canônico.
Implementa Backend (Controller → Service → Dispatcher → SP).
Implementa Frontend (Design System + Shell).
Implementa Workflows (N8N).
Implementa Eventos (Event Store).
Implementa Auditoria.
```

## Critérios de entrada

```text
Arquitetura documentada e validada.
ADRs aprovados.
```

## Critérios de saída

```text
Implementação concluída.
Testes de arquitetura passando.
Auditoria inicial registrada.
Pronto para Auditoria.
```

## Regras

```text
❌ Não implementar sem documentação canônica.
❌ Não implementar regra de negócio fora de SP.
❌ Não acessar banco diretamente.
✅ Sempre respeitar a espinha dorsal canônica.
✅ Sempre emitir eventos canônicos.
✅ Sempre registrar auditoria.
```

---

# Fase 9 — Auditoria

## O que é

Verificação formal de conformidade arquitetônica.

## O que faz

```text
Verifica conformidade com Leis Canônicas.
Verifica conformidade com MDs, MAPs, BRs, FRONTs.
Verifica conformidade com ADRs.
Verifica se implementação corresponde à arquitetura documentada.
Registra divergências encontradas.
Atualiza maturidade dos documentos.
Atualiza Radar de Arquitetura.
```

## Critérios de entrada

```text
Implementação concluída.
```

## Critérios de saída

```text
Auditoria aprovada.
Divergências documentadas e corrigidas.
Maturidade atualizada.
Radar atualizado.
Pronto para Freeze.
```

## Regras

```text
❌ Não aprovar com divergências não registradas.
❌ Não atualizar Radar sem critério.
✅ Toda divergência gera documento de correção.
✅ Auditoria é obrigatória antes do Freeze.
```

---

# Fase 10 — Freeze

## O que é

Consolidação formal da evolução.

## O que faz

```text
Aplica FREEZE ao documento canônico.
Registra ciclo concluído.
Atualiza README_CANONICO.md.
Atualiza Radar de Arquitetura.
Arquiva ciclo em log de evolução.
```

## Critérios de entrada

```text
Auditoria aprovada.
```

## Critérios de saída

```text
Documento em FREEZE.
Ciclo registrado.
Próximo ciclo pode iniciar.
```

## Regras

```text
❌ Não fazer Freeze sem auditoria.
❌ Não fazer Freeze sem documentação completa.
❌ Não alterar documento FREEZE sem processo formal.
✅ Freeze é o estado natural da arquitetura consolidada.
✅ Todo ciclo fechado alimenta o histórico do projeto.
```

---

# Ciclos Paralelos

Nem toda descoberta precisa passar por todas as fases simultaneamente.

## Ciclo Rápido

```text
Descoberta → Análise → Classificação → Fortalecer documento existente
```

Para descobertas que apenas expandem documentos existentes.

## Ciclo Completo

```text
Descoberta → Análise → Classificação → Generalização → Validação
→ MDs → MAPs/BRs/FRONTs → Implementação → Auditoria → Freeze
```

Para novas funcionalidades ou alterações arquiteturais.

## Ciclo de Correção

```text
Descoberta (divergência) → Análise → Classificação
→ Correção da implementação → Auditoria → Freeze
```

Para correções de conformidade.

---

# Métricas de Evolução

## Ciclos por Mês

```text
Quantos ciclos foram concluídos?
Quantos ciclos estão em andamento?
Quantos ciclos estão bloqueados?
```

## Documentos por Maturidade

```text
RASCUNHO:      X
EM EVOLUÇÃO:   X
CANÔNICO:      X
FREEZE:        X
AUDITADO:      X
VALIDADO DUMP: X
VALIDADO COD:  X
VALIDADO FRONT:X
CONSOLIDADO:   X
```

## Radar por Domínio

```text
Atualizado após cada ciclo concluído.
Mostra evolução visual da plataforma.
```

---

# Integrações

| Documento | Finalidade |
|-----------|------------|
| MD-CANONICO-IA-001 | Lei de Evolução Documental |
| MD-CANONICO-IA-002 | Lei de Governança Arquitetural |
| MD-CANONICO-IA-003 | Lei da Evolução do Core |
| MD-110 — Canonical Laws | Leis supremas da plataforma |
| LC-001 → LC-018 | Leis Canônicas Globais |
| MD-001 até MD-110 | Arquitetura do Core |
| MAP-001 → MAP-* | Mapas de domínio |
| BR-001 → BR-* | Regras de negócio |
| FRONT-001 → FRONT-* | Experiência frontend |
| ADR-001 → ADR-* | Decisões arquiteturais |
| RADAR-ARQUITETURA.md | Visibilidade de maturidade |

---

# Matriz de Aplicação

| IA | Aplicação |
|----|-----------|
| Gemini | Obrigatória em todo ciclo de evolução |
| KiloCode | Obrigatória em todo ciclo de evolução |
| ChatGPT | Obrigatória em todo ciclo de evolução |
| Claude | Obrigatória em todo ciclo de evolução |
| Copilot | Obrigatória em sugestões de evolução |

---

# Status Final

```text
MD-CANONICO-IA-004: ✅ CANONIZADA
APLICAÇÃO: Obrigatória para todas as IAs do projeto
ESCOPO: Ciclo oficial de evolução do FCA/Midas Enterprise
VERSÃO: 1.0
```

---

Documento Canônico — MD-CANONICO-IA-004

**Esta lei formaliza o ciclo de evolução do FCA/Midas Enterprise.**
