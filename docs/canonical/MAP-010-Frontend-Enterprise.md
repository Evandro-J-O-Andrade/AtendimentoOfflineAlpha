# MAP-010 — Mapa Frontend Enterprise

## Status

Documento Canônico De Mapeamento.
Fonte: estrutura frontend + MDs de UI/UX.

---

## Componentes Identificados

| Componente | Fonte | Status |
|------------|-------|--------|
| Frontend Canônico | docs/canonical/FRONTEND_CANONICO.md | TEORIA |
| Frontend Shell | MD-013 | CANONICO |
| Design System | MD-014 | CANONICO |
| Portal Core Architecture | MD-020 | CANONICO |
| Portal Experience | MD-042A | EMENDA |
| Mobile PWA Architecture | MD-036 | CANONICO |
| White Label Architecture | MD-094 | CANONICO |
| Multi-Brand Architecture | MD-095 | CANONICO |
| Internationalization | MD-096 | CANONICO |

---

## Estrutura Mapeada

```
frontend/
├── shell/                    # MD-013
│   ├── app/                  # Router, providers, layout
│   ├── components/           # Sidebar, Header, Menu, Context Selector
│   └── features/             # Auth, Search, Notifications, App Launcher
│
├── apps/                     # MD-019, MD-020
│   ├── portal/               # Portal Core
│   ├── operacional/          # HIS, Fila, Senha
│   ├── farmacia/             # Farmácia
│   ├── financeiro/           # Caixa, PDV
│   ├── faturamento/          # Faturamento
│   ├── estoque/              # Estoque
│   ├── rh/                   # RH
│   ├── ti/                   # TI
│   ├── suporte/              # SAC
│   ├── crm/                  # CRM
│   ├── bi/                   # BI / Analytics
│   ├── administracao/        # Admin
│   └── documentos/           # Documentos
│
├── design-system/            # MD-014
│   ├── tokens/               # Cores, tipografia, espaçamento
│   ├── primitivos/           # Button, Input, Select...
│   └── compostos/            # DataTable, Modal, Form...
│
├── shared/                   # Utilidades cross-app
│   ├── auth/
│   ├── contexto/
│   ├── eventos/
│   ├── i18n/
│   └── utils/
│
└── legacy/                   # Referência histórica (não referência)
    └── frontend_antigo/
```

---

## Observações

- Estrutura frontend está em estágio inicial conforme dump/código.
- shell/ é o candidato a Frontend Shell canônico (MD-013).
- design-system/ precisa ser elevado a package compartilhado.
- Cada app deve ser isolada no padrão MD-021 (App Lifecycle Isolation).
- Internacionalização (MD-096) aguarda implementação.

---

## Próximos Passos

1. Isolar design-system como package standalone.
2. Implementar shell/ com roteamento dinâmico por Registry.
3. Aplicar App Lifecycle Isolation em cada app.
4. Criar tema engine para White/Multi-Brand (MD-094, MD-095).
5. Implementar i18n com fallback pt-BR → en-US.
