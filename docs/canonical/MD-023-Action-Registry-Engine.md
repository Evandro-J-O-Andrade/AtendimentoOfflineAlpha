# MD-023 — Action Registry Engine

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o motor do Portal Core responsável por registrar, resolver e executar ações de forma segura, isolada e rastreável, eliminando chamadas diretas a SPs e rotas legadas.

---

## Princípio Fundamental

```text
Nenhuma ação executa sem estar registrada no Action Registry.
Nenhuma app acessa legacy diretamente.
Toda ação gera evento no Event Store.
```

---

## Papel na Arquitetura

```
Portal Core
  ↓
Action Registry Engine
  ↓
Adapter Layer
  ↓
Legacy (SPs / Rotas)
```

O Action Registry Engine é a fronteira oficial entre o Portal e o Adapter.

---

## Action Registry

Cada ação registrada contém:

```json
{
  "codigo": "FILA.CHAMAR",
  "dominio": "OPERACIONAL",
  "sp": "sp_chamar_senha",
  "evento": "SENHA_CHAMADA",
  "criticalidade": "CRITICAL",
  "contexto_obrigatorio": true,
  "permissoes": ["FILA.ACESSAR"],
  "adapter": "LEGACY_SP"
}
```

---

## Responsabilidades

- Manter catálogo oficial de ações.
- Resolver ação por código.
- Validar sessão, tenant, contexto e permissão.
- Encaminhar execução ao Adapter correspondente.
- Garantir que toda ação seja emitida no Event Store.
- Impedir execução de ações não registradas.

---

## Regras

1. Toda ação deve existir no registry antes de ser executada.
2. Toda ação deve estar vinculada a um domínio.
3. Toda ação deve ter permissão mínima explícita.
4. Nenhuma ação executa sem contexto válido quando `contexto_obrigatorio = true`.
5. Nenhuma ação executa sem geração de evento.
6. Apenas ações registradas podem ser expostas no App Registry.
7. Ações desativadas não são executadas, apenas consultadas para histórico.

---

## Integração

- **MD-021 (Adapter)**: recebe ações resolvidas.
- **MD-005 (Event Store)**: recebe eventos obrigatórios.
- **MD-002 (Auth)**: valida sessão e permissão.
- **MD-003 (OperationalContext)**: valida contexto.
- **MD-007 / MD-014 (App Registry)**: ações são agrupadas por aplicação.

---

## Proibições

São proibidos:

```text
Ação não registrada
Execução bypassando Action Registry
Chamada direta a SP pelo Portal
Chamada direta a rota legada pelo Portal
Ação sem evento
Permissão hardcoded
```

---

## Lei Do Action Registry Engine

```text
Toda ação nasce no registry.
Toda ação passa pelo adapter.
Nenhuma ação fica invisível.
```

---












