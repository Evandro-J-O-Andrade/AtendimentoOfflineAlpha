# MAP-001 — Enterprise Domain Architecture

## Status
Documento Canônico de Arquitetura.
Fundamento da arquitetura corporativa.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir a decomposição oficial dos domínios da Plataforma Midas, estabelecendo fronteiras arquiteturais, responsabilidades, contratos de comunicação e regras de isolamento.

---

## Problema que Resolve
```text
Acoplamento entre módulos

Dependências circulares

Acesso direto entre bancos

Duplicação de regras

Mistura de responsabilidades

Monólitos acidentais
```

---

## Lei Canônica MAP-001-001
```text
Todo domínio é proprietário exclusivo
dos seus dados e regras.
```

---

## Lei Canônica MAP-001-002
```text
Nenhum domínio pode acessar
diretamente tabelas internas
de outro domínio.
```

---

## Lei Canônica MAP-001-003
```text
Integração ocorre apenas por:

API
Evento
Serviço Compartilhado Oficial
```

---

## Lei Canônica MAP-001-004
```text
Banco de dados não é contrato.
```

---

## Macro Arquitetura
```text
Platform Core
│
├── IAM
├── Portal
├── AI
├── Analytics
├── Integration
│
├── HIS
├── CRM
├── RH
├── Finance
│
├── Social
├── Chat
├── AVA
├── Documents
│
└── Marketplace
```

---

## Classificação dos Domínios

### Core Domains
Representam o valor principal da plataforma.
```text
HIS
CRM
RH
Finance
```

### Supporting Domains
Suportam os domínios principais.
```text
Documents
Workflow
Chat
Social
AVA
```

### Generic Domains
Infraestrutura corporativa.
```text
IAM
AI
Portal
Analytics
Integration
Marketplace
```

---

## Bounded Contexts Oficiais

### IAM
Responsável por:
```text
Identidade
Login
Sessão
Permissões
Policies
Contexto
```
Não responsável por:
```text
Dados clínicos
Dados financeiros
Dados comerciais
```

### Portal
Responsável por:
```text
Home
Dashboard
Widgets
Navegação
Apps
```

### HIS
Responsável por:
```text
Senha
Fila
FFA
Atendimento
Prontuário
Farmácia
Internação
Faturamento Assistencial
```

### CRM
Responsável por:
```text
Lead
Contato
Conta
Oportunidade
Contrato
```

### RH
Responsável por:
```text
Colaborador
Escala
Treinamento
Avaliação
```

### Financeiro
Responsável por:
```text
Contas
Receitas
Pagamentos
Custos
Repasses
```

---

## Modelo de Comunicação

### Comunicação Síncrona
Utilizada quando:
```text
Necessidade imediata
Validação online
Consulta instantânea
```
Tecnologias:
```text
REST
gRPC
```

### Comunicação Assíncrona
Utilizada quando:
```text
Integração
Escalabilidade
Desacoplamento
```
Tecnologias:
```text
RabbitMQ
Kafka
Redis Streams
```

---

## Contrato de Eventos Corporativos
Eventos devem representar fatos consumados.

### Correto
```text
SenhaCriada
AtendimentoIniciado
DocumentoAprovado
TreinamentoConcluido
```

### Incorreto
```text
CriarSenha
ExecutarAtendimento
AprovarDocumento
```

---

## Arquitetura de Persistência

### Lei Oficial
```text
Cada domínio possui
sua própria camada de persistência.
```

### Regra SP-First
Toda operação crítica passa por:
```text
Stored Procedure
```

### Proibido
```text
UPDATE direto
DELETE direto
INSERT direto
```
em entidades críticas.

---

## Observabilidade Obrigatória
Cada domínio deve expor:
```text
Health Check
Logs
Métricas
Tracing
Eventos
```

---

## Segurança Obrigatória
Toda requisição deve validar:
```text
Tenant
Usuário
Sessão
Contexto
Role
Permission
Policy
```

---

## Escalabilidade
Todo domínio deve permitir:
```text
Horizontal Scale
Cache
Filas
Processamento Assíncrono
Retry
```

---

## Anti-Corruption Layer
Integrações externas nunca acessam diretamente o domínio.
Devem passar por:
```text
Connector
Adapter
Translator
Validator
```

---

## Governança
Todo domínio deve possuir:
```text
Owner Técnico
Owner Negócio
Versionamento
Documentação
Métricas
```

---

## Integrações
| MD | Finalidade |
|----|-----------|
| MD-100 — Unified Enterprise OS | Plataforma |
| MD-101 — Canonical Data Architecture | Dados |
| MD-107 — Tenant Architecture | Tenant |
| MD-110 — Canonical Laws | Leis |
| MD-065 — Observability Platform | Observability |
| MD-089 — Workflow Fabric | Workflow |
| MAP-021 — Platform Infrastructure Domain | Infraestrutura, Load Balancer, API Pool |