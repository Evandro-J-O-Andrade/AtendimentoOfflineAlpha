# MD-CANONICO-IA-001 — Lei Canônica de Evolução Documental

## Status

```text
CANÔNICO
OBRIGATÓRIO
FREEZE
```

---

# Objetivo

Toda IA que trabalhar no projeto FCA/Midas Enterprise deve considerar que o projeto possui documentação canônica em evolução.

O objetivo da IA não é recriar a arquitetura.

O objetivo é expandir, fortalecer e consolidar a arquitetura existente.

---

# Hierarquia Canônica dos Documentos

A ordem de precedência é obrigatória.

```text
000-CONSTITUICAO-IA
↓
Leis Canônicas (MD)
↓
Arquitetura (MAP)
↓
Regras de Negócio (BR)
↓
Experiência (FRONT)
↓
Banco Enterprise
↓
Dump Legado
↓
Código Fonte
```

Nunca inverter essa ordem.

Documentos de nível superior prevalecem sobre documentos de nível inferior.

---

# FREEZE — Níveis de Congelamento

Todo documento canônico possui um nível de FREEZE.

## FREEZE 0

```text
Pode alterar livremente.
Documento em construção, sem status consolidado.
```

## FREEZE 1

```text
Pode expandir.
Não pode remover conteúdo.
Exemplo: adicionar seções, exemplos, detalhes.
```

## FREEZE 2

```text
Somente mediante autorização.
Alterações mínimas documentadas.
Requer aprovação arquitetônica.
```

## FREEZE 3

```text
Imutável.
Nenhuma alteração permitida sem processo formal.
Qualquer mudança exige novo documento de alteração canônica.
```

A IA deve consultar o FREEZE do documento antes de qualquer modificação.

---

# Regra 1

Nunca apagar documentação existente.

Se existir:

```text
MAP-001
```

Ela nunca deve ser recriada.

Ela deve ser:

* enriquecida
* expandida
* detalhada
* corrigida

---

# Regra 2

Nunca criar uma segunda versão.

Errado:

```text
MAP-001-v2
MAP-001-NOVO
MAP-001-REVISADO
MAP-001-FINAL
```

Correto — atualizar:

```text
MAP-001.md
```

mantendo o mesmo arquivo.

---

# Regra 3

Nunca resumir.

Sempre adicionar informação.

A documentação cresce.

Nunca diminui.

---

# Regra 4

Nunca remover decisões canônicas.

Pode adicionar.

Pode complementar.

Pode melhorar.

Mas nunca substituir uma decisão arquitetural sem autorização explícita.

---

# Regra 5

Se existir conflito:

A IA deve:

```text
PARAR

documentar o conflito

propor solução

não modificar automaticamente.
```

---

# Regra 6

Nunca gerar versões paralelas.

Errado:

```text
Novo FRONT
Novo MAP
Novo BR
Nova Lei
```

Correto:

```text
Atualizar o existente.
```

---

# Regra 7

Antes de criar qualquer documento novo verificar:

Existe um documento equivalente?

Se existir:

```text
Atualizar.
```

Se não existir:

```text
Criar.
```

---

# Regra 8

A documentação deve crescer em profundidade.

Nunca em quantidade desnecessária.

Exemplo — Errado:

```text
20 documentos falando do Portal.
```

Exemplo — Correto:

```text
1 documento extremamente completo.
```

---

# Regra 9 — Regra da Espinha Dorsal

Todo documento ou alteração deve respeitar a sequência canônica da plataforma.

Nada pode quebrar essa sequência:

```text
Pessoa
↓
IAM
↓
Portal
↓
Aplicação
↓
Contexto
↓
Dashboard
↓
Workflow
↓
Dispatcher
↓
Orquestrador
↓
Executor
↓
Ledger
↓
Event Store
↓
Auditoria
```

Essa é a espinha dorsal da plataforma.

---

# Regra 10

Nenhuma documentação pode contrariar as Leis Canônicas.

Se o código fizer diferente da Lei:

A documentação segue a Lei.

O código será corrigido futuramente.

---

# Regra 11

O Dump SQL representa o legado.

O legado serve para:

* descobrir regras de negócio
* descobrir fluxos
* descobrir padrões

Nunca para copiar arquitetura antiga.

---

# Regra 12

Sempre transformar descoberta em arquitetura Enterprise.

Exemplo — Legado:

```text
sp_master_dispatcher
```

não significa manter isso.

A IA deve perguntar:

```text
Qual é o papel arquitetural dessa procedure?
```

Resposta:

```text
Dispatcher Global
```

Então a arquitetura nova pode ser:

```text
Dispatcher Kernel
Dispatcher IAM
Dispatcher Portal
Dispatcher Workflow
Dispatcher Social
Dispatcher Analytics
```

Sem copiar o legado.

---

# Regra 13

Nunca desenvolver pensando no HIS.

Sempre pensar na Plataforma Enterprise.

O HIS é apenas um App.

O Portal é o Sistema.

---

# Regra 14 — Classificação Obrigatória

Toda descoberta deve ser classificada como:

```text
CORE       — Componentes fundamentais da plataforma
INFRA      — Infraestrutura técnica, runtime, filas
PLATFORM   — Serviços transversais da plataforma
APP        — Aplicação específica do tenant
LEGACY     — Objetos legados em processo de análise
```

