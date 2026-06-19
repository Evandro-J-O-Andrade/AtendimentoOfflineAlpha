# MD-018 — Denormalização e Dispersão

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Evitar dispersão de documentos canônicos e preservar a autoridade de MDs já congelados, garantindo que novas enumerações não gerem fragmentação da arquitetura.

---

## Princípio Fundamental

```text
MDs existentes são a lei.
Reescrever ou reabrir um MD após congelamento é proibido.
Quando um conceito mudar, cria-se um suplemento ou um MD novo.
```

---

## Regras

1. MDs criados em docs/canonical/ não podem ser duplicados por número.
2. Conflitos de numeração são resolvidos com novo número, sem renumerar arquivos antigos.
3. Novo conteúdo só pode ser adicionado em docs/canonical/.
4. Regras arquiteturais devem ser consolidadas em MDs, nunca em conversas avulsas.
5. Esta versão substitui qualquer orientação anterior que conflite.

---








