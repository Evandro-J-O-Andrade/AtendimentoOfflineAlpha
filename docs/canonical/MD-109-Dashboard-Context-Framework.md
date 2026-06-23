# MD-109 — Dashboard Context Framework

## Status

Documento Canônico de Dashboards.
Define como dashboards são construídos, compostos e entregues por contexto.

---

## Objetivo

Garantir que dashboards não pertencem a apps, mas ao contexto do usuário.

---

## Princípio Fundamental

```text
Dashboard não é uma tela bonita.
Dashboard é a projeção do contexto do usuário
sobre os dados da aplicação.

Dashboard =

  App
+ Perfil
+ Permissão
+ Contexto Operacional
```

---

## Lei Suprema

```text
Dois usuários na mesma App
nunca veem o mesmo Dashboard,
a menos que tenham
exatamente o mesmo Perfil,
Permissão e Contexto.
```

---

## Componentes do Dashboard

### App

```text
A que domínio o dashboard pertence.
Ex: FARMACIA, OPERACIONAL, CRM, SAC.
App determina: dados disponíveis, ações possíveis, núcleo de análise.
```

### Perfil

```text
O papel do usuário dentro da app no contexto atual.
Ex: Em FARMACIA:
  - Farmacêutico: lotes, validades, dispensações
  - Gerente: metas, equipe, margem
  - Diretor: BI, comparativos, rede
Perfil determina: widgets visíveis, KPIs exibidos, filtros disponíveis.
```

### Permissão

```text
O que o usuário pode fazer na app.
Ex: VER_DASHBOARD, EDITAR_PRESCRICAO, CANCELAR_SENHA.
Permissão determina: ações disponíveis, drill-down permitido, export habilitado.
```

### Contexto Operacional

```text
Onde o usuário está operando.
Ex: Unidade = Hospital São Lucas, Local = Farmácia 2º Andar.
Contexto determina: dados geográficos/filtros, regras locais, indicadores específicos.
```

---

## Arquitetura de Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│                    Dashboard Engine                          │
│                                                             │
│  Entrada:                                                   │
│  ├── App (obrigatório)                                     │
│  ├── Perfil (obrigatório)                                  │
│  ├── Permissões (obrigatório)                              │
│  └── Contexto (obrigatório)                                │
│                                                             │
│  Processamento:                                             │
│  ├── Carregar widgets por App + Perfil                     │
│  ├── Filtrar widgets por Permissão                         │
│  ├── Aplicar filtros de Contexto                           │
│  ├── Resolver dados por tenant/unidade/local               │
│  ├── Aplicar regras de negócio (via SP)                    │
│  └── Formatar e enriquecer                                 │
│                                                             │
│  Saída:                                                     │
│  ├── Widgets ordenados por prioridade                      │
│  ├── KPIs calculados                                        │
│  ├── Gráficos com dados                                    │
│  └── Ações disponíveis                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Tipos de Dashboard

### Dashboard Operacional

```text
Uso: dia a dia do operador.
Público: Recepcionista, Enfermeiro, Médico, Farmacêutico, Caixa.
Atualização: Tempo real ou near-real-time.
Conteúdo: filas, senhas, atendimentos em andamento, métricas de processo.
Exemplos:
  - Dashboard de Fila: senhas aguardando, chamando, em atendimento.
  - Dashboard de Farmácia: dispensações pendentes, lotes vencendo.
  - Dashboard de PDV: vendas do dia, sangria, fechamento.
```

### Dashboard Gerencial

```text
Uso: gestão e decisão.
Público: Gerente, Diretor, Coordenador.
Atualização: Hora a hora ou diária.
Conteúdo: KPIs, metas, comparativos, tendências.
Exemplos:
  - Dashboard de Gerente de Farmácia: meta de dispensação, estoque crítico.
  - Dashboard de Diretor: receita por unidade, taxa de ocupação, NPS.
```

### Dashboard Estratégico

```text
Uso: visão de negócio e estratégia.
Público: C-Level, Conselho, Investidores.
Atualização: Diária ou semanal.
Conteúdo: MRR, ARR, churn, pipeline, market share.
Exemplos:
  - Dashboard Executivo: saúde financeira, crescimento, riscos.
  - Dashboard de Tenant: uso da plataforma, ROI, satisfação.
```

---

## Widgets

### Tipos

```text
KPI Card    → Número com meta e variação
Chart       → Gráfico (linha, barra, pizza, área)
Table       → Tabela de dados com ordenação e filtro
List        → Lista de itens com ações
Map         → Mapa geográfico (unidades, clientes)
Gauge       → Medidor de performance
Timeline    → Linha do tempo de eventos
Feed        → Feed de atividades recentes
Alert       → Alerta condicional (crítico, warn, info)
```

### Composição

```text
Widget =
  Tipo
+ Título
+ Descrição
+ Fonte de Dados (SP canônica)
+ Parâmetros (filtros por contexto)
+ Permissão Requerida
+ Ordem
+ Layout (grid, tamanho)
+ Refresh Rate
```

---

## Segurança de Dashboard

```text
Widget sem permissão para o perfil = oculto.
Dados filtrados por tenant/unidade/local.
Export apenas se permissão EXPLICITAMENTE concedida.
Drill-down respeita permissão de nível inferior.
Dados sensíveis mascarados conforme role.
Cache respeita permissão (não cacheia dados de tenant A para tenant B).
```

---

## Performance

| Tipo | Refresh | Cache | P95 |
|------|---------|-------|-----|
| Operacional | 30s | Redis | < 200ms |
| Gerencial | 1h | Redis + BI | < 500ms |
| Estratégico | 24h | BI/Lakehouse | < 2s |
| Customizado | Configurável | Sob demanda | < 1s |

---

## Integrações

```text
MD-020 — Portal Core Architecture
MD-042A — Portal Experience
MD-043 — Dashboard Framework
MD-030 — Enterprise Analytics
MD-039 — Analytics Data Intelligence
MD-085 — Data Lakehouse Platform
MD-087 — Enterprise Search Platform
MD-081 — AI Copilot Framework
MD-099 — Strategic Command Center
```

---

## Regras

1. Todo dashboard nasce de uma combinação App + Perfil + Permissão + Contexto.
2. Nenhum dashboard é hardcoded por app.
3. Widgets são configuráveis por tenant e por perfil.
4. Dados são sempre filtrados por tenant/unidade/local.
5. Dashboard operacional exige contexto ativo.
6. Dashboard gerencial pode ter contexto opcional (visão agregada).
7. Export e drill-down respeitam permissões.
8. Layout é responsivo e segue Design System.
9. Cache é invalidado por evento, nunca por tempo fixo cego.
10. Erro em widget não quebra o dashboard inteiro.

---

## Lei

```text
Dashboard é contextual.
Dashboard é permissivo.
Dashboard é dinâmico.
Dashboard é a cara do usuário.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Dashboard Engine canônico
Catálogo de widgets por app/perfil
Resolução de contexto
Performance e cache
Layout e Design System
Segurança de dados por widget
```

Tenants são responsáveis por:

```text
Configurar widgets disponíveis
Definir layouts customizados (quando permitido pelo plano)
Solicitar novos widgets via suporte
Manter permissões atualizadas
```

---

## Métricas

```text
Dashboards ativos
Widgets por dashboard
Tempo de carregamento P95
Taxa de erro por widget
Uso de drill-down
Uso de export
Filtros mais usados
Dashboards mais acessados por perfil
Satisfação com dashboards
```
