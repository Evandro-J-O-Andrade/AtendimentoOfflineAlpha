# DESIGN_SYSTEM_CANONICO.md

## Layout Padrão

```
src/
└── shared/
    ├── layouts/
    │   ├── PortalLayout.tsx
    │   ├── AppLayout.tsx
    │   └── DeviceLayout.tsx
    └── components/
        ├── Button.tsx
        ├── Input.tsx
        ├── Card.tsx
        └── Table.tsx
```

## CSS Canônico

```
assets/styles/
├── reset.css
├── variables.css
├── theme.css
├── globals.css
├── portal.css
└── forms.css
```

## Tema Dinâmico

- Cores baseadas em `--brand-primary`
- Tema claro/escuro via class `dark`
- Fontes configuráveis via TenantConfig