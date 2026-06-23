# FRONT-010 — Mobile PWA Experience

## Status

Documento Canônico de Frontend.
Define a experiência PWA/Mobile da plataforma.

---

## Objetivo

Garantir que a plataforma seja universalmente acessível via dispositivos móveis, com ou sem app nativo.

---

## Princípio Fundamental

```text
Mobile não é Desktop menor.
Mobile é experiência própria.
PWA é a versão universal.
App nativo é opção para casos específicos.
```

---

## Fluxo Canônico

```
Mobile/PWA
  ↓
Login (FRONT-001 / Mobile)
  ↓
Context Selection (FRONT-002 / Mobile)
  ↓
Portal Mobile (FRONT-010)
  ↓
Apps (versão mobile)
  ↓
Operação (otimizada para toque)
```

---

## Componentes

### MobileShell

```text
Header compacto
Bottom navigation (5 itens principais)
Drawer menu (apps menos usadas)
Search bar (colapsável)
Context switcher (perfil/unidade/local)
Status de conexão (online/offline/sync)
```

### TouchPatterns

```text
Botões mínimos 44x44px (WCAG / iOS HIG)
Swipe para ações (archive, delete, navigate)
Pull-to-refresh
Long-press para contexto (menu secundário)
Gestos de navegação (voltar, home)
FAB (Floating Action Button) para ação principal
```

### OfflineFirst (Runtime)

```text
Queue local para ações (IndexedDB/SQLite)
Sync automático quando online
Indicador visual de pendências
Resolução de conflitos (CRDT)
Notificação quando sync completa
Dados sensíveis criptografados localmente (MD-035)
```

### NotificaçõesPush

```text
Push nativo (service worker)
Deep link para tela específica
Ação direta (responder, aprovar, abrir)
Badge no ícone do app
Preferências por app (opt-in/out)
Respeito a quiet hours
```

### MobileAuth

```text
Biometria (fingerprint, face)
PIN (4-6 dígitos)
SSO nativo (Android/iOS)
Trusted Device (lembrar por 30 dias)
Logout remoto (admin)
```

---

## Apps por Categoria (Mobile)

### Apps Mobile-First

```text
Totem (captura de senha/checkbox)
Recepção (triagem, senha)
Médico (prontuário, fila)
Enfermagem (evolução, medicação)
Farmácia (dispensação, estoque)
Paciente (consulta própria, exames, telemedicina)
```

### Apps Mobile-Friendly (Desktop → Mobile)

```text
Portal (leitura, notificações)
BI (dashboards consumidos)
Chat (mensagens)
Documentos (leitura, download)
Aprovações (workflow mobile)
Calendar (eventos)
```

### Apps Não-Mobile (Desktop apenas)

```text
Configurações avançadas
Administração de sistema
Edição complexa de workflows
Desenvolvimento de prompts IA
```

---

## Regras

### Performance

```text
First Load < 3s (3G)
Time to Interactive < 5s
Bundle inicial < 200KB (gzip)
Images em WebP/AVIF
Lazy load de módulos não críticos
Service Worker para cache estático
```

### Segurança

```text
App sandboxed (PWA / Trusted Web Activity)
Certificado SSL válido
Sem mixed content (HTTP + HTTPS)
Sem armazenamento inseguro de tokens
Remote wipe para tenants Enterprise
```

### Acessibilidade

```text
VoiceOver / TalkBack compatível
Contraste mínimo 4.5:1 (WCAG AA)
Focus visível
Labels em todos os controles
Skip links
Suporte a zoom (até 200%)
```

### Offline-First

```text
Todas as ações de escrita vão para queue local.
Queue é sincronizada quando conexão retorna.
Conflitos são resolvidos automaticamente quando possível.
Conflitos complexos notificam usuário para resolução manual.
Nenhuma ação é perdida.
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-036 — Mobile PWA Architecture | Arquitetura mobile |
| MD-061 — Edge Runtime Architecture | Runtime edge |
| MD-062 — Offline-First Engine | Offline-first |
| MD-063 — Sync Engine | Sincronização |
| MD-064 — Conflict Resolution Engine | Conflitos |
| MD-035 — Security Trust Architecture | Segurança mobile |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 a FRONT-009 | Telas adaptadas para mobile |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | PWA, touch patterns, offline queue, push notifications |
| Backend | APIs otimizadas para mobile (payload reduzido) |
| Dispatcher | Roteamento mobile-aware (headers de dispositivo) |
| SP | Regras de negócio (idênticas ao desktop) |
| Event Store | Registrar ações mobile, sync, conflitos |
| Runtime | Sincronização, cache, conflitos |

---

## Métricas

```text
First Load P95 (mobile)
Usuários mobile vs. desktop
Apps mais usadas no mobile
Taxa de sync success
Conflitos resolvidos automaticamente
Push notifications entregues e abertas
Taxa de instalação de PWA
Uso de biometria para login
Satisfação mobile (CSAT)
Erros de touch/acessibilidade
```

---

## Lei

```text
Mobile é experiência própria.
Offline é direito, não feature.
Mobile acessa toda a plataforma.
Mobile não é desktop menor.
Touch é linguagem.
```

---

## Próximo

```text
FRONT-010 completo
FASE 2 CONCLUÍDA
  ↓
FASE 3 — MAP-001 a MAP-010
FASE 4 — BR-001 a BR-xxx
```
