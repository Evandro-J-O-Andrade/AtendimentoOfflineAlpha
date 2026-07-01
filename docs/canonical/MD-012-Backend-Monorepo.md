# MD-012 — Backend Monorepo

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a estrutura física definitiva do backend, eliminando pastas genéricas e garantindo que cada camada tenha responsabilidade única e localização canônica.

---

## Estrutura Física

```
backend/
  apps/
    portal/
      __init__.py
      routes.py
      handlers.py
    auth/
      __init__.py
      routes.py
      handlers.py
    dispatcher/
      __init__.py
      routes.py
      handlers.py
    runtime/
      __init__.py
      routes.py
      handlers.py
  kernel/
    __init__.py
    sessao.py
    contexto.py
    permissao.py
    tenant.py
    evento.py
  domains/
    his/
      __init__.py
      routes.py
      handlers.py
    pdv/
      __init__.py
      routes.py
      handlers.py
    crm/
      __init__.py
      routes.py
      handlers.py
    sac/
      __init__.py
      routes.py
      handlers.py
    cat/
      __init__.py
      routes.py
      handlers.py
    farmacia/
      __init__.py
      routes.py
      handlers.py
    estoque/
      __init__.py
      routes.py
      handlers.py
    faturamento/
      __init__.py
      routes.py
      handlers.py
    bi/
      __init__.py
      routes.py
      handlers.py
    financeiro/
      __init__.py
      routes.py
      handlers.py
    admin/
      __init__.py
      routes.py
      handlers.py
  dispatcher/
    __init__.py
    core.py
    roteador.py
    validador.py
    resposta.py
  auth/
    __init__.py
    core.py
    jwt.py
    sessao.py
    permissao.py
  eventstore/
    __init__.py
    core.py
    escritor.py
    leitor.py
    replay.py
  runtime/
    __init__.py
    core.py
    fila.py
    sincronizador.py
    reconciliador.py
  analytics/
    __init__.py
    core.py
    ingestao.py
    calculo.py
    warehouse.py
  ai/
    __init__.py
    gateway.py
    agentes.py
    orquestrador.py
  webhooks/
    __init__.py
    core.py
    validador.py
    registro.py
  infrastructure/
    database/
      conexao.py
      repositório.py
    cache/
      core.py
      redis.py
    mensageria/
      core.py
      fila.py
    storage/
      core.py
      armazenamento.py
  shared/
    contratos/
      dispatcher.py
      evento.py
      contexto.py
      auth.py
    utilitarios/
      data.py
      validacao.py
      criptografia.py
      uuid.py
  database/
    sps/
      auth/
      dispatcher/
      eventstore/
      runtime/
      his/
      pdv/
      ...
    migracoes/
      v001__inicial.sql
      v002__auth.sql
      v003__dispatcher.sql
      ...
  tests/
    unitarios/
    integracao/
    contrato/
```

---

## Camadas E Responsabilidades

### apps/

Aplicações HTTP registradas. Cada uma com suas rotas e handlers.

```text
Responsabilidade: Receber requisição HTTP, validar entrada, chamar camada de domínio.

NÃO contém regra de negócio.
NÃO contém SQL.
NÃO contém lógica de domínio.
```

### kernel/

Núcleo canônico da plataforma. Entidades e lógicas que pertencem à plataforma, não a domínios específicos.

```text
Responsabilidade: Implementar entidades raiz e lógicas transversais.

Exemplos: Sessão, Contexto, Permissão, Tenant, Evento, Pessoa, Usuário.
```

### domains/

Domínios de aplicação. Cada pasta é uma aplicação registrada no App Registry.

```text
Responsabilidade: Implementar regras específicas do domínio através de chamadas a SPs.

Cada domínio é isolado.
Cada domínio compartilha kernel.
Cada domínio usa dispatcher, auth e eventstore canônicos.
```

### dispatcher/

Dispatcher canônico central.

```text
Responsabilidade: Ponto único de entrada de ações executáveis.

Valida sessão, contexto, permissão.
Roteia para SP correta.
Registra evento.
Retorna resposta padronizada.
```

### auth/

Camada de autenticação e autorização canônica.

```text
Responsabilidade: Identidade, sessão, permissões, perfis, tenant.

Compartilhada por toda a plataforma.
Nenhum domínio duplica auth.
```

### eventstore/

Event Store canônica.

```text
Responsabilidade: Registrar todo evento relevante da plataforma.

Garantir imutabilidade.
Garantir rastreabilidade.
Garantir uuid_transacao.
```

### runtime/

Runtime de execução local e sincronização.

```text
Responsabilidade: Operação offline, fila local, sincronização, reconciliação.

Suporta operação sem conectividade.
Sincroniza quando online.
```

