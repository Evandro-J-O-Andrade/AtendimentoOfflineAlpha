# MD-CANONICO-IA-005 — Lei de Engenharia e Materialização

## Status

ACEITO / IMUTÁVEL

---

## 1. Princípio da Conservação da Arquitetura

Nenhum componente existente poderá ser substituído, duplicado ou descartado sem uma análise arquitetural completa.

Toda evolução deve preservar:
- a semântica dos COREs já validados;
- os contratos públicos já consolidados;
- a compatibilidade entre módulos;
- o modelo canônico do banco de dados.

A primeira opção é sempre **reutilizar**.
A segunda é **adaptar**.
A terceira é **estender**.
Criar um novo componente é a **última alternativa** e exige:
- justificativa técnica;
- análise de impacto;
- materialização completa (documentação, SQL, contratos, backend e frontend).

O projeto evolui por **incremento**, nunca por reconstrução.

---

## 2. Lei Canônica da Materialização

```text
Nenhuma tabela nasce sem justificar
por que as existentes não atendem.

Nenhuma SP nasce sem justificar
por que as existentes não atendem.

Nenhuma FK nasce sem um relacionamento
canônico previamente definido.
```

O banco de dados é a fonte da verdade.
Nunca o código.

Fluxo obrigatório:

```
Banco (Dump Canônico)
    ↓
Análise
    ↓
Contratos
    ↓
Backend
    ↓
Frontend
```

Nunca o contrário.

---

## 3. Ciclo Obrigatório de Implementação

Toda nova funcionalidade ou CORE obrigatoriamente segue:

```
1. Ler o Dump
    ↓
2. Inventariar (tabelas, views, procedures, functions, índices)
    ↓
3. Reaproveitar (REUSE)
    ↓
4. Adaptar (ADAPT)
    ↓
5. Só então propor (PROPOSE)
    ↓
6. DOSSIER DE MATERIALIZAÇÃO
    ↓
7. MODELO CONCEITUAL
    ↓
8. REVISÃO TRANSVERSAL
    ↓
9. Gerar SQL
    ↓
10. Implementar backend
    ↓
11. Implementar frontend
    ↓
12. Validar
```

---

## 4. Ordem de Decisão

### PASSO 1
Existe tabela/view/SP/function no Dump Canônico que atende total ou parcialmente?
- **SIM** → REUSE

### PASSO 2
Não existe exatamente, mas existe algo semanticamente equivalente ou parcial?
- **SIM** → ADAPT

### PASSO 3
Não existe nada no Dump.
- Somente então → PROPOSE

Todo PROPOSE deve ser acompanhado do SQL correspondente.

---

## 5. Engenharia Reversa Obrigatória

Antes de criar qualquer coisa, é obrigatório:

1. Ler integralmente o Dump Canônico.
2. Ler documentação relevante (MD, MAP, BR, ADR, CORE).
3. Ler código existente relacionado.
4. Entender o fluxo atual.
5. Mapear dependências entre tabelas, SPs e views.
6. Identificar o que já resolve o problema.

Não basta localizar objetos pelo nome.
É obrigatório compreender:
- a finalidade do objeto;
- os relacionamentos;
- as entradas e saídas;
- a semântica no domínio.

---

## 6. Nomenclatura Canônica

Nunca criar nomes temporários ou versionados:
- `usuario_v2`
- `permission_runtime_v3`
- `portal2`
- `dashboard_new`
- `runtime_next`
- `temp_permissions`

Sempre evolução sobre o objeto canônico existente.

Exemplos corretos:
- `sp_auth_menu_get` → `sp_auth_permissions_evaluate`
- `perfil` → manter `perfil`
- `usuario` → manter `usuario`

Versionamento é Git.
Não o banco.

---

## 7. SQL Sempre Acompanha a Proposta

Toda proposta deve gerar SQL materializado:

```
Tabela       → CREATE TABLE ...
Procedure    → CREATE PROCEDURE ...
View         → CREATE VIEW ...
Function     → CREATE FUNCTION ...
Index        → CREATE INDEX ...
```