Exemplo:

| Componente | Classificação |
|------------|---------------|
| Pessoa | CORE |
| Tenant | CORE |
| Portal | PLATFORM |
| Workflow | CORE |
| Ledger | CORE |
| Event Store | CORE |
| runtime_execution_queue | INFRA |
| senha_agendamento | APP HIS |
| triagem_manchester | APP HIS |
| prontuario_eletronico | APP HIS |
| Dump20260606 | LEGACY |

---

# Regra 15 — Engenharia Reversa Arquitetural

Todo objeto legado deve passar por quatro etapas obrigatórias:

```text
Descobrir
↓
Identificar o objeto e seu propósito no legado
↓
Classificar
↓
Aplicar a classificação da Regra 14 (CORE / INFRA / PLATFORM / APP / LEGACY)
↓
Generalizar
↓
Extrair o papel arquitetural, não a estrutura concreta
↓
Implementar
↓
 reconstruir no padrão Enterprise conforme a classificação
```

Não copiar tabelas.

Não copiar procedures.

---

# Regra 16 — Critério para criação de novos documentos

Uma IA só poderá criar um novo MD, MAP, BR ou FRONT quando:

- o assunto ainda não existir;
- não houver documento equivalente;
- a nova funcionalidade representar um domínio novo da plataforma.

Caso contrário, ela deve atualizar o documento existente.

---

# Regra 17 — O Core evolui por síntese, não por cópia

Toda descoberta feita no banco legado, no código-fonte ou em documentos antigos deve passar por um processo de síntese arquitetural.

A IA nunca deve transcrever estruturas antigas diretamente para o Core Enterprise.

Ela deve responder às perguntas:

* Isto pertence ao Core ou a um App?
* Esta responsabilidade é genérica ou específica do HIS?
* Pode servir para qualquer aplicação da plataforma?
* Está alinhado às Leis Canônicas?

Somente após essa análise a informação poderá ser incorporada aos MDs, MAPs, BRs ou FRONTs.

---

# Regra 18 — Regra do Gap

Toda IA deve responder sequentialmente antes de implementar:

```text
O que existe?      → Ler documentação existente
↓
O que falta?        → Identificar lacunas na arquitetura
↓
O que deve ser atualizado? → Encontrar documentos existentes a expandir
↓
O que deve ser criado?    → Somente se não houver documento equivalente
```

Nunca pular direto para implementação.

---

# Regra 19 — Regra do Documento Vivo

Fluxo obrigatório antes de criar qualquer documento:

```text
Existe?
↓
SIM → Atualiza.
↓
Não existe?
↓
Cria.
↓
Existe mas está fraco?
↓
Fortalece.
↓
Existe e está completo?
↓
Apenas consulta.
```

Isso evita inflação de documentos.

---

# Regra 20 — Stored Procedures são implementação, não arquitetura

Nenhuma Stored Procedure representa arquitetura.

Ela representa apenas uma implementação.

A IA deve extrair:

* responsabilidade
* contrato
* eventos
* dependências
* papel arquitetural

e reconstruir no padrão Enterprise.

Exemplo:

```text
sp_master_dispatcher (legado)
↓
Descobrir: orquestra chamadas entre módulos
↓
Classificar: CORE
↓
Generalizar: Dispatcher canônico
↓
Implementar: Dispatcher Kernel (padrão Enterprise)
```

---

# Regra 21 — Regra do Portal

Todo fluxo da plataforma inicia no Portal.

```text
Login
↓
Portal
↓
Aplicação
↓
Contexto
↓
Dashboard
↓
Operação
```

Nenhum módulo operacional é ponto de entrada.

Nenhuma app abre diretamente.

Isso evita que IAs recriem fluxos antigos do HIS com entry points independentes.

---

# Fluxo obrigatório para qualquer IA

```text
Ler 000-CONSTITUICAO-IA.md
↓
Ler MD-CANONICO-IA-001.md (este documento)
↓
Ler Leis Canônicas
↓
Ler MAPs
↓
Ler BRs
↓
Ler FRONTs
↓
Analisar Dump SQL
↓
Comparar Arquitetura
↓
Aplicar Regra do Gap (Regra 18)
↓
Aplicar Regra do Documento Vivo (Regra 19)
↓
Classificar descobertas (Regra 14)
↓
Aplicar Engenharia Reversa (Regra 15)
↓
Atualizar documentos existentes
↓
Criar novos documentos somente quando realmente necessário
```

---

# Integrações

| Documento | Finalidade |
|-----------|------------|
| 000-CONSTITUICAO-IA.md | Constituição das IAs |
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
| Gemini | Obrigatória em todas as tarefas de documentação e código |
| KiloCode | Obrigatória em todas as tarefas de documentação e código |
| ChatGPT | Obrigatória em todas as tarefas de documentação e código |
| Claude | Obrigatória em todas as tarefas de documentação e código |
| Copilot | Obrigatória em sugestões de código e documentação |

---

# Status Final

```text
MD-CANONICO-IA-001: ✅ CANONIZADA
APLICAÇÃO: Obrigatória para todas as IAs do projeto
ESCOPO: Toda documentação MD, MAP, BR, FRONT
VERSÃO: v2.0
```

---

Documento Canônico — MD-CANONICO-IA-001

**Esta lei governa toda evolução documental do projeto FCA/Midas Enterprise.**
