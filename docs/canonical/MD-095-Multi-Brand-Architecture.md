# MD-095 — Multi-Brand Architecture

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Operar múltiplas marcas e produtos derivados a partir da mesma plataforma.

---

## Princípio Fundamental

```text
Uma plataforma.
Muitas marcas.
Cada marca com identidade, público
e posicionamento próprios.
Mesma tecnologia por baixo.
```

---

## Diferencial de White Label

```text
White Label
  └── Um tenant, uma marca
  └── Customização visual
  └── Domínio próprio
  └── Mesma lógica de produto

Multi-Brand
  └── Várias marcas na mesma plataforma
  └── Posicionamento distinto
  └── Público diferente
  └── Funcionalidades ativadas por marca
  └── Pode ser نفس tenant ou tenant diferente
```

---

## Componentes

### Brand Registry

```text
Nome da marca
Slug único
Logo e assets
Domínios associados
Cores e tipografia
Posicionamento
Público-alvo
Regras de ativação
```

### Product Lines

```text
Marca A: Saúde Enterprise
Marca B: Farmácia Connect
Marca C: Educação Plus
Marca D: Varejo Smart
Marca E: Gov Digital
```

### Feature Flags por Marca

```text
Feature X ativa para Marca A
Feature Y ativa para Marca B
Feature Z disponível para todas
Beta features para marca específica
Migração gradual por marca
```

### Catálogo de Apps por Marca

```text
Marca A: HIS, Farmácia, Faturamento
Marca B: PDV, Estoque, SAC
Marca C: AVA, RH, Social
Marca D: CRM, Marketplace, BI
Marca E: Gestão Pública, Documentos
```

### Pricing por Marca

```text
Planos diferenciados por marca
Descontos por volume por marca
Modelo de assinatura customizado
Marketplace com regras por marca
```

---

## Casos de Uso

### Grupo Empresarial

```text
Mesma empresa.
Muitas marcas (saúde, educação, varejo).
Cada marca usa a mesma plataforma.
Cada marca tem branding próprio.
Dashboard unificado para controladoria.
```

### Venture Builder

```text
Plataforma cria e lança novas marcas rapidamente.
MVP em semanas, não meses.
Branding diferenciado para cada vertical.
Mesmo código, mesma infraestrutura.
```

### Franquias / Redes

```text
Rede com unidades próprias e franqueadas.
Marca corporativa central.
Submarcas por região ou perfil.
Configuração centralizada, execução local.
```

---

## Integrações

```text
MD-094 White-Label-Architecture
MD-017 Multi-Tenant
MD-014 App-Registry
MD-020 Portal-Core-Architecture
MD-013 Frontend-Shell
MD-014 Design-System
MD-077 Subscription-Management
MD-075 Marketplace-Seller-Hub
MD-018 DenormalizacaoDispersao
```

---

## Regras

1. Marca é registrada no Brand Registry.
2. Slug de marca é único globalmente.
3. Feature flags são avaliadas por marca, não por tenant isolado.
4. Domínio customizado no White Label prioriza marca.
5. Cada marca pode ter marketplace próprio.
6. Pricing pode ser por marca, por tenant, por usuário ou combinado.
7. Dados são isolados por tenant, não por marca.

---

## Lei

```text
Marca posiciona.
Tenant ocupa.
Plataforma executa.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Brand Registry canônico
Feature flags por marca
Catálogo de apps por marca
Motor de pricing por marca
Isolamento de dados por tenant
Experiência brand-consistente
```

Times de produtos são responsáveis por:

```text
Definir posicionamento por marca
Decidir features por marca
Aprovar pricing e bundles
Manter consistência de experiência
```

---

## Métricas

```text
Marcas registradas
Tenants por marca
Apps ativas por marca
Feature adoption por marca
Receita por marca
Churn por marca
NPS por marca
Market share por vertical
```