Nada fica apenas na documentação.

O SQL deve ser gerado na pasta correspondente:
- `docs/database/procedures_raw_texts/` para SPs
- `database/migrations/proposed/` para tabelas/views novas
- scripts de aplicação em `backend/sql/future/`

---

## 8. Análise de Impacto (Obrigatória)

Antes de modificar qualquer contrato, arquivo ou tabela, é obrigatório apresentar:

```text
Arquivos impactados:
- packages/contracts
- packages/runtime
- backend
- frontend

Risco:
- BAIXO | MÉDIO | ALTO

Compatibilidade:
- 100% | PARCIAL | QUEBRA

Breaking Changes:
- Nenhum | Lista justificada
```

Se houver quebra, ela deve ser justificada tecnicamente.

---

## 9. Cobertura Canônica Mínima

Nenhum CORE pode ser considerado concluído antes de esgotar:

```
✔ Leitura do Dump relacionado
✔ Leitura de documentos canônicos relacionados
✔ Inventário de tabelas, views, procedures e functions
✔ Mapeamento de dependências
✔ Classificação REUSE / ADAPT / PROPOSE
✔ SQL materializado para todo PROPOSE
✔ Implementação
✔ Typecheck limpo
✔ Validação E2E com banco vivo (quando aplicável)
```

Cobertura alvo: **95% do Dump Canônico relevante** antes de propor objetos novos.

---

## 10. Reverse Engineering Semântico

O agente não deve procurar apenas pelo nome.
Deve descobrir objetos pela semântica.

Exemplo:
Para “permissões” não procurar apenas `permission`.
Deve encontrar:
- `perfil`
- `permissao`
- `perfil_permissao`
- `usuario_perfil`
- `usuario_unidade`
- `usuario_local`
- `usuario_contexto`
- `sessao_usuario`
- `sp_auth_menu_get`
- `sp_sessao_tem_permissao`
- `sp_usuario_tem_permissao`

E montar o call graph antes de propor qualquer objeto novo.

---

## 11. Regras de Implementação

Durante a implementação de qualquer CORE:

1. Não substituir contratos já consolidados sem justificativa arquitetural.
2. Não quebrar compatibilidade dos COREs anteriores.
3. Não renomear objetos canônicos.
4. Não criar estruturas paralelas ou duplicadas.
5. Não criar versões (`_v2`, `_new`, `_next` etc.).
6. Preferir ampliar contratos existentes em vez de criar novos quando fizer sentido.
7. Toda modificação deve preservar a semântica já validada.
8. Se um contrato precisar evoluir, adaptar mantendo compatibilidade sempre que possível.
9. Toda SP nova deve documentar o call graph completo.
10. Toda página nova deve documentar o fluxo completo frontend → API → SP → tabelas.
11. Nada de `TODO` escondido. Toda pendência deve ser formalizada como PROPOSE com SQL.

---

## 12. Status Canônico dos Objetos

Cada objeto do ecossistema deve ter um status explícito:

```
REUSE      → já existe, sem alteração
ADAPT      → existe, sendo adaptado
PROPOSE    → não existe, SQL gerado
IMPLEMENTED→ aplicado no banco
VALIDATED  → testado contra banco real
```

---

## 13. Mapa de Evolução Obrigatório

Ao concluir qualquer CORE, apresentar:

```text
Concluído:
- CORE-XXX

Objetos REUSE:
- lista

Objetos ADAPT:
- lista

Objetos PROPOSE:
- lista + SQL

Próximo:
- CORE-YYY

Dependências:
- ADR, contratos, SPs, tabelas
```

---

## 14. Compatibilidade Cruzada

Todo CORE concluído deve declarar compatibilidade explícita:

```text
Compatível com:
- CORE-001 Auth
- CORE-002 Context
- CORE-003 Portal Metadata
- CORE-004 Permission Runtime
...
```

---

## 15. Proibição de Suposições

O agente nunca deve assumir que algo existe sem verificar explicitamente no Dump Canônico ou no código.

