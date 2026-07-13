# ASSET-INVENTORY

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Inventário de assets do frontend.
```

---

## 1. Objetivo

Este documento é o **inventário oficial de assets** da plataforma New Wave Enterprise.

Ele serve para:
- Mapear todos os assets visuais da plataforma
- Identificar o que existe
- Identificar o que está ausente
- Definir estrutura canônica de assets
- Evitar hardcoding de imagens em componentes

Assets não são apenas "imagens".
Assets incluem:
- Logos
- Ícones
- Backgrounds
- Illustrations
- Fontes
- Cores
- Temas

---

## 2. Estado Atual

### 2.1 Assets existentes

Atualmente, os assets estão organizados em:

```
D:\AtendimentoOfflineAlpha\Captures\
  ├── dashboard\
  │   ├── teladelogin.png
  │   ├── logoSemFundo.png
  │   ├── logo.png
  │   ├── lador do formulario.png
  │   ├── lado do lgomarca SaaS.png
  │   ├── frontend.jpeg
  │   ├── eb31e6e0-fa58-4fbb-a18c-3f4a481daf12.png
  │   ├── dashboardMedico.jpg
  │   ├── dashbaoadGestão.jpeg
  │   ├── baseporta.jpeg
  │   ├── backend e frontend.jpeg
  │   ├── 1000819191.png
  │   ├── 1000819185.png
  │   ├── 1000819184.png
  │   ├── 1000819183.png
  │   ├── 1000819181.png
  │   ├── 1000777622.png
  │   └── ...
  └── [outras capturas de tela]
```

### 2.2 Problemas identificados

| Problema | Impacto | Correção |
|----------|---------|----------|
| Assets em `Captures/` | Não é estrutura de assets de produção | Mover para `apps/portal/src/assets/` |
| Sem estrutura de pastas | Dificulta manutenção | Criar estrutura canônica |
| Sem inventário formal | Assets órfãos | Criar ASSET-INVENTORY.md |
| Nomes não canônicos | Dificulta referência | Padronizar nomenclatura |
| Formatos não otimizados | Performance | Otimizar para web |

### 2.3 Assets ausentes

| Asset | Status | Prioridade |
|-------|--------|------------|
| Logo principal | Ausente | Alta |
| Logo dark mode | Ausente | Alta |
| Favicon | Ausente | Alta |
| Login background | Ausente | Alta |
| Login illustration | Ausente | Média |
| Portal background | Ausente | Média |
| Module icons | Ausentes | Alta |
| Common icons | Ausentes | Alta |
| Empty state illustrations | Ausentes | Média |
| Loading animations | Ausentes | Baixa |

---

## 3. Estrutura Canônica

### 3.1 Estrutura proposta

```
apps/portal/src/assets/
  ├── brand/
  │   ├── logo.svg
  │   ├── logo-dark.svg
  │   ├── logo-icon.svg
  │   ├── favicon.ico
  │   └── manifest.json
  │
  ├── login/
  │   ├── backgrounds/
  │   │   ├── bg-login-desktop.webp
  │   │   ├── bg-login-mobile.webp
  │   │   └── bg-login-totem.webp
  │   ├── illustrations/
  │   │   ├── illustration-welcome.svg
  │   │   └── illustration-login.svg
  │   └── images/
  │       └── login-hero.png
  │
  ├── portal/
  │   ├── modules/
  │   │   ├── module-assistencial.svg
  │   │   ├── module-administrativo.svg
  │   │   ├── module-financeiro.svg
  │   │   └── module-farmacia.svg
  │   ├── cards/
  │   │   ├── card-default.png
  │   │   └── card-hover.png
  │   └── icons/
  │       ├── icon-home.svg
  │       ├── icon-user.svg
  │       ├── icon-settings.svg
  │       └── icon-logout.svg
  │
  ├── common/
  │   ├── icons/
  │   │   ├── arrow-left.svg
  │   │   ├── arrow-right.svg
  │   │   ├── check.svg
  │   │   ├── error.svg
  │   │   ├── warning.svg
  │   │   ├── info.svg
  │   │   └── loading.svg
  │   ├── images/
  │   │   ├── empty-state.png
  │   │   ├── not-found.png
  │   │   └── loading.gif
  │   └── fonts/
  │       ├── inter-regular.woff2
  │       ├── inter-medium.woff2
  │       └── inter-bold.woff2
  │
  └── themes/
      ├── light/
      │   └── [theme assets]
      └── dark/
          └── [theme assets]
