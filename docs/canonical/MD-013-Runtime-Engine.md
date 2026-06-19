# MD-013 — Runtime Engine

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a camada de execução local e sincronização da plataforma, garantindo operação offline-first, fila de ações, reconciliação e integração com o núcleo central.

---

## Princípio Fundamental

```text
A operação continua funcionando mesmo sem internet.
Sincronização é automática quando a conexão retorna.
O estado local converge com o central.
```

---

## Camadas Do Runtime

### Runtime Local

```text
Responsável por executar ações localmente.
Gerencia estado da aplicação.
Controla fila de sincronização.
Mantém cache de dados frequentes.
```

### Fila De Ações

```text
Ações realizadas offline são enfileiradas.
Fila é persistente e resistente a falhas.
Itens contêm payload, timestamp, tentativas e estado.
Processamento em ordem ou por prioridade.
Retry com backoff exponencial.
```

### Worker De Sincronização

```text
Processa fila quando conectado.
Envia ações ao central.
Confirma recebimento.
Trata conflitos.
Atualiza estado local.
```

### Reconciliação

```text
Conflitos entre estado local e central são detectados.
Estratégias: last-write-wins, operação-vence, manual.
Conflitos irresolúveis são registrados para revisão.
Auditoria completa de reconciliações.
```

### Cache Inteligente

```text
Dados de leitura frequente são cacheados.
Cache respeita tenant e contexto.
Invalidado por eventos do Event Store.
TTL e stale-while-revalidate.
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

## Estados De Sincronização

| Estado | Significado |
|--------|-------------|
| PENDENTE | Aguardando processamento |
| EM_ANDAMENTO | Sendo enviada ao central |
| CONFIRMADA | Central processou com sucesso |
| CONFLITO | Requer reconciliação |
| FALHA | Erro de comunicação ou processamento |
| ARQUIVADA | Processada, mantida para auditoria |

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

## Estratégias De Sincronização

### Push Imediato
Ações online são enviadas assim que executadas.

### Pull Sob Demanda
Dados são atualizados quando necessário.

### Pull Periódico
Atualizações automáticas em intervalo configurado.

### Event-Driven
Sincronização disparada por eventos relevantes.

---

## Retry E Backoff

```text
Tentativa imediata
Backoff exponencial até limite máximo
Priorização por criticidade da ação
Notificação ao usuário após falhas recorrentes
Dead-letter queue para ações irrecuperáveis
```

---

## Reconciliação De Conflitos

### Tipos

```text
Conflito de versão: mesmo registro alterado em dois lugares
Conflito de existência: registro criado local e já existe no central
Conflito de estado: status conflitante entre local e central
Conflito de permissão: ação executada localmente sem permissão no central
```

### Estratégias

```text
Automática: quando há regra clara de precedência
Manual: quando requer decisão humana
Merge: quando dados podem ser combinados
Overwrite: quando política define qual versão vence
```

---

## Integração Com Outros Módulos

- Auth: Runtime mantém sessão válida mesmo offline.
- Dispatcher: Runtime precisa de Dispatcher quando online; executa localmente quando offline.
- Event Store: Runtime alimenta Event Store com ações locais e reconciliações.
- App Registry: Runtime consome Registry para validar aplicações disponíveis offline.
- Security: Runtime não reduz validações de segurança.

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












