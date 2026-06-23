# MD-094 — White Label Architecture

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Permitir que tenants operem a plataforma como se fosse deles, com marca própria.

---

## Princípio Fundamental

```text
Plataforma é uma.
Marca são muitas.
Experiência é única por tenant.
Tecnologia é compartilhada.
```

---

## Componentes

### Branding

```text
Logo
Nome do produto
Cores primária e secundária
Tipografia
Favicon
Ícones
Splash screen
Login screen customizado
Email templates customizados
```

### Domínio

```text
Subdomínio: tenant.plataforma.com
Domínio próprio: app.tenant.com.br (CNAME)
SSL automático (Let's Encrypt / AWS ACM)
HSTS configurado
Cookies por domínio
CORS por domínio
```

### Tema

```text
Temas claro/escuro por tenant
Customizações de cor por papel
Componentes do Design System tematizáveis
CSS variables sobrepostas
Logo por contexto (unidade, local)
Avatar e ícones customizados (tenant upload)
```

### experiência

```text
Login com branding próprio
Dashboard com cores do tenant
Apps com header/footer customizados
Notificações com marca do tenant
Relatórios com logo inserido
PDFs e documentos com marca
```

---

## Arquitetura

```
Tenant A
  ├── brand: "Hospital São Lucas"
  ├── domain: saolucas.plataforma.com
  ├── theme: azul/branco
  └── custom: logo, email, pdf

Tenant B
  ├── brand: "Rede Pharma"
  ├── domain: pharma.empresa.com.br
  ├── theme: verde/roxo
  └── custom: logo, email, pdf

Plataforma Core
  ├── Design System (variável)
  ├── Componentes tematizáveis
  ├── Motor de brand por request
  └── Assets multi-tenant isolados
```

---

## Integrações

```text
MD-014 Design-System
MD-013 Frontend-Shell
MD-020 Portal-Core-Architecture
MD-017 Multi-Tenant
MD-034 IAM
MD-014 App-Registry
MD-093 SDK-Extensions-Framework
MD-095 Multi-Brand-Architecture
```

---

## Regras

1. Nenhum tenant enxerga marca de outro tenant.
2. Assets customizados são isolados por tenant.
3. Tema é aplicado no primeiro byte da resposta (SSR-ready).
4. Domínio customizado não altera Auth nem IAM.
5. Email e PDF usam template do tenant, não do canônico.
6. Tenant pode solicitar branded features adicionais via suporte.
7. White label não altera regras de negócio.

---

## Lei

```text
Marca muda.
Plataforma permanece.
Experiência é única por tenant.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Motor de brand por request
Tema engine
Gestão de domínios e SSL
Isolamento de assets por tenant
Documentação de customização
```

Tenants são responsáveis por:

```text
Fornecer assets de marca corretos
Seguir diretrizes de customização
Não modificar contratos de API por branding
Manter domínio e SSL atualizados
```

---

## Métricas

```text
Tenants com white label ativo
Domínios customizados provisionados
Temas customizados por tenant
Tempo de carregamento do branding
Erros de brand por request
Customizações aprovadas vs. solicitadas
Satisfação com experiência white label
```
