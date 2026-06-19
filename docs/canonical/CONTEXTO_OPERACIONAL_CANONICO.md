# CONTEXTO_OPERACIONAL_CANONICO.md

## Fluxo de Contexto Obligatório

```
Login
→ Portal
→ Aplicação
→ Contexto Operacional
→ Dashboard
```

## Hierarquia do Contexto

```
SAAS_ENTIDADE (Empresa/Cliente)
└── UNIDADE
    └── LOCAL_OPERACIONAL
        ├── SETOR
        │   └── SALA
        ├── PAINEL
        └── GUICHE
```

## Contextos Suportados

| Tipo | Descrição |
|------|-----------|
| **Empresa** | Organização cliente (SaaS Entidade) |
| **Unidade** | Local físico (Hospital, UPA, UBS, Clínica) |
| **Local** | Área operacional (Triagem, Recepção, Consultório) |
| **Setor** | Departamento (Enfermagem, Medicina, Farmácia) |
| **Sala** | Sala específica (Sala 1, Sala 2, Sala 3) |
| **Painel** | Display de chamadas |
| **Guichê** | Balcão/Triagem (1, 2, 3) |

## Regras Canônicas

- Contexto é obrigatório para operações assistenciais
- Nenhuma operação pode ocorrer sem contexto definido
- Contexto determina permissões de acesso
- Contexto é validado via stored procedure `sp_contexto_validar`
- Contexto é persistido via `usuario_contexto`