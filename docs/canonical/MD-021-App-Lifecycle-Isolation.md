# MD-021 — App Lifecycle & Isolation Engine

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o ciclo de vida completo de aplicações registradas no Portal e o isolamento obrigatório entre apps, garantindo segurança, performance e governança em ambiente multi-tenant.

---

## Princípio Fundamental

```text
Nenhuma aplicação executa sem estar registrada.
Nenhuma aplicação compartilha estado com outra.
Nenhuma aplicação acessa recursos fora do seu contexto.
```

---

## Ciclo De Vida De Aplicação

### 1. REGISTER

App é registrada no App Registry com metadados canônicos:

```json
{
  "codigo": "FARMACIA",
  "nome": "Farmácia",
  "dominio": "FARMACIA",
  "rota": "/apps/farmacia",
  "contexto_obrigatorio": true,
  "auth_required": true,
  "permissoes": ["FARMACIA.ACESSAR"],
  "sp_namespace": "FARMACIA",
  "event_namespace": "FARMACIA",
  "runtime_mode": "MODULE_FEDERATION",
  "tenant_scope": "MULTI_TENANT",
  "isolamento": "SANDBOX"
}
```

### 2. RESOLVE

Portal resolve app a partir do Registry:

- Valida código único
- Valida tenant ativo
- Valida permissões do usuário
- Carrega metadados de UI
- Verifica modo de execução

### 3. LOAD

App é carregada conforme runtime_mode:

- MODULE_FEDERATION: remote module via webpack
- IFRAME: isolated iframe com postMessage
- MODULE: bundle estático lazy-loaded

### 4. MOUNT

App é montada no container do Portal:

- Injeção de contexto operacional
- Injeção de permissões
- Inicialização de providers canônicos
- Conexão com Dispatcher
- Conexão com Event Store

### 5. EXECUTE

App executa ações exclusivamente via Dispatcher:

- Payload validado
- Contexto injetado
- Permissões validadas
- SP executada
- Evento gerado

### 6. UNMOUNT

App é desmontada:

- Fecha conexões
- Limpa estado local
- Flush de eventos pendentes
- Libera recursos

### 7. EVENT_FLUSH

Eventos gerados durante execução são persistidos:

- Event Store canônica
- Auditoria obrigatória
- Reconciliação quando necessário

---

## Isolamento

### Isolamento De Memória

```text
Cada app executa em sandbox próprio.
Estado não é compartilhado entre apps.
Cache é segregado por app.
Variáveis globais são proibidas.
```

### Isolamento De Contexto

```text
Contexto operacional é injetado, não acessado diretamente.
App não acessa contexto de outra app.
App não modifica contexto global.
```

### Isolamento De Estado

```text
Estado local da app não vaza para outras apps.
Estado é limpo no unmount.
Persistência é via Event Store, não estado compartilhado.
```

### Isolamento De Permissões

```text
App recebe apenas permissões do Registry.
App não eleva próprias permissões.
App não acessa funcionalidades não declaradas.
```

### Isolamento De Tenant

```text
App opera apenas dentro do tenant do usuário.
App não acessa dados de outros tenants.
App não persiste dados cross-tenant.
```

---

## Modos De Execução

### MODULE_FEDERATION

```text
Webpack Module Federation
Carregamento dinâmico de módulos
Compartilhamento de dependências controlado
Isolamento via boundaries
```

### IFRAME

```text
Isolamento forte via iframe
Comunicação via postMessage
Validação de origem obrigatória
Sanitização de mensagens
```

### MODULE

```text
Bundle estático incluído no shell
Lazy loading via import()
Tree-shaking obrigatório
Isolamento via escopo de módulo
```

---

## Contratos Obrigatórios

Toda app deve implementar:

```typescript
interface AppContract {
  codigo: string;
  nome: string;
  versao: string;
  init(contexto: ContextoOperacional): void;
  execute(acao: string, payload: any): Promise<Resultado>;
  dispose(): void;
  metadados: AppMetadata;
}
```

### AppMetadata

```typescript
interface AppMetadata {
  permissoes: string[];
  sp_namespace: string;
  event_namespace: string;
  contexto_obrigatorio: boolean;
  runtime_mode: RuntimeMode;
  dashboards: string[];
}
```

---

## Integração Com Dispatcher

App executa ações exclusivamente via Dispatcher:

```json
{
  "app": "FARMACIA",
  "versao": "1.0.0",
  "acao": "DISPENSAR_MEDICAMENTO",
  "payload": {
    "id_paciente": 0,
    "id_medicamento": 0,
    "quantidade": 1
  },
  "contexto": {
    "id_tenant": 0,
    "id_unidade": 0,
    "id_local": 0,
    "id_perfil": 0
  }
}
```

Dispatcher responsável por:

- Validar app registrada
- Validar versão da app
- Validar permissões
- Validar contexto
- Rotear para SP correta
- Registrar evento

---

## Integração Com Event Store

Toda execução de app gera evento:

```json
{
  "evento_uuid": "UUID",
  "uuid_transacao": "UUID",
  "dominio": "FARMACIA",
  "acao": "DISPENSAR_MEDICAMENTO",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "app_versao": "1.0.0",
  "payload": {},
  "resultado": {},
  "timestamp": "datetime"
}
```

---

## Monitoramento De Apps

### Métricas Obrigatórias

```text
Tempo de carregamento
Tempo de inicialização
Taxa de erro
Tempo de resposta do Dispatcher
Cache hit rate
Eventos gerados
Sincronizações pendentes
```

### Health Check

```text
App responde /health
Registry valida app ativa
Dispatcher valida comunicação
Event Store valida registro
```

---

## Regras

1. Toda app passa por todas as fases do lifecycle.
2. Nenhuma app executa sem estar registrada e ativa.
3. Nenhuma app compartilha estado com outra app.
4. Nenhuma app acessa banco diretamente.
5. Nenhuma app bypassa o Dispatcher.
6. Nenhuma app gera evento fora do Event Store canônico.
7. Nenhuma app modifica contexto de outra app.
8. Nenhuma app acessa dados de outro tenant.
9. Toda app implementa interface canônica.
10. Toda app suporta unmount limpo.

---

## Proibições

São proibidos:

```text
App sem contrato canônico
App carregada por import direto sem Registry
Estado compartilhado entre apps
Acesso a banco direto por app
Bypass do Dispatcher
Evento gerado fora do Event Store
Contexto modificado por app
Permissão elevada por app
Dados de tenant acessados por app diferente
Comunicação direta entre apps sem Dispatcher
Cache compartilhado sem segregação
Variável global entre apps
```

---

## Lei Do Lifecycle Engine

```text
App nasce no Registry.
App executa isolada.
App morre no Unmount.
Nada sobrevive entre apps.
```

---

## Responsabilidades

Time De Plataforma É Responsável Por:

```text
Implementar lifecycle engine
Manter registry loader
Garantir isolamento entre apps
Manter contratos canônicos
Documentar modos de execução
Monitorar saúde das apps
Gerenciar versões de apps
```

Times De Aplicação São Responsáveis Por:

```text
Implementar contrato canônico
Respeitar isolamento
Usar Dispatcher para todas as ações
Gerar eventos via Event Store
Reportar problemas de lifecycle
Seguir padrões de runtime
NÃO compartilhar estado
NÃO acessar recursos de outras apps
