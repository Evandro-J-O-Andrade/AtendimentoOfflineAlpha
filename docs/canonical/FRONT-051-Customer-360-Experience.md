# FRONT-051 — Customer 360 Experience

## Status

Documento Canônico de Frontend.
Define a experiência de visão 360° do cliente.

---

## Objetivo

Criar visão única e unificada de qualquer cliente, usuário, colaborador ou organização.

---

## Princípio Fundamental

```text
Nenhum dado do cliente deve ficar isolado.
O cliente é uma entidade viva.
Toda interação, compra, ticket, documento
e evento faz parte da sua história.
```

---

## Componentes

### CustomerProfile

```text
Dados cadastrais (PF/PJ)
Contatos (email, telefone, endereço)
Classificação (tier, segmento)
Tags customizadas
Score de valor (LTV)
Score de risco (churn)
Status (ativo, inativo, prospect)
```

### TimelineInteracoes

```text
Linha do tempo completa:
  - Acessos à plataforma
  - Compras
  - Chamados abertos
  - Treinamentos concluídos
  - Posts e interações sociais
  - Downloads de documentos
  - Avaliações e feedbacks
  - Pagamentos e faturas
Filtros por período, tipo, app
Agrupamento por data
Drill-down para detalhes
```

### Relacionamentos

```text
Contratos ativos
Assinaturas
Apps contratadas
Usuários vinculados
Unidades/Locais atendidos
Histórico de expansão/redução
```

### AnalyticsCliente

```text
Engajamento (ativo, risco, inativo)
Uso por app (quais apps usa mais)
Financeiro (ticket médio, MRR, lifetime)
Satisfação (NPS, CSAT, feedbacks)
Predições (IA: churn risk, expansion opportunity)
```

### AcoesRapidas

```text
Abrir chamado
Enviar proposta
Agendar reunião
Criar treinamento
Enviar documento
Aplicar desconto
```

---

## Regras

### Visibilidade

```text
Dados são filtrados por tenant.
Usuário vê apenas clientes das suas unidades.
Sensível: campos mascarados por perfil.
Histórico completo apenas para perfis autorizados.
```

### Consentimento

```text
Exibição respeita LGPD/GDPR.
Dados sensíveis requerem justificativa de acesso.
Log de visualização no Event Store.
Usuário pode solicitar export de seus dados (LGPD).
```

### Atualização

```text
Dados são atualizados em tempo real via eventos.
Cache invalidado por evento de alteração.
Fonte única: banco de dados (MD-101).
Nenhuma informação é armazenada apenas no frontend.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-071 — Customer 360 Platform | Documento canônico |
| MD-072 — CRM Enterprise | Leads, contratos, pipeline |
| MD-073 — SAC Omnichannel | Chamados, tickets |
| MD-074 — Digital Commerce | Compras, pedidos |
| MD-076 — Loyalty & Rewards | Pontos, badges |
| MD-084 — Knowledge Graph | Relacionamentos |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Dashboards contextuais |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Profile, Timeline, Analytics, Ações |
| Backend | APIs de consulta unificada |
| Dispatcher | Roteamento para SPs e APIs |
| SP | Regras de acesso, junção de dados |
| Event Store | Registrar visualização, ações |
| IA | Predição de churn, expansão, recomendação |

---

## Métricas

```text
Clientes com perfil completo (%)
Interações registradas por cliente
Taxa de atualização de dados
Uso da timeline (cliques, drill-downs)
Ações rápidas mais utilizadas
Satisfação com visão 360 (CSAT)
Tempo para encontrar informação do cliente
```

---

## Lei

```text
O cliente deve possuir
uma única identidade corporativa.
Nenhum dado do cliente fica isolado.
Customer 360 é a fonte única de verdade.
```

---

## Próximo

```text
FRONT-051 completo
  ↓
FRONT-052 — Employee 360 Experience
```
