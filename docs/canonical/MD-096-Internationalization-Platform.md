# MD-096 — Internationalization Platform

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Suportar múltiplos idiomas, formatações regionais e conformidades locais.

---

## Princípio Fundamental

```text
Plataforma nasce global.
Idioma, moeda e regra local
são configurações, não código.
```

---

## Idiomas Suportados

```text
pt-BR (padrão)
en-US
es-ES (América Latina)
fr-FR
Outros sob demanda
```

---

## Componentes

### Translation Engine

```text
Chaves de tradução centralizadas
Tradução padrão (pt-BR)
Traduções customizadas por tenant
Traduções contextuais (Health, Finance, Legal)
Pluralização e gênero
```

### Formatos Regionais

```text
Data e hora (DD/MM/YYYY vs MM/DD/YYYY)
Moeda (R$, US$, €)
Números (1.000,00 vs 1,000.00)
Telefone (formato nacional)
CPF/CNPJ vs SSN/EIN vs NIF
Endereço (CEP, estado, cidade)
```

### Conformidade Local

```text
LGPD (Brasil)
GDPR (Europa)
HIPAA (EUA saúde)
SOX (EUA financeiro)
PCI-DSS (pagamentos)
```

### RTL Support

```text
Árabe
Hebraico
Persa
```

---

## Arquitetura

```
i18n Platform
├── Translation Store
│   ├── Default (pt-BR)
│   ├── Tenant override
│   └── App override
├── Locale Engine
│   ├── Formatters
│   ├── Calendars
│   └── Currency
├── Compliance Layer
│   ├── Data residency
│   ├── Consent management
│   └── Right to erasure
└── Context Injection
    ├── User locale
    ├── Tenant locale
    └── App locale
```

---

## Integrações

```text
MD-014 Design-System
MD-013 Frontend-Shell
MD-020 Portal-Core-Architecture
MD-017 Multi-Tenant
MD-034 IAM
MD-035 Security-Trust-Architecture
MD-097 Compliance-Automation
MD-094 White-Label-Architecture
MD-095 Multi-Brand-Architecture
```

---

## Regras

1. Toda string visível ao usuário usa chave de tradução.
2. Hardcoded string é proibido em código de produção.
3. Tradução padrão é pt-BR.
4. Tenant pode fornecer traduções customizadas.
5. Formatação de data/moeda respeita locale do usuário.
6. Conformidade local é automática por tenant.
7. RTL é suportado para idiomas da direita para esquerda.

---

## Lei

```text
Sem tradução hardcoded.
Sem formato hardcoded.
Sem regra local hardcoded.
Tudo é configurável por locale.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Translation engine centralizado
Formatters por locale
Conformidade local por tenant
Tooling para atualização de traduções
Fallback strategies
```

Desenvolvedores são responsáveis por:

```text
Usar chaves de tradução
Não hardcodar strings
Fornecer contexto para tradutores
Atualizar chaves quando houver mudança
Testar em todos os locales suportados
```

---

## Métricas

```text
Idiomas suportados
Cobertura de tradução (% chaves traduzidas)
Traduções customizadas por tenant
Erros de locale por request
Conformidade local score
Tempo de adaptação para novo locale
Satisfação por região
```