```

### 3.2 Regras de nomenclatura

```text
Formato: {categoria}-{descricao}.{extensao}

Exemplos corretos:
  logo.svg
  logo-dark.svg
  bg-login-desktop.webp
  icon-home.svg
  module-assistencial.svg

Exemplos incorretos:
  teladelogin.png
  CMDPro - Google Chrome 25_01_2026 22_14_54.png
  1000819191.png
  lador do formulario.png
```

### 3.3 Regras de formato

| Tipo | Formato preferido | Fallback |
|------|------------------|----------|
| Ícones | SVG | PNG |
| Logos | SVG | PNG |
| Backgrounds | WebP | JPG |
| Photos | WebP | JPG |
| Illustrations | SVG | PNG |
| Animações | GIF | Lottie |
| Fontes | WOFF2 | WOFF |

---

## 4. Inventário de Assets

### 4.1 Assets existentes (Captures/)

| Arquivo | Categoria | Uso atual | Uso futuro | Classificação |
|---------|-----------|-----------|------------|---------------|
| teladelogin.png | Login | Captura de referência | REUSE como referência | HISTORICAL |
| logoSemFundo.png | Brand | Logo sem fundo | REUSE como base para logo.svg | REUSE |
| logo.png | Brand | Logo com fundo | REUSE como referência | HISTORICAL |
| lador do formulario.png | Login | Captura de formulário | Referência para layout | HISTORICAL |
| lado do lgomarca SaaS.png | Brand | Logo marca SaaS | REUSE como referência | REUSE |
| frontend.jpeg | Referência | Captura de frontend | Referência arquitetural | HISTORICAL |
| dashboardMedico.jpg | Dashboard | Captura dashboard médico | REUSE como referência | HISTORICAL |
| dashbaoadGestão.jpeg | Dashboard | Captura dashboard gestão | REUSE como referência | HISTORICAL |
| baseporta.jpeg | Portal | Captura base do portal | REUSE como referência | HISTORICAL |
| backend e frontend.jpeg | Referência | Captura arquitetura | Referência arquitetural | HISTORICAL |

### 4.2 Assets ausentes (a criar)

| Asset | Categoria | Prioridade | Responsável |
|-------|-----------|------------|-------------|
| logo.svg | Brand | Alta | Design |
| logo-dark.svg | Brand | Alta | Design |
| logo-icon.svg | Brand | Alta | Design |
| favicon.ico | Brand | Alta | Design |
| bg-login-desktop.webp | Login | Alta | Design |
| bg-login-mobile.webp | Login | Alta | Design |
| illustration-welcome.svg | Login | Média | Design |
| module-assistencial.svg | Portal | Alta | Design |
| module-administrativo.svg | Portal | Alta | Design |
| module-financeiro.svg | Portal | Alta | Design |
| module-farmacia.svg | Portal | Alta | Design |
| icon-home.svg | Common | Alta | Design |
| icon-user.svg | Common | Alta | Design |
| icon-settings.svg | Common | Alta | Design |
| icon-logout.svg | Common | Alta | Design |
| empty-state.png | Common | Média | Design |

---

## 5. Assets por Domínio

### 5.1 Login Experience

| Asset | Status | Classificação |
|-------|--------|---------------|
| Background desktop | Ausente | REUSE |
| Background mobile | Ausente | REUSE |
| Background totem | Ausente | REUSE |
| Illustration welcome | Ausente | REUSE |
| Logo | Ausente | REUSE |
| Favicon | Ausente | REUSE |

### 5.2 Portal Experience

| Asset | Status | Classificação |
|-------|--------|---------------|
| Module icons | Ausentes | REUSE |
| Card backgrounds | Ausentes | REUSE |
| Navigation icons | Ausentes | REUSE |
| Dashboard widgets | Ausentes | REUSE |

### 5.3 Dashboard

| Asset | Status | Classificação |
|-------|--------|---------------|
| Charts | Ausentes | REUSE |
| Widgets | Ausentes | REUSE |
| Tables | Ausentes | REUSE |

### 5.4 Common

| Asset | Status | Classificação |
|-------|--------|---------------|
| Arrow icons | Ausentes | REUSE |
| Check/Error/Warning | Ausentes | REUSE |
| Empty state | Ausente | REUSE |
| Loading | Ausente | REUSE |

---

## 6. Classificação

### 6.1 REUSE

Assets existentes que podem ser reaproveitados:
- `logoSemFundo.png` — base para logo.svg
- `logo.png` — referência de logo
- `dashboardMedico.jpg` — referência de dashboard
- `dashbaoadGestão.jpeg` — referência de dashboard
- `baseporta.jpeg` — referência de portal

### 6.2 ADAPT

Assets existentes que precisam de adaptação:
- Nenhum no momento

### 6.3 REPLACE

Assets existentes que devem ser substituídos:
- `teladelogin.png` — captura de tela, não é asset de produção
- `lador do formulario.png` — captura de tela, não é asset de produção
- `frontend.jpeg` — captura de tela, não é asset de produção
- `backend e frontend.jpeg` — captura de tela, não é asset de produção
- Todas as capturas de tela com data no nome

### 6.4 OBSOLETE

Assets que não devem ser usados:
- Todos os arquivos de captura de tela com timestamp
- Arquivos com nomes não canônicos

---

## 7. Regras de Governança

### 7.1 Criação de assets

```text
Novo asset:
1. Verificar se já existe asset equivalente
2. Se existir: reutilizar
3. Se não existir: criar com nome canônico
4. Otimizar para web (WebP, SVG, WOFF2)
5. Documentar no ASSET-INVENTORY.md
```

### 7.2 Uso de assets

```text
Todo asset deve:
- Ter nome canônico
- Estar em estrutura organizada
- Ser referenciado por caminho canônico
- Ter fallback definido
- Ser otimizado para produção
```

### 7.3 Manutenção

```text
Asset obsoleto:
1. Marcar como OBSOLETE no inventário
2. Não deletar
3. Mover para pasta de histórico se necessário
4. Atualizar referências
```

---

## 8. Plano de Ação

### 8.1 Curto prazo

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Criar estrutura de pastas | Alta | Frontend |
| Migrar assets existentes | Alta | Frontend |
| Criar logo principal | Alta | Design |
| Criar favicon | Alta | Design |
| Criar backgrounds de login | Alta | Design |

### 8.2 Médio prazo

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Criar ícones de módulos | Média | Design |
| Criar ícones comuns | Média | Design |
| Criar ilustrações | Média | Design |
| Otimizar assets | Média | Frontend |

### 8.3 Longo prazo

| Tarefa | Prioridade | Responsável |
|--------|-----------|-------------|
| Criar sistema de temas | Baixa | Design |
| Criar asset pipeline | Baixa | Frontend |
| Automatizar otimização | Baixa | Frontend |

---

## 9. Referências

- FRONT-CATALOG
- FRONTEND-AUDIT
- MAP-CORE-PLATFORM
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do inventário de assets |

---

Documento Canônico — ASSET-INVENTORY

**Este é o inventário oficial de assets da plataforma New Wave Enterprise.**
