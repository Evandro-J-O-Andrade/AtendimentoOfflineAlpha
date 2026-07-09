# MD-CANONICO-IA-006 — Lei da Evolução Canônica

## Status

ACEITO / IMUTÁVEL

---

## 1. Propósito

Estabelecer a disciplina de evolução da plataforma a partir do conhecimento existente.

Esta lei complementa a MD-CANONICO-IA-005 (Engenharia e Materialização) definindo **como evoluir**, enquanto a MD-005 define **como implementar**.

---

## 2. Princípio Fundamental

Toda evolução da plataforma deve partir do conhecimento existente.

Antes de criar qualquer artefato, o agente deve compreender:
- o domínio;
- o banco de dados;
- a documentação;
- a implementação atual.

A prioridade absoluta é preservar:
- a coerência arquitetural;
- o conhecimento consolidado;
- a evolução incremental.

Novos objetos somente serão criados quando for tecnicamente demonstrado que não existe solução compatível baseada nos ativos canônicos já existentes.

---

## 3. Rastreabilidade Obrigatória

Toda implementação deve ser rastreável de ponta a ponta.

Cadeia obrigatória:

```
CORE
  ↓
ADR
  ↓
MD / MAP / BR
  ↓
SP / API / Contrato
  ↓
Frontend
```

Nada deve existir "solto".

Toda tabela, SP, API, contrato ou tela deve responder:
- Por qual BR ela existe?
- Qual CORE a criou?
- Qual ADR justificou a decisão?
- Qual MD documenta seu comportamento?

---

## 4. Matriz de Cobertura

Todo domínio, regra de negócio, ADR, MAP e MD deve ser coberto por:
- código
- API
- frontend
- testes

Toda falta de cobertura deve ser registrada no dossiê do CORE correspondente.

---

## 5. Engenharia Reversa do Código

Além do banco, o agente deve analisar o código existente antes de propor novos objetos.

Para cada arquivo/componente/serviço:
- Esse código ainda é utilizado?
- Quem importa?
- Quem referencia?
- Está morto?
- Pode ser removido?

Isso evita acúmulo de código legado.

---

## 6. Auditorias Obrigatórias

### 6.1 Auditoria de Performance
Antes de fechar qualquer CORE:

- Banco: índices, joins, explain plan, N+1
- Backend: chamadas duplicadas, cache, serialização
- Frontend: renderizações, lazy loading, bundle

### 6.2 Auditoria de Segurança
Todo CORE deve verificar:

- Autorização
- CSRF
- Replay
- Idempotência
- Rate Limit
- Injection
- XSS
- CSP
- Headers
- Cookies
- Logs

### 6.3 Auditoria Operacional
Para cada operação de escrita ou fluxo crítico, responder:

> "Se esta operação falhar às 3 da manhã em um hospital, o que acontece?"

Verificar:
- rollback
- retry
- fila
- operação pendente
- auditoria

---

## 7. Catálogo Canônico

Todo artefato canônico deve possuir identificador único:

```
CAT-001  Tabela    usuario
CAT-002  Procedure  sp_auth_login
CAT-003  View       vw_usuario
CAT-004  API        /auth/login
CAT-005  Contract   PermissionContract
```

O catálogo permite rastreabilidade instantânea.

---

## 8. Glossário Canônico

Termos comuns devem ser registrados para evitar divergência semântica.

Exemplos obrigatórios:

| Termo A | ≠ | Termo B |
|---------|---|---------|
| Pessoa | ≠ | Usuário |
| Tenant | ≠ | Contexto |
| Capability | ≠ | Permission |
| Reimpressão | ≠ | Reemissão |
| Cancelamento | ≠ | Depreciação |

O glossário é parte integrante da documentação canônica.

---

## 9. Registro de Decisões Rejeitadas

Toda decisão arquitetural relevante deve ser registrada, inclusive as rejeitadas.

Exemplo:

```
Decisão: Criar tabela permission
Resultado: Rejeitado
Motivo: Já existia estrutura baseada em perfil/menu.
Decisão tomada em: Dossiê CORE-XXX
Data: YYYY-MM-DD
```

Isso evita que a mesma ideia reapareça meses depois.

---

## 10. Princípio da Simplicidade

Antes de aprovar qualquer implementação, o agente deve responder:

> "Existe uma solução menor utilizando o que já existe?"

Se a resposta for sim, ela deve ser escolhida.

A solução mais simples que atende o requisito é preferível à solução mais complexa.

---

## 11. Auditoria de Coerência

Antes de concluir qualquer CORE, verificar:

- Banco ↔ MDs
- MDs ↔ ADRs
- ADRs ↔ COREs
- COREs ↔ Código
- Código ↔ Banco

Se qualquer resposta for "não", o CORE não é concluído.

---

## 12. Lei da Conservação da Arquitetura

Nenhum componente existente será substituído, duplicado ou descartado sem análise arquitetural completa.

Ordem de preferência:

1. Reutilizar
2. Adaptar
3. Estender
4. Criar novo (última alternativa)

Criar novo exige:
- justificativa técnica;
- análise de impacto;
- materialização completa (documentação, SQL, contratos, backend, frontend).

---

## 13. Cobertura Canônica Mínima

Nenhum CORE pode ser considerado concluído antes de esgotar:

- ✔ Leitura do Dump relacionado
- ✔ Leitura de documentos canônicos relacionados
- ✔ Inventário de tabelas, views, procedures e functions
- ✔ Mapeamento de dependências
- ✔ Classificação REUSE / ADAPT / PROPOSE
- ✔ SQL materializado para todo PROPOSE
- ✔ Implementação
- ✔ Typecheck limpo
- ✔ Validação E2E com banco vivo (quando aplicável)

Cobertura alvo: **95% do Dump Canônico relevante** antes de propor objetos novos.

---

## 14. Regra de Imutabilidade do Dump Canônico

O Dump Canônico é **somente leitura** para engenharia.

Qualquer alteração no banco deve seguir:

```
Dump Canônico (somente leitura)
    ↓
Scripts SQL versionados
    ↓
Aplicação no banco
    ↓
Novo Dump gerado
    ↓
Atualização do inventário
```

Nunca editar o dump manualmente. Ele é um retrato do estado do banco.

---

## 15. Anti-Duplicação

Antes de criar qualquer arquivo, função, classe, view ou procedure, é obrigatório verificar se já existe algo equivalente.

Se existir:
- reutilizar
- ou adaptar

Nunca criar paralelo.

---

## 16. Proibição de Nomes Versionados

Nunca criar nomes temporários ou versionados:
- `v2`, `_new`, `_next`, `temp_`, `_2026`, `_beta`

Versionamento é Git.
Não o banco.

---

## 17. Conclusão

Esta lei, combinada com a MD-CANONICO-IA-005, define a disciplina de engenharia da plataforma.

Juntas, elas estabelecem:
- **MD-005** — como implementar
- **MD-006** — como evoluir

Qualquer implementação futura deve ser validada contra essas regras antes de ser considerada aceitável.

```text
SCAN → REUSE → ADAPT → PROPOSE → SQL → IMPLEMENT → VALIDATE
EVOLVE → TRACE → COVER → AUDIT → GOVERN
```

Sempre.
Sem exceção.
