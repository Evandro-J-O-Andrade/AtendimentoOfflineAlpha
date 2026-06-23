# FRONT-007 — Intranet Experience

## Status

Documento Canônico de Frontend.
Define a experiência de Intranet Corporativa da plataforma.

---

## Objetivo

Centralizar comunicação institucional, cultura organizacional e acesso a conteúdo corporativo.

---

## Princípio Fundamental

```text
Intranet não é Home.
Intranet é uma App registrada.

Portal é a porta de entrada.
Intranet é comunicação institucional.
```

---

## Fluxo Canônico

```
Portal (FRONT-003)
  ↓
App Registry → Intranet App
  ↓
Conteúdo Institucional
  ↓
Interação (comentários, compartilhamentos)
```

---

## Componentes

### HomeIntranet

```text
Hero banner (comunicado da diretoria)
Cards de acesso rápido:
  - Comunicados
  - Organograma
  - Políticas
  - Formulários
  - Eventos
  - Diretoria
  - Notícias
```

### Comunicados

```text
Lista de comunicados ordenados por data
Filtros: Todos, Urgente, RH, TI, Diretoria
Marcar como lido
Comentar (moderado)
Notificar relevantes
```

### Organograma

```text
Visualização hierárquica
Navegação por cliques
Informação de contato (email, ramal, local)
Possibilidade de ver equipe direta
```

### Políticas e Documentos

```text
Categorias:
  - RH
  - Compliance
  - Segurança
  - TI
  - Operacional
Upload de PDF/Office
Busca interna
Download auditado
Confirmação de leitura (opcional)
```

### Formulários

```text
Formulários corporativos:
  - Férias
  - Requisição de material
  - Mudança de turno
  - Treinamento
  - Benefícios
Preenchimento online
Anexo de documentos
Acompanhamento de status
Integração com workflows (MD-089)
```

### Notícias

```text
Notícias da empresa
Compartilhamento interno
Curtidas e comentários
Relacionamento com post social (reuso)
```

---

## Regras

### Acesso

```text
Intranet é app registrada (MD-019).
Visibilidade = todos os funcionários do tenant (padrão).
Admins podem restringir comunicados por unidade/perfil.
Conteúdo externo (links) abre em nova aba com aviso.
```

### Conteúdo

```text
Comunicado urgente = destaque + notificação.
Documento confidencial = acesso por perfil específico.
Política = versão controlada + confirmação de leitura.
Formulário = workflow de aprovação integrado.
```

### Moderação

```text
Conteúdo criado por comunicação/RH.
Comentários moderados.
Conteúdo inapropriado = remoção + auditoria.
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-028 — Enterprise Social Network | Feed e social integrado |
| MD-029 — Digital Workplace | Workplace corporativo |
| MD-042A — Portal Experience | Intranet como App |
| MD-088 — Global Notification Center | Notificações institucionais |
| MD-089 — Workflow Fabric | Workflows de formulários |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Acesso via Portal |
| FRONT-006 — Social Experience | Feed compartilhado |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Comunicados, Organograma, Políticas, Formulários, Notícias |
| Backend | APIs de conteúdo intranet, formulários, organograma |
| Dispatcher | Roteamento para SPs de intranet |
| SP | Regras de visibilidade, aprovação, confirmação de leitura |
| Event Store | Registrar visualizações, confirmações, interações |

---

## Métricas

```text
Acessos à Intranet por dia
Comunicados lidos vs. enviados
Taxa de confirmação de leitura
Formulários enviados vs. aprovados
Tempo médio de acesso
Conteúdo mais acessado
Satisfação com Intranet (CSAT)
```

---

## Lei

```text
Intranet não é Home.
Portal é a porta de entrada.
Intranet é App.
Intranet é comunicação institucional.
```

---

## Próximo

```text
FRONT-007 completo
  ↓
FRONT-008 — Chat Experience
```
