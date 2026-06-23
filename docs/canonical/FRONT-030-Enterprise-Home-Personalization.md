# FRONT-030 — Enterprise Home Personalization

## Status

Documento Canônico de Frontend.
Define a personalização do Portal por usuário.

---

## Objetivo

Cada usuário possui seu próprio Portal personalizável com widgets, atalhos e dashboards.

---

## Princípio Fundamental

```text
Portal não é canônico para todos.
Portal é personalizado por usuário.
Portal é produtivo.
Portal é intuitivo.
Portal é sempre útil.
```

---

## Componentes

### WidgetGrid

```text
Widgets arrastáveis (drag and drop)
Redimensionamento livre
Layout salvo por usuário
Restaurar layout padrão
Ocultar/mostrar widgets
```

### ShortcutBar

```text
Atalhos para apps favoritas
Arrastar app para atalho
Editar atalho (tooltip)
Limite de 10 atalhos
Organização por área
```

### AppLauncher

```text
Grid de apps disponíveis
Filtro por categoria
Busca de apps
Apps recentes
Apps recomendados
Apps obrigatórios no topo
```

### DashboardPicker

```text
Seleção de dashboards
Dashboard favorito
Dashboard recente
Dashboard compartilhado
Criar dashboard personalizado
Editar dashboard existente
```

### FavoritePanel

```text
Itens favoritados
Documentos favoritos
Apps favoritas
Dashboards favoritos
Workflows favoritos
Quick access bar
```

---

## Perfis de Personalização

### Recepcionista

```text
Widgets: Fila de atendimentos, Agenda do dia, Comunicados
Atalhos: Atendimento, Agenda, SAC
Apps: HIS, Agenda, Comunicados
Dashboards: Atendimento ao vivo, Agendamentos
Favoritos: Template de atendimento, SOP
```

### Farmacêutico

```text
Widgets: Estoque atual, Dispensação do dia, Vencimentos
Atalhos: Estoque, Dispensação, Vencimentos
Apps: Farmácia, Estoque, Alertas
Dashboards: Medicamentos críticos, Validade
Favoritos: Protocolo de dispensação, Alertas
```

### Diretor

```text
Widgets: KPIs executivos, Analytics financeiro, Governança
Atalhos: Command Center, Analytics, Compliance
Apps: Command Center, Analytics, Financeiro
Dashboards: Executive, Financeiro, Riscos
Favoritos: Relatórios executivos, Alertas críticos
```

---

## Regras

### Obrigatório

```text
Layout é salvo automaticamente
Atalhos têm limite máximo
Widgets têm versão canônica
Favoritos têm busca
Dashboards têm permissão de acesso
```

### Proibido

```text
Widget sem versão canônica
Atalho sem app válido
Favorito sem permissão
Dashboard compartilhado sem autorização
Layout salvo sem validação
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-020 — Portal Core Architecture | Core do Portal |
| MD-043 — Dashboard Framework | Dashboards |
| MD-060 — Marketplace Platform | Apps e widgets |
| MD-108 — Preference Management | Preferências de usuário |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Experience | Portal base |
| FRONT-012 — Widget Framework | Widgets canônicos |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Grid, atalhos, favoritos, personalização |
| Backend | APIs de preferências, layout, favoritos |
| Dispatcher | Roteamento para SPs de preferências |
| SP | Salvar/recuperar preferências, validar permissões |
| Event Store | Registrar personalização, uso de widgets |

---

## Métricas

```text
Layouts personalizados criados
Widgets mais usados por perfil
Atalhos configurados
Apps acessados via launcher
Dashboards favoritos
Taxa de personalização
Satisfação com Portal (CSAT)
Tempo de acesso a apps favoritos
```

---

## Lei

```text
Cada usuário possui seu próprio Portal.
Portal é personalizável.
Portal é produtivo.
Portal é intuitivo.
Portal é sempre útil.
```

---

## Próximo

```text
FRONT-030 completo
  ↓
FIM DA FASE 2
```