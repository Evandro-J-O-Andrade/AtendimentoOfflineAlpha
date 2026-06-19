# MIGRACAO_CANONICA_2026

## Objetivo

Consolidar definitivamente a Plataforma New Wave SaaS.

Todo código, documento, tela, API, componente, tabela ou workflow existente será considerado LEGADO até passar pelo processo de homologação arquitetural.

---

# Regra 1 — Legado por padrão

Tudo que existe atualmente deve ser movido para:

legacy/

Exemplos:

legacy/frontend
legacy/backend
legacy/docs
legacy/prototipos

Nenhum item do legado pode ser utilizado diretamente em produção.

---

# Regra 2 — Processo de Recuperação

Um item somente poderá sair do legado após auditoria técnica.

Perguntas obrigatórias:

1. Está alinhado à arquitetura canônica?
2. Respeita Pessoa como entidade raiz?
3. Respeita Login → Portal → Aplicação → Contexto?
4. Respeita SaaS Entidade?
5. Respeita Sessão como identidade operacional?
6. Respeita Auditoria?
7. Respeita Offline-First?
8. Respeita Evento como motor central?
9. Não cria policentrismo?
10. Não conflita com documentos canônicos?

Se qualquer resposta for NÃO:

O item permanece em legado.

---

# Regra 3 — Homologação

Quando aprovado:

Recebe status:

HOMOLOGADO_CANONICO

e pode ser movido para:

apps/
packages/
backend/
database/
docs/

---

# Regra 4 — Proibição de Rebaixamento

Artefatos homologados não podem voltar para legado por mudança de opinião.

Somente podem voltar para legado se existir:

* erro arquitetural comprovado
* conflito canônico comprovado
* falha estrutural comprovada

Toda decisão deve ser documentada.

---

# Regra 5 — Fonte da Verdade

A arquitetura canônica possui prioridade máxima.

Ordem de autoridade:

1. ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md
2. Documentos canônicos especializados
3. Banco canônico
4. Código homologado
5. Legado

---

# Regra 6 — Critério de Recuperação

Recuperar antes de reescrever.

Se um artefato já resolver corretamente o problema:

RECUPERAR.

Não reescrever apenas por preferência pessoal.

---

# Regra 7 — Critério de Reescrita

Reescrever somente quando:

* conflitar com a arquitetura canônica
* impedir escalabilidade SaaS
* impedir multiempresa
* impedir offline-first
* impedir rastreabilidade
* impedir auditoria

---

# Resultado Esperado

Ao final da migração existirão apenas:

docs/canonico
apps
packages
backend
database

Todo o restante permanecerá em legacy apenas para consulta histórica.

