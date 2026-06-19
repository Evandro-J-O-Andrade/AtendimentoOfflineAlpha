# MD-001 — Núcleo da Plataforma

## Status

Documento Canônico Fundacional.

Este documento define a ontologia imutável da Plataforma New Wave SaaS.

---

## Objetivo

Definir as entidades fundamentais da plataforma e impedir que módulos criem versões próprias de identidade, sessão, contexto, pessoa, senha, FFA ou evento.

---

## Entidades Raiz

A plataforma possui uma única ontologia canônica:

```text
Sistema
Tenant
Unidade
Local
Usuário
Sessão
Perfil
Permissão
Pessoa
FFA
Senha
Evento
```

---

## Regras Imutáveis

1. Nenhum módulo pode criar versões próprias das entidades raiz.
2. Nenhuma aplicação pode criar identidade paralela.
3. Nenhuma aplicação pode criar sessão paralela.
4. Nenhuma aplicação pode criar contexto operacional paralelo.
5. Nenhuma aplicação pode criar evento fora do Event Store canônico.
6. O Banco Canônico é a fonte da verdade.
7. Stored Procedures são a camada oficial de execução.
8. Eventos são a camada oficial de rastreabilidade.

---

## Proibições

São proibidos nomes e modelos como:

```text
usuario_v2
tenant_local
perfil_alpha
sessao_operacional_proprietaria
evento_assistencial_independente
auditoria_proprietaria
```

---

## Lei da Plataforma

```text
Existe apenas uma entidade canônica para cada conceito fundamental.
```

---

## Impacto Arquitetural

Toda nova camada deve consumir a ontologia canônica.

Nenhum backend, frontend, app, domínio, workflow, IA, N8N ou integração pode redefinir estas entidades.
