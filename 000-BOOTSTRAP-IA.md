# 000 — BOOTSTRAP IA
## Entrypoint Obrigatório para Toda IA que Entrar no Projeto

## Status
PRIMEIRO ARQUIVO — START HERE
CANÔNICO
IMUTÁVEL

---

## Como Usar Este Arquivo

```text
Se você é uma IA (KiloCode, ChatGPT, Claude, Gemini, Copilot, AVA, outra):

1. Leia este arquivo completamente.
2. Siga o algoritmo BOOTSTRAP exatamente.
3. Somente depois de concluir o bootstrap, execute qualquer tarefa.
```

```text
Se você é humano:
- Use este arquivo para onboardar novas IAs ou desenvolvedores.
- Não altere o algoritmo BOOTSTRAP sem processo de governança.
```

---

## Algoritmo BOOTSTRAP

```
INICIAR
│
├── 1. CARREGAR CONSTITUIÇÃO DA PLATAFORMA
│       Arquivo: 000-CONSTITUICAO-PLATAFORMA.md
│       Ação: Ler completamente. Não pular seções.
│       Validação: Você conhece os 14 Títulos e 66 Artigos?
│
├── 2. CARREGAR CONSTITUIÇÃO DAS IAs
│       Arquivo: 001-CONSTITUICAO-IA.md
│       Ação: Ler completamente. Não pular seções.
│       Validação: Você conhece as 64 Regras e a Lei Final?
│
├── 3. CARREGAR ÍNDICE GERAL
│       Arquivo: 002-INDICE-GERAL.md
│       Ação: Mapear todos os documentos canônicos disponíveis.
│       Validação: Você sabe onde encontrar cada documento?
│
├── 4. CARREGAR GLOSSÁRIO
│       Arquivo: 003-GLOSSARIO.md
│       Ação: Memorizar a linguagem oficial da plataforma.
│       Validação: Você não usará termos improvisados.
│
├── 5. CARREGAR LEIS SUPREMAS
│       Arquivo: docs/canonical/MD-110-Canonical-Laws.md
│       Ação: Ler e internalizar as 22 Leis Supremas.
│       Validação: Você entende a Hierarquia de Verdade?
│
├── 6. CARREGAR ARQUITETURA CONSOLIDADA
│       Arquivo: docs/canonical/MD-100-Unified-Enterprise-Operating-System.md
│       Ação: Ler completamente. Mapear camadas, domínios, fluxos.
│       Validação: Você entende a diferença entre Portal, App, Shell, Dispatcher?
│
├── 7. CARREGAR LEIS DE EVOLUÇÃO DOCUMENTAL
│       Arquivo: docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md
│       Ação: Ler e compreender o ciclo de vida dos documentos.
│
├── 8. CARREGAR LEI DE GOVERNANÇA ARQUITETURAL
│       Arquivo: docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md
│       Ação: Ler e compreender o processo de alteração arquitetural.
│
├── 9. CARREGAR LEI DA EVOLUÇÃO DO CORE
│       Arquivo: docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md
│       Ação: Ler e compreender como o core evolui.
│
├── 10. CARREGAR MATRIZ DE EVOLUÇÃO
│       Arquivo: docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md
│       Ação: Compreender a matriz de evolução do projeto.
│
├── 11. CARREGAR MAPA DE DOMÍNIOS
│       Arquivo: docs/canonical/MAP-001-Enterprise-Domain-Architecture.md
│       Ação: Mapear todos os domínios da plataforma.
│       Validação: Você sabe quais domínios existem e quais são CORE vs APP?
│
├── 12. CARREGAR LIVROS CANÔNICOS (conforme escopo)
│       Diretório: docs/canonical/livros/
│       Ação: Para cada livro relevante à sua tarefa, ler completamente.
│       Regra: Não pular livros. Ler na ordem definida no 002-INDICE-GERAL.md
│
├── 13. CARREGAR MDs, MAPs, BRs, FRONTs, ADRs (conforme escopo)
│       Diretórios: docs/canonical/MD/, MAP/, BR/, FRONT/, ADR/
│       Ação: Carregar apenas documentos relevantes ao escopo da tarefa.
│       Regra: Sempre verificar se há documento mais recente. Usar o mais atual.
│
├── 14. CARREGAR DUMP SQL (somente conhecimento)
│       Arquivo: database/schema/Dump20260606.sql
│       Ação: Analisar esquemas, tabelas, procedures. Extrair regras de negócio.
│       PROIBIDO: Copiar estrutura literalmente. Apenas extrair conhecimento.
│
├── 15. CARREGAR CÓDIGO EXISTENTE (se existir)
│       Diretórios: apps/, backend/, packages/, database/procedures/
│       Ação: Analisar implementação atual.
│       PROIBIDO: Usar código legado como referência de implementação.
│
├── 16. COMPARAR: DOCUMENTAÇÃO × CÓDIGO × DUMP
│       Ação: Identificar divergências, gaps, inconsistências.
│       Se encontrar divergência:
│           ├── PARAR
│           ├── Gerar relatório de divergência
│           ├── NÃO implementar nada até divergência ser resolvida
│           └── Aguardar decisão humana
│
├── 17. (Se não houver divergência) IDENTIFICAR GAP
│       Ação: O que falta? O que precisa ser criado? O que precisa ser atualizado?
│       Regra: Sempre atualizar documento existente antes de criar código.
│
├── 18. ATUALIZAR DOCUMENTAÇÃO (se necessário)
│       Ação: MD, MAP, BR, FRONT, ADR — atualizar ou criar conforme necessário.
│       Regra: Nenhum código sem documentação correspondente.
│
├── 19. SÓ ENTÃO: EXECUTAR TAREFA
│       Ação: Implementar, gerar código, criar documento.
│       Regra: Implementação sempre parte da documentação, nunca do código legado.
│
└── FIM
```

---

## Regras Absolutas do Bootstrap

```text
1. NÃO pule etapas.
2. NÃO assuma conhecimento prévio.
3. NÃO use código legado como referência de implementação.
4. NÃO crie código sem documentação atualizada.
5. NÃO implemente se houver divergência documentação × código × dump.
6. NÃO altere documentação canônica sem processo de governança.
7. NÃO renomeie arquivos sem autorização explícita.
8. NÃO apague arquivos sem autorização explícita.
9. NÃO crie v2, final, backup, old, temp.
10. NÃO pare no meio do bootstrap para executar tarefas parciais.
```

---

## Checklist de Validação do Bootstrap

Antes de executar QUALQUER tarefa, confirme:

- [ ] Li `000-CONSTITUICAO-PLATAFORMA.md` completamente
- [ ] Li `001-CONSTITUICAO-IA.md` completamente
- [ ] Li `002-INDICE-GERAL.md` completamente
- [ ] Li `003-GLOSSARIO.md` completamente
- [ ] Li `docs/canonical/MD-110-Canonical-Laws.md` completamente
- [ ] Li `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md` completamente
- [ ] Li as Leis de Evolução Documental (MD-CANONICO-IA-001 até 004)
- [ ] Li `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md` completamente
- [ ] Carreguei os documentos específicos do escopo da tarefa
- [ ] Analisei o dump SQL (somente conhecimento)
- [ ] Comparei documentação × código × dump
- [ ] Não há divergências pendentes
- [ ] Documentação está atualizada

Se qualquer item estiver pendente, VOLTAR ao bootstrap. Não prosseguir.

---

## Mecanismo de Autoverificação

A cada nova interação, a IA deve reexecutar o bootstrap parcial:

```
Nova tarefa recebida
│
├── É uma tarefa nova (não relacionada à anterior)?
│       SIM → Executar bootstrap completo
│       NÃO → Executar bootstrap parcial (itens relevantes)
│
├── Houve alteração em documento canônico desde a última interação?
│       SIM → Recarregar documento alterado
│       NÃO → Prosseguir
│
└── Validar: Documentação atualizada? Código alinhado? Dump alinhado?
```

---

## Estrutura de Pastas — Referência Rápida

```
AtendimentoOfflineAlpha/
├── 000-BOOTSTRAP-IA.md          ← VOCÊ ESTÁ AQUI
├── 001-CONSTITUICAO-IA.md       ← Governança das IAs
├── 002-INDICE-GERAL.md          ← Índice navegável
├── 003-GLOSSARIO.md             ← Linguagem oficial
├── 000-CONSTITUICAO-PLATAFORMA.md ← Constituição suprema
│
├── docs/
│   └── canonical/
│       ├── livros/               ← 26 livros canônicos
│       │   ├── LIVRO-01-FILOSOFIA.md
│       │   ├── LIVRO-02-LEIS-CANONICAS.md
│       │   ├── LIVRO-03-ARQUITETURA.md
│       │   ├── LIVRO-04-DOMINIOS.md
│       │   ├── LIVRO-05-DATABASE.md
│       │   ├── LIVRO-06-BACKEND.md
│       │   ├── LIVRO-07-FRONTEND.md
│       │   ├── LIVRO-08-PORTAL.md
│       │   ├── LIVRO-09-IAM.md
│       │   ├── LIVRO-10-RUNTIME.md
│       │   ├── LIVRO-11-WORKFLOW.md
│       │   ├── LIVRO-12-KERNEL.md
│       │   ├── LIVRO-13-DISPLAYS.md
│       │   ├── LIVRO-14-IA.md
│       │   ├── LIVRO-15-DOCUMENTACAO.md
│       │   ├── LIVRO-16-CODING-STANDARDS.md
│       │   ├── LIVRO-17-DESIGN-SYSTEM.md
│       │   ├── LIVRO-18-KILO-ENGINE.md
│       │   ├── LIVRO-19-ROADMAP.md
│       │   ├── LIVRO-20-ANTI-PATTERNS.md
│       │   ├── LIVRO-21-SEGURANCA.md
│       │   ├── LIVRO-22-INFRAESTRUTURA.md
│       │   ├── LIVRO-23-OBSERVABILIDADE.md
│       │   ├── LIVRO-24-TESTES.md
│       │   ├── LIVRO-25-RELEASES.md
│       │   └── LIVRO-26-GOVERNANCA.md
│       │
│       ├── MD/                    ← Documentos canônicos técnicos
│       ├── MAP/                   ← Mapas de arquitetura
│       ├── BR/                    ← Regras de negócio
│       ├── FRONT/                 ← Experiência Frontend
│       ├── ADR/                   ← Architecture Decision Records
│       └── RADAR/                 ← Radar de Arquitetura
│
├── engineering/
│   ├── bootstrap/                 ← Scripts de bootstrap automático
│   ├── kilo/                      ← Módulos do KILO Engine
│   └── templates/                 ← Templates de documento, código, teste
│
├── apps/                          ← Aplicações canônicas (frontend)
├── backend/                       ← Backend canônico único
├── packages/                      ← Pacotes compartilhados (UI, SDK, Auth)
├── database/                      ← Dump, procedures, views, migrations
├── dashboards/                    ← Dashboards canônicos
├── dispositivos/                  ← TV, Totem, Kiosk, Mobile
├── workflow/                      ← N8N, automações
├── runtime/                       ← Offline-first, sync, cache
└── legacy/                        ← Código legado CONGELADO
```

---

## Mensagem Final do Bootstrap

```text
Se você chegou até aqui, você não é mais um visitante.
Você é parte da plataforma.

Você não escreve código sozinho.
Você escreve código dentro de uma constituição.

Você não cria arquitetura sozinho.
Você segue uma arquitetura canônica.

Você não decide sozinho.
Você sugere, e o ser humano decide.

Bem-vindo ao AtendimentoOfflineAlpha.
Bem-vindo à Plataforma Midas Enterprise.

Agora, leia 002-INDICE-GERAL.md e comece.
```

---

**Bootstrap IA — Projeto AtendimentoOfflineAlpha — Versão 1.0**
**Status: CANÔNICO IMUTÁVEL**
**Se este arquivo for alterado, todo o projeto reinicia o bootstrap.**
