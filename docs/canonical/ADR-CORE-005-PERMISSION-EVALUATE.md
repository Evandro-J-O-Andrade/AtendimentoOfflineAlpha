# ADR-CORE-005 — Permission Evaluate

## Status

```text
PROPOSTO
REQUER APROVAÇÃO
```

Não marcar como ACEITO antes do GATE e aplicação.

---

## Contexto

A plataforma possui autenticação e sessão materializadas.

Existem fontes de contexto:

- `sessao_usuario`
- `usuario_contexto`
- `sessao_contexto_historico`
- `saas_entidade`
- `tenant_registry`

Existem mecanismos parciais de permissão.

O Banco Vivo não possui uma SP canônica única de avaliação de autorização.

Problema:

A plataforma precisa de uma capacidade central para responder:

```text
Este consumidor pode executar esta Capability neste Contexto?
```

---

## Auditoria Banco Vivo

| Elemento                     | Resultado      |
| ---------------------------- | -------------- |
| tabela permissao             | REUSE          |
| perfil_permissao             | REUSE          |
| auth_grupo_permissao         | REUSE          |
| SPs de validação existentes  | ADAPT          |
| sp_auth_permissions_evaluate | AUSENTE        |
| nova capacidade de avaliação | EXTEND/PROPOSE |

---

## Decisão

Criar:

```text
sp_auth_permissions_evaluate
```

como extensão do domínio Auth Permission.

Responsabilidade:

```text
Avaliar autorização.
```

Não:

```text
Executar domínio.
```

---

## Princípio de separação

Fluxo:

```text
Consumer
    |
    v
Runtime
    |
    v
Permission Resolver
    |
    v
sp_auth_permissions_evaluate
    |
    v
Permission Result
```

A SP não conhece:

- Portal;
- Farmácia;
- Estoque;
- IA;
- Mobile.

Ela conhece:

- identidade;
- sessão;
- contexto;
- capability;
- regras de autorização.

---

## Contrato esperado

Entrada:

```json
{
  "id_sessao": "",
  "id_usuario": "",
  "id_tenant": "",
  "id_contexto": "",
  "capability": ""
}
```

Saída:

```json
{
  "allowed": true,
  "capability": "",
  "context": "",
  "reason": "",
  "audit_reference": ""
}
```

---

## Impactos

### Positivos

- Discovery seguro.
- Runtime Resolver confiável.
- IA/MCP com autorização igual ao usuário humano.
- Elimina regras espalhadas.

### Riscos

- Migração incorreta de regras existentes.
- Divergência entre permissões antigas e novas.
- Falta de cobertura de capabilities.

Mitigação:

- Backward compatibility.
- Auditoria.
- Testes de contrato.

---

## Critérios de aprovação GATE

### Banco

- [ ] Migration validada contra dump congelado.
- [ ] Sem duplicar tabela existente.

### Segurança

- [ ] Sessão obrigatória.
- [ ] Contexto obrigatório.
- [ ] Auditoria gerada.

### Arquitetura

- [ ] Não contém regra de negócio.
- [ ] Não chama Executor.
- [ ] Não acessa domínio.

---

## Relação com Registry

Após aprovação:

```text
Capability
      |
      v
Permission Evaluate
      |
      v
Runtime Resolver
```

A capability de autorização passa a ser descoberta pelo metamodelo.

---

## Decisão final

**Aprovar evolução controlada do Auth Permission Runtime através de `sp_auth_permissions_evaluate`, condicionada ao GATE-CORE-005.**

---

Depois desse ADR, o próximo passo correto é **validar a migration SQL existente contra o Banco Vivo**, não aplicar imediatamente. O SQL só entra quando a cadeia ADR → GATE → Migration estiver fechada.