Se não encontrou:
```
Não encontrado no Dump.
Necessário propor (PROPOSE).
```

Nunca:
```
Provavelmente existe...
```

Sem magia.
Sem implícito.
Toda afirmação deve ser rastreável.

---

## 16. Anti-Duplicação

Antes de criar qualquer arquivo, função, classe, view ou procedure, é obrigatório verificar se já existe algo equivalente no ecossistema.

Se existir:
- reutilizar
- ou adaptar

Nunca criar paralelo.

Exemplo proibido:
```
PermissionResolver
PermissionRuntimeResolver
PortalPermissionResolver
```

Exemplo correto:
```
PermissionResolver
  → ampliado com novos métodos
```

---

## 17. Call Graph e Fluxo Completo

Toda SP nova deve apresentar:
```
Frontend
    ↓
API
    ↓
Dispatcher
    ↓
Master
    ↓
Executor
    ↓
Tabelas
```

Toda página nova deve apresentar:
```
Componente
    ↓
Hook/Runtime
    ↓
API Client
    ↓
Endpoint
    ↓
Service/Controller
    ↓
SP/Procedure
    ↓
Tabelas
```

Nenhuma ponta solta é permitida.

---

## 18. Conclusão

Essa lei define o comportamento padrão do agente para todo o restante do projeto.

Qualquer implementação futura deve ser validada contra essas regras antes de ser considerada aceitável.

```text
SCAN → REUSE → ADAPT → PROPOSE → SQL → IMPLEMENT → VALIDATE
```

Sempre.
Sem exceção.

---

## 19. Fases Pré-Implementação Obrigatórias

Nenhum CORE ou funcionalidade pode pular para código sem antes concluir as fases abaixo, nesta ordem:

### Etapa 1 — Inventário do Dump
Ler integralmente o Dump Canônico relacionado e produzir:
- tabelas, views, procedures, functions, índices e FKs relacionadas;
- finalidade, dependências, quem utiliza e status REUSE / ADAPT / PROPOSE.

### Etapa 2 — Inventário do Código
Analisar:
- `packages/contracts`
- `packages/runtime`
- `packages/api`
- `backend`
- apps frontend relevantes

Produzir:
- arquivos existentes;
- responsabilidade;
- dependências;
- possíveis reutilizações;
- arquivos que precisam apenas de adaptação.

### Etapa 3 — Mapa de Impacto
Antes de modificar qualquer arquivo, apresentar:
- arquivos alterados;
- arquivos novos, apenas se indispensáveis;
- contratos impactados;
- compatibilidade com trabalhos anteriores;
- breaking changes, se existirem.

Nenhuma alteração começa antes dessa aprovação.

### Etapa 4 — Gap Analysis
Comparar:
- Dump
- Documentação
- Backend
- Runtime
- Frontend

Produzir uma tabela por objeto:
- situação
- ação

### Etapa 5 — Plano de Materialização
Somente após Gap Analysis gerar:
- SQL de tabelas faltantes
- SQL de views
- SQL de procedures
- SQL de functions
- ordem correta de implantação
- dependências entre objetos

Nenhum código TypeScript pode ser escrito antes desse plano estar concluído.

### Etapa 6 — Dossiê de Implementação
Nenhum CORE é iniciado sem dossiê contendo:
- objetivo
- inventário do dump
- objetos reutilizados
- objetos adaptados
- objetos propostos
- SQL gerado
- impacto
- plano de implementação
- plano de testes
- checklist final

### Etapa 7 — Aprovação para Implementar
Somente após dossiê aprovado:
- implementar backend
- implementar frontend
- executar testes
- validar E2E quando aplicável

---

## 20. Triangulação Canônica

Toda implementação deve ser validada por três perspectivas:

- **Dump Canônico** → realidade física do banco
- **MD Canônico** → significado e regras de negócio
- **Código Canônico** → estado atual da implementação

Somente quando as três estiverem alinhadas o agente implementa.
Se houver divergência entre qualquer uma delas, a divergência deve ser identificada e resolvida antes de criar novos objetos ou alterar contratos.

O MD não pode ser usado como referência canônica se for:
- placeholder
- rascunho sem conteúdo mínimo
- inconsistente com o Dump Canônico atual
- não versionado ou sem status explícito

---

## 21. Qualidade Documental Mínima

Nenhum documento canônico pode ser referenciado por outro documento se não possuir conteúdo mínimo suficiente para orientar implementação e validação.

Conteúdo mínimo exigido:
- objetivo do domínio/componente
- escopo claro do que pertence e do que não pertence
- conceitos e entidades centrais
- fluxo operacional principal
- regras de negócio relevantes
- modelo de dados ou referência canônica ao banco
- procedures ou interfaces relevantes
- implicações de runtime
- segurança/permissões quando aplicável
- tratamento de erros quando aplicável
- status explícito de maturidade

Status obrigatórios:
- RASCUNHO
- EM DESENVOLVIMENTO
- COMPLETO
- VALIDADO

Documentos classificados como RASCUNHO não podem ser usados como base para CORE, ADR ou implementação.

---

## 22. Auditoria de Redundância

Antes de concluir qualquer CORE ou sprint, deve ser verificada a existência de:
- arquivos duplicados
- SPs redundantes
- Views redundantes
- Contracts redundantes
- Resolvers redundantes
- Hooks redundantes
- Componentes redundantes

Se encontrado, propor consolidação antes do merge/entrega.

---

## 23. Revisão Transversal Obrigatória

Nenhum objeto PROPOSE pode ser materializado enquanto não for confrontado com todos os domínios estratégicos da plataforma.

### 23.1 Domínios mínimos obrigatórios

- HIS
- Portal Enterprise
- Intranet
- ERP
- CRM
- BI
- Mobile
- API
- Marketplace
- Display/TV
- Integrações

### 23.2 Critério de aprovação

A revisão transversal está APROVADA quando:
1. Todos os domínios estratégicos foram consultados
2. A matriz de consumo está preenchida
3. Não há conceitos específicos de um único domínio no Kernel
4. O modelo é suficientemente genérico para todos os domínios
5. A quantidade de tabelas/procedures é mínima mas suficiente

### 23.3 Pergunta final

> Qual é o menor conjunto de conceitos que atende TODOS os domínios?

Se a resposta for "X conceitos", e X for maior que o necessário, reduzir.

---

## 24. Banco Vivo e Artefatos Derivados

O `bancoMysql.md` é a fonte oficial (imutável).

Qualquer índice, mapa ou catálogo é um artefato derivado, descartável e regenerável.

Exemplos de artefatos derivados:
- `DB-INDEX.md`
- `DB-DOMAINS.md`
- `DB-DEPENDENCIES.md`
- `DB-SP-MAP.md`
- `DB-VIEW-MAP.md`
- `DB-FK-MAP.md`
- `DB-JOIN-MAP.md`

Regra:
```
Fonte oficial → bancoMysql.md (nunca alterado)
Artefatos derivados → podem ser regenerados
```

---

## 25. Conclusão

Essa lei define o comportamento padrão do agente para todo o restante do projeto.

Qualquer implementação futura deve ser validada contra essas regras antes de ser considerada aceitável.

```text
AUDIT
  ↓
GATE
  ↓
DOSSIER
  ↓
MODELO CONCEITUAL
  ↓
REVISÃO TRANSVERSAL
  ↓
DOSSIER APROVADO
  ↓
MATERIALIZAÇÃO
```

Sempre.
Sem exceção.

---

## 26. Integração com MD-110

```text
Todos os MDs canônicos (MD-001 até MD-113) são complementares.
Em caso de conflito, MD-110 prevalece.
Qualquer alteração em MD-005 impacta toda a plataforma.
Mudança exige ADR + aprovação do Arquiteto Chefe.
```

---

Documento Canônico Supremo — MD-005

**Esta é a lei de engenharia e materialização do projeto AtendimentoOfflineAlpha.**
