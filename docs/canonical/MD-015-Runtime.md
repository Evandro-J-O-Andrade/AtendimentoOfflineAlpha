# MD-015 — Runtime

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a camada de execução local da plataforma, garantindo operação offline-first, sincronização, cache e reconciliação com o núcleo central.

---

## Princípio Fundamental

```text
A operação continua funcionando mesmo sem internet.
Sincronização é automática quando a conexão retorna.
O estado local converge com o central.
```

---

## Fluxo Canônico

```
Central
  ↓
Runtime Local
  ↓
Operação Local (offline-first)
  ↓
Fila De Sincronização
  ↓
Worker De Sincronização
  ↓
Reconciliação
  ↓
Estado Consistente
```

---

## Estrutura Física

```
runtime/
  core/
    __init__.py
    runtime.py
    ciclo.py
    estado.py
  fila/
    __init__.py
    fila.py
    item.py
    prioridade.py
  sincronizador/
    __init__.py
    sincronizador.py
    worker.py
    politica.py
  reconciliador/
    __init__.py
    reconciliador.py
    conflito.py
    merge.py
  cache/
    __init__.py
    cache.py
    estrategia.py
    invalidacao.py
  offline/
    __init__.py
    detector.py
    fila_offline.py
  edge/
    __init__.py
    gateway.py
    proxy.py
```

---

## Capacidades

### Operação Offline-First

```text
Toda ação é executada localmente primeiro.
Dados críticos permanecem acessíveis sem rede.
Interface responde sem esperar sincronização.
Usuário não percebe indisponibilidade de rede.
```

### Fila De Sincronização

```text
Ações realizadas offline são enfileiradas.
Fila é persistente e resistente a falhas.
Itens contêm payload, timestamp, tentativas e estado.
Fila é processada em ordem ou por prioridade.
Itens com falha são retentados com backoff exponencial.
```

### Cache Inteligente

```text
Dados de leitura frequente são cacheados.
Cache respeita tenant e contexto operacional.
Cache é invalidado por eventos do Event Store.
Cache possui TTL e stale-while-revalidate.
```

### Reconciliação

```text
Conflitos entre estado local e central são detectados.
Estratégias de merge: last-write-wins, operação-vence, manual.
Conflitos irresolúveis são registrados para revisão humana.
Auditoria completa de todas as reconciliações.
```

---

## Arquitetura De Estado Local

### Camadas

```
Dados Centrais
  ↓ (sincronização)
Cache Local
  ↓
Runtime
  ↓
Interface
```

### Estado Local Mantém

```text
Sessão ativa
Contexto operacional selecionado
Dados de domínio acessados recentemente
Fila de ações pendentes
Cache de consultas frequentes
Estado de formulários em andamento
Configurações do usuário
```

### Estado Local NÃO Mantém

```text
Dados de outros tenants
Regras de negócio fora do contexto do usuário
Eventos de outros usuários
Auditoria de outros tenants
Segredos em texto plano
```

---

## Fluxo De Operação

```
Usuário Executa Ação
  ↓
Runtime Verifica Conectividade
  ↓
ONLINE:
  Dispatcher → SP → Evento → Confirma

OFFLINE:
  Runtime Valida Contexto E Permissão
  Runtime Executa Localmente (SP ou regra limitada)
  Runtime Registra Ação Na Fila
  Runtime Atualiza Cache E Interface
  Retorna Sucesso Ao Usuário

RECONEXÃO:
  Worker Processa Fila
  Reconciliador Aplica Mudanças
  Event Store Registra Ações Reconciliadas
  Cache é Atualizado
  Interface é Sincronizada
```

---

## Regras

1. Toda ação executada offline gera entrada na fila de sincronização.
2. Nenhuma ação offline é executada sem validação de sessão e contexto.
3. Fila de sincronização é persistente e não pode ser limpa sem processamento.
4. Worker de sincronização é resiliente a falhas e reinícios.
5. Reconciliação registra todas as operações, mesmo conflitos.
6. Cache nunca substitui a fonte de verdade, apenas acelera leitura.
7. Dados conflitantes nunca são sobrescritos sem registro.
8. Runtime não executa ações destrutivas sem confirmação quando online.
9. Runtime respeita permissões do usuário mesmo em modo offline.
10. Runtime opera dentro do tenant e contexto do usuário autenticado.

