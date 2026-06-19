# MD-011 — Analytics

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a camada analítica corporativa que consolida métricas de todas as aplicações em uma visão executiva única.

---

## Princípio Fundamental

```text
Um gestor não acessa aplicações operacionais para obter indicadores.
Um gestor acessa Analytics e vê toda a empresa em uma tela.
```

---

## Visão Analítica Global

### O Que É Analytics

```text
Camada acima das aplicações.
Consolidação de métricas multi-aplicação.
Visão executiva unificada.
Painéis por perfil.
Relatórios corporativos.
```

### Aplicações Que Alimentam Analytics

```text
HIS         → Métricas assistenciais
PDV         → Métricas comerciais
CRM         → Métricas de relacionamento
SAC         → Métricas de atendimento
Financeiro  → Métricas econômicas
Estoque     → Métricas de supply chain
AVA         → Métricas de educação
Portal      → Métricas de adoção e engajamento
N8N         → Métricas de automação
IA          → Métricas de uso e efetividade
```

### O Que NÃO É Analytics

```text
NÃO É relatório operacional de aplicação pontual.
NÃO É tela de detalhe assistencial.
NÃO substitui BI de domínio.
NÃO acessa dados pessoais identificáveis sem anonimização.
```

### O Que E Estritamente

```text
Visão executiva consolidada.
KPIs cross-aplicação.
Tendências e projeções.
Comparativos por unidade, por período, por perfil.
Alertas executivos.
Dados agrupados e categorizados.
Informações anonimizadas quando necessário.
```

---

## Arquitetura

```
[Aplicações]
     ↓
Event Store Canônica
     ↓
Data Warehouse
     ↓
Analytics Engine
     ↓
Executive Dashboard
     ↓
Relatórios Corporativos
```

---

## Componentes

### Data Warehouse

Responsável por:

```text
Armazenar dados históricos consolidados
Modelo dimensional ou wide-column conforme volume
Particionado por tenant e por domínio
Atualização via ETL ou CDC
Retenção configurável por regulamentação
Imutabilidade de registros históricos
```

### Analytics Engine

Responsável por:

```text
Agregações pré-calculadas (KPIs)
Consultas analíticas otimizadas
Machine Learning para previsões
Segmentação de dados
Processamento de eventos em tempo real (streaming opcional)
```

### Executive Dashboard

Responsável por:

```text
Visão 360 da empresa
Navegação por domínio
Drill-down controlado
Exportação de relatórios
Alertas e notificações executivas
Acesso condicionado a perfil
```

### Camada De Relatórios

```text
Relatórios padrão
Relatórios customizáveis
Agendamento de geração
Distribuição automática
Histórico de versões de relatórios
```

---

## Modelo De Dados Analíticos

### Entidades Principais

kpi_meta:
  - Definição de indicadores
  - Fórmula de cálculo
  - Periodicidade
  - Unidade de medida
  - Responsável

kpi_valor:
  - Valor calculado
  - Período de referência
  - Dimensões (tenant, unidade, aplicação, perfil)
  - Tendência
  - Meta vs realizado

relatorio:
  - Definição de relatório
  - Filtros padrão
  - Formato de saída
  - Agendamento
  - Destinatários

dashboard:
  - Composição de widgets
  - Filtro global
  - Perfil de acesso
  - Configuração de layout

---

## Regras

1. Analytics consome Event Store como fonte primária.
2. Dados pessoais identificáveis nunca entram em relatórios executivos.
3. KPIs são calculados no Data Warehouse, não em tempo real nas aplicações.
4. Queries analíticas pesadas NUNCA tocam o banco transacional.
5. Cada tenant define próprios KPIs baseados no catálogo padrão.
6. Dashboards são configurados por perfil executivo.
7. Histórico de relatórios é mantido por período regulamentar.
8. Alertas são gerados por regras de negócio, não por thresholds arbitrários.
9. Acesso a Analytics requer perfil autorizado.
10. Dados de Analytics são read-only para usuários finais.

---

## Fluxo De Dados

```text
Aplicação Executa Ação
  ↓
Event Store Canônica
  ↓
Ingestão (ETL/CDC)
  ↓
Data Warehouse
  ↓
Cálculo De KPI
  ↓
Analytics Engine
  ↓
Executive Dashboard
  ↓
Usuário Autorizado Visualiza / Exporta
```

---

## Perfis De Acesso

| Perfil | Acesso | Restrição |
|--------|--------|-----------|
| Gestor Executivo | Dashboards consolidados | Por tenant e unidades atribuídas |
| Gestor Operacional | KPIs de suas unidades | Por unidade e aplicação |
| Analista | Relatórios e dados | Somente leitura, sem dados pessoais |
| Administrador | Configuração de dashboards | Apenas internos do tenant |

---

## Integração Com Outros Módulos

- Auth: valida perfil e tenant para acesso a Analytics.
- Dispatcher: Analytics pode disparar ações administrativas via Dispatcher.
- Event Store: fonte primária de dados.
- App Registry: permite Analytics como aplicação registrada.
- IA: pode gerar insights e sugestões baseados em Analytics.

---

## Proibições

São proibidos:

```text
Queries analíticas em banco transacional
Dashboards hardcoded para tenant específico
Relatórios com dados pessoais identificáveis
Alteração manual de KPIs calculados
Dashboards operacionais dentro de Analytics
Remoção de histórico de KPIs
Acesso a Analytics sem validação de perfil
Upload de dados externos sem validação de tenant
Compartilhamento de dados entre tenants
```

---

## Lei Do Analytics

```text
Dashboards são visão, não fonte.
KPIs são calculados, não inventados.
Histórico é imutável.
Dados de tenant não alcançam outro tenant.
```

---

## Responsabilidades

Analytics É Responsável Por:

```text
Consolidar Métricas Multi-Aplicação
Manter Data Warehouse Integro
Calcular KPIs Por Tenant E Período
Garantir Isolamento De Dados Analíticos
Documentar Significado De Cada Indicador
Fornecer Dashboards E Relatórios Corporativos
```

Aplicações São Responsáveis Por:

```text
Emitir Eventos Canônicos Para Toda Ação Relevante
NÃO Calcular Métricas Executivas
NÃO Acessar Dados De Outras Aplicações
Respeitar Estrutura De Eventos Para Ingestão
