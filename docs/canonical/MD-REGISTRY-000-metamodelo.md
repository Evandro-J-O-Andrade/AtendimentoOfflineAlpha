# MD-REGISTRY-000 — Metamodelo de Registries (Registry Contract)

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Metamodelo base — definido UMA vez, especializado por todos os
registries (Capability, Runtime, API, Tool, Event, Domain...).
Origem: decisões consolidadas em MD/MAP/BR-REGISTRY-001/002.
```

---

## Registry Contract

Todo registry segue o MESMO contrato-base, definido uma vez e
especializado pelos próximos (API, Tool, Event, Domain...):

```text
REGISTRY-CONTRACT-BASE

Identidade     : codigo IMUTÁVEL (nunca vira V2 / Novo)
Estado         : status, versao
Semântica      : descricao, metadata (json)
Auditoria      : created_at, updated_at
Governança     : sujeito ao GATE-PLATFORM-001
Relacionamentos: exclusivamente por arestas
Origem         : REUSE | ADAPT | EXTEND | MERGE | PROPOSE
```

O campo **Origem** registra como o registry nasceu, reforçando a
rastreabilidade das decisões arquiteturais (Art. 72 — Banco quádrupla fonte).

Quem especializa (API, Tool, Event, Domain) herda este contrato
e adiciona apenas seus atributos e arestas específicos.

---

## Capability Contract (separado do Registry Contract)

Registry Contract define **COMO um objeto entra no catálogo**.
Capability Contract define **COMO uma capacidade é CONSUMIDA**.
São conceitos distintos; mantidos separados.

```text
CAPABILITY-CONTRACT
 entrada    : payload de entrada
 saida      : payload de saída
 permissao  : código(s) de permissão exigidos
 contexto   : escopo/contexto obrigatório
 erros      : contratos de erro (códigos + mensagens)
 eventos    : eventos gerados pela execução
```

Responde: "Como essa capacidade funciona?" — não "como existe".

---

## Discovery (Capability canônica, não apenas serviço/rota)

Discovery é uma **Capability canônica** (DISCOVERY) com seus
próprios Runtimes, APIs e Tools. Usa o mesmo pipeline constitucional:

```text
Capability DISCOVERY
   ├── Runtime  (Discovery Runtime)
   ├── API      (Discovery API)
   └── Tool     (Discovery Tool)
```

Habilita perguntas resolvidas pelo metamodelo:
- Descobrir Capabilities
- Descobrir Runtimes
- Descobrir APIs
- Descobrir Ferramentas
- Descobrir Eventos

```text
Capability Discovery
Runtime Discovery
API Discovery
Tool Discovery
Event Discovery
```

### Neutralidade do Discovery
```text
Discovery DESCUBRE capacidades; NUNCA decide execução.
Fluxo:
  Cliente → Discovery Capability → Resolver → Runtime
         → Master → Executor → SP
Discovery NUNCA é um Dispatcher disfarçado.
```

### Discovery Query — Contrato de Resposta (definir ANTES do SQL)
Entrada:
```text
tipo      : capability | runtime | tool | event | api
filtro    : dominio, status, tag
contexto  : tenant / unidade / perfil
permissao : códigos do consumidor
```
Saída:
```text
entidades_encontradas
relacoes
capabilities_disponiveis
proximos_caminhos   (Runtime → Contrato → Tool/API)
```
Exemplo (IA): "Quais capacidades para dispensação de medicamento?"
→ Discovery resolve Capability → Runtime → Contrato → Tool/API
  sem a IA conhecer tabelas.

---

## Responsabilidades (sem sobreposição)

| Componente | Responsabilidade                |
|------------|--------------------------------|
| Registry   | Persistir conhecimento canônico |
| Resolver   | Navegar e resolver conhecimento |
| Runtime    | Coordenar execução              |
| Master     | Orquestrar fluxo                |
| Executor   | Executar operação               |

---

## Camadas: Cliente → Discovery → Resolver → Registry

```text
Cliente
   ↓
Discovery   (Capability exposta ao consumidor)
   ↓
Resolver    (mecanismo de descoberta)
   ↓
Registry    (persistência de conhecimento)
```

Cada camada tem responsabilidade única.

---

## Resolver × Registry

```text
Registry  → GUARDA conhecimento (identidade, atributos, arestas)
Resolver  → CONSULTA conhecimento (resolve capability/runtime/tool)
```

A lógica de resolução NUNCA vive dentro do Registry.

---

## Aresta Canônica (reutilizável em todos os registries)

Toda aresta do metamodelo é cidadão de primeira classe:

```text
id
codigo
origem
destino
role
status
versao
metadata       (json)
effective_from (opcional — evolução / versionamento / migração)
effective_to   (opcional — descontinuação sem quebrar histórico)
relationship_status (opcional — ACTIVE / DEPRECATED / PLANNED /
                     EXPERIMENTAL / DISABLED; desliga relação sem apagar)
created_at
updated_at
```

---

## Origem deste Metamodelo (auditoria de governança)

```text
Banco Vivo        : ABSENT (sem tabela discovery / registry_contract / relationship_status)
Knowledge Graph   : ABSENT (sem contrato-base equivalente)
Canônicos        : ABSENT (sem Registry Contract / Discovery canônico prévios)
Decisão           : PROPOSE — nenhum artefato para REUSE/ADAPT.
```

O próprio metamodelo obedece ao GATE que define: até os
mecanismos de governança passam por
REUSE → ADAPT → EXTEND → MERGE → PROPOSE. Nada de crescer por
conveniência.

---

## GATE final de Registry (Etapa 2+)

Dois testes obrigatórios antes de aprovar materialização:

```text
CONSISTÊNCIA : para toda Capability, PRIMARY == 1
NAVEGAÇÃO    : dada qualquer Capability, o sistema descobre
               automaticamente Runtime → Master → Executor → SP
               → Evento → Auditoria, sem configuração manual.
```

Se NAVEGAÇÃO passar, o metamodelo realmente governa a plataforma.