---

## Sincronização

### Estratégias

```text
Push imediato: ações online são enviadas assim que executadas.
Pull sob demanda: dados são atualizados quando necessário.
Pull periódico: atualizações automáticas em intervalo configurado.
Event-driven: sincronização disparada por eventos relevantes.
```

### Estado Da Sincronização

```text
Pendente: aguardando processamento
Em andamento: sendo enviada ao central
Confirmada: central processou com sucesso
Conflito: requer reconciliação
Falha: erro de comunicação ou processamento
Arquivada: processada, mantida para auditoria
```

### Retry E Backoff

```text
Tentativa imediata
Backoff exponencial até limite máximo
Priorização por criticidade da ação
Notificação ao usuário após falhas recorrentes
Dead-letter queue para ações irrecuperáveis
```

---

## Reconciliação

### Tipos De Conflito

```text
Conflito de versão: mesmo registro alterado em dois lugares
Conflito de existência: registro criado local e já existe no central
Conflito de estado: status conflitante entre local e central
Conflito de permissão: ação executada localmente sem permissão no central
```

### Estratégias De Resolução

```text
Automática: quando há regra clara de precedência
Manual: quando requer decisão humana
Merge: quando dados podem ser combinados
Overwrite: quando política define qual versão vence
```

### Registro De Reconciliação

Toda reconciliação gera evento canônico:

```json
{
  "evento_uuid": "UUID",
  "uuid_transacao": "UUID",
  "dominio": "RUNTIME",
  "acao": "RUNTIME_RECONCILIACAO",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "payload": {
    "tipo_conflito": "VERSAO",
    "acao_origem": "LOCAL",
    "resultado": "AUTO_MERGE",
    "registros_afetados": 1
  },
  "resultado": {"sucesso": true},
  "timestamp": "datetime"
}
```

---

## Auditoria

Runtime registra:

```text
Início e fim de sessão offline
Ações executadas localmente
Tentativas de sincronização
Conflitos detectados
Resoluções aplicadas
Falhas de reconciliação
Estado da fila
Métricas de conectividade
```

---

## Integração Com Outros Módulos

- Auth: Runtime mantém sessão válida mesmo offline.
- Dispatcher: Runtime precisa de Dispatcher quando online; executa localmente quando offline.
- Event Store: Runtime alimenta Event Store com ações locais e reconciliações.
- App Registry: Runtime consome Registry para validar aplicações disponíveis offline.
- Security: Runtime não reduz validações de segurança; offline não significa sem regras.

---

## Proibições

São proibidos:

```text
Ação offline sem validação de sessão
Ação offline sem validação de contexto
Fila de sincronização sem persistência
Sincronização silenciosa sem registro
Cache substituindo fonte de verdade
Delete sem confirmação em modo offline
Conflito sobrescrito sem registro
Runtime reduzindo permissões offline
Segredos armazenados em cache local
Sincronização ignorando multi-tenant
```

---

## Lei Do Runtime

```text
Offline não significa sem regras.
Local não significa isolado.
Sincronização não é opcional.
Conflito não é erro, é estado.
```

---

## Responsabilidades

Time De Plataforma É Responsável Por:

```text
Implementar Runtime canônico
Manter fila, cache e sincronizador
Garantir reconciliação confiável
Documentar políticas de conflito
Monitorar saúde da sincronização
Manter compatibilidade com versões antigas do client
```

Times De Aplicação São Responsáveis Por:

```text
Declarar se aplicação suporta offline
Implementar handlers para ações offline
Definir estratégia de reconciliação específica
Reportar conflitos recorrentes
Respeitar limitações do runtime em modo offline
NÃO confiar apenas em estado local para decisões críticas