### analytics/

Camada analítica corporativa.

```text
Responsabilidade: Ingestão de eventos, cálculo de KPIs, Data Warehouse.

Consolida métricas de todas as aplicações.
Isolado de operações transacionais.
```

### ai/

Camada de IA e orquestração.

```text
Responsabilidade: Gateway de IA, agentes, workflows N8N.

IA não acessa banco diretamente.
IA executa via Dispatcher.
Toda ação de IA gera evento.
```

### webhooks/

Gerenciamento de webhooks.

```text
Responsabilidade: Receber, validar e processar webhooks externos.

Valida assinatura.
Valida timestamp e nonce.
Registra execução no Event Store.
```

### infrastructure/

Infraestrutura técnica transversal.

```text
Responsabilidade: Conexões, cache, mensageria, storage.

Implementações técnicas reutilizáveis.
Nenhuma regra de negócio aqui.
```

#### Horizontal Scaling (MAP-021)
```text
Load Balancer (L7) distribui requisições entre instâncias API stateless.
Cada API lê/escreve estado via runtime_* tables no MySQL.
Workers consomem runtime_execution_queue independentemente da origem.
Escala horizontal não requer sync de estado - todos compartilham o mesmo DB.
```

### shared/

Código compartilhado entre camadas.

```text
Responsabilidade: Contratos, DTOs, utilitários.

Contratos são imutáveis após publicados.
Utilitários são puramente funcionais quando possível.
```

### database/

Banco de dados e stored procedures.

```text
Responsabilidade: Schema, SPs, migrações.

SPs são a camada oficial de execução.
Migrações são versionadas e imutáveis após aplicadas.
```

### tests/

Testes organizados por tipo.

```text
Responsabilidade: Garantir qualidade e conformidade.

Unitários: lógica pura.
Integração: fluxos entre camadas.
Contrato: conformidade com MDs canônicos.
```

---

## Regras De Organização

1. Nenhuma pasta nova é criada sem antes verificar se já existe local canônica no monolito.
2. Domínios são módulos isolados, não pastas soltas.
3. Cada domínio tem seu próprio `__init__.py`, `routes.py`, `handlers.py`.
4. Nenhum domínio acessa banco diretamente.
5. Nenhum domínio contém regra de negócio fora de SPs.
6. Dispatcher é único, central, compartilhado.
7. Event Store é única, central, compartilhada.
8. Auth é único, central, compartilhado.
9. Cada pasta possui README.md explicando sua responsabilidade.
10. Estrutura é espelhada entre backend novos e legacy até migração completa.

---

## Padrões De Código

### Backend Fino

```text
Backend é um roteador inteligente.

Recebe requisição.
Valida entrada.
Chama SP via Dispatcher.
Registra evento.
Retorna resposta.

Regra de negócio está na SP.
```

### Nomes De Arquivos

```text
Python: snake_case
SQL: snake_case
JSON: camelCase (para contratos externos)
Rotas: kebab-case na URL, snake_case no código
```

### Imports

```text
Imports absolutos preferidos.
Imports relativos evitados.
Imports organizados: stdlib, third-party, local.
```

---

## Integração Com Legacy

1. Legacy permanece em `/legacy` até completa migração.
2. Legacy gradualmente adota contratos de `backend/shared/contratos/`.
3. Legacy expõe endpoints apenas através do Dispatcher canônico.
4. Nenhum endpoint novo é criado no legacy após congelamento dos MDs.
5. Novas funcionalidades são implementadas em `backend/` seguindo a estrutura canônica.

---

## Proibições

São proibidos:

```
Pasta src/ genérica
Pasta routes/ genérica
Pasta services/ genérica
Pasta controllers/ genérica
Pasta helpers/ genérica
SQL direto em handlers
Regra de negócio em handlers
Dispatcher por domínio
Auth por domínio
Event Store por domínio
Novo domínio sem pasta em backend/domains/
Novo domínio sem entrada no App Registry
Nomes de pasta em camelCase ou PascalCase
```

---

## Lei Da Estrutura Física

```text
Toda funcionalidade tem lugar canônico.
Toda pasta tem responsabilidade única.
Nenhuma regra de negócio vive fora de SPs.
```

---

## Responsabilidades

Time De Plataforma É Responsável Por:

```text
Manter estrutura canônica do backend
Definir padrões de código
Aprovar novas pastas e módulos
Garantir conformidade com MDs
Manter contratos compartilhados
```

Time De Domínio É Responsável Por:

```text
Implementar domínio na pasta canônica
Seguir padrões de código
Utilizar dispatcher, auth e eventstore canônicos
NÃO criar estruturas paralelas
NÃO duplicar funcionalidades do kernel
