# 🏥 Pronto Atendimento Alpha- Comando de Prontuário Médico Profissional

> **Sistema de Gestão de Pronto Atendimento e UPA (Unidade de Pronto Atendimento)**

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-18+-blue.svg)](https://react.dev/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-orange.svg)](https://www.mysql.com/)
[![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow.svg)]()

---

## 📋 Sumário

1. [Visão Geral do Sistema](#visão-geral-do-sistema)
2. [Lei Canônica do Sistema](#lei-canônica-do-sistema)
3. [Tecnologias Utilizadas](#tecnologias-utilizadas)
4. [Arquitetura do Sistema](#arquitetura-do-sistema)
5. [Módulos e Funcionalidades](#módulos-e-funcionalidades)
6. [Estrutura do Projeto](#estrutura-do-projeto)
7. [Banco de Dados](#banco-de-dados)
8. [Instalação e Configuração](#instalação-e-configuração)
9. [Credenciais de Teste](#credenciais-de-teste)
10. [Fluxo de Atendimento](#fluxo-de-atendimento)
11. [Documentação Adicional](#documentação-adicional)
12. [Roadmap de Implementação](#roadmap-de-implementação)

---

## 🎯 Visão Geral do Sistema

O **CMDPro (Comando de Prontuário Médico Profissional)** é uma plataforma completa de gestão de atendimento hospitalar offline-first, projetada para unidades de pronto atendimento (UPA) e hospitais de médio porte. O sistema orchestrar todo o fluxo de atendimento ao paciente, desde a emissão de senhas até o faturamento SUS.

### Objetivos Principais

| Objetivo | Descrição |
|----------|-----------|
| **Gestão de Filas** | Controle de senhas e filas por setor com prioridades |
| **Atendimento Clínico** | Registro completo do atendimento médico com prescrições |
| **Farmácia** | Dispensação de medicamentos integrada com controle de estoque |
| **Faturamento SUS** | Geração de protocolos e integração com sistema SUS |
| **Offline-First** | Funcionamento sem conexão интернет constante |
| **Auditoria Completa** | Ledger de todos os eventos do sistema (LGPD) |
| **Multi-Unidade** | Suporte a múltiplas unidades e locais operacionais |

---

## ⚖️ Lei Canônica do Sistema

O sistema é governado por princípios arquiteturais fundamentais que definem seu comportamento:

### Princípios Fundamentais

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ARQUITETURA CANÔNICA                                │
│                    Frontend → API → sp_master_dispatcher                   │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENTRADA ÚNICA                                       │
│                      sp_master_dispatcher_runtime                          │
│                   (Ponto único de entrada para todas ações)               │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EXECUTORES ESPECIALIZADOS                           │
│   sp_executor_fila | sp_executor_triagem | sp_executor_medico             │
│   sp_executor_farmacia | sp_executor_estoque | sp_executor_painel          │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          BANCO DE DADOS                                     │
│                    MySQL com Stored Procedures                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Os 6 Motores do Sistema

| # | Motor | Função Principal | Componentes |
|---|-------|------------------|--------------|
| 1 | **KERNEL** | Orquestração central e dispatching | `sp_master_dispatcher`, `sp_kernel_*` |
| 2 | **IDENTIDADE** | Autenticação, sessão e contexto | `sp_auth_*`, `usuario`, `sessao_usuario` |
| 3 | **FLUXO CLÍNICO** | Gerenciamento de filas e senhas | `sp_senha_*`, `sp_fila_*`, `fila_operacional` |
| 4 | **FFA** | Ficha de Atendimento e clínico | `sp_ffa_*`, `atendimento`, `triagem` |
| 5 | **FARMÁCIA** | Dispensação e controle de estoque | `sp_farmacia_*`, `dispensacao_medicacao` |
| 6 | **FATURAMENTO** | Faturamento e protocolos SUS | `sp_protocolo_*`, `gpat_atendimento` |

### Regras da Lei Canônica

1. **Entrada Única**: Toda ação passa pelo `sp_master_dispatcher`
2. **Contexto Obrigatório**: Toda operação requer contexto (unidade, local, perfil)
3. **Idempotência**: Operações podem ser repetidas com mesmo resultado via `uuid_transacao`
4. **Auditoria**: Todo evento registrado em ledger
5. **Transação**: Operações críticas usam transações ACID
6. **Segurança em Camadas**: Múltiplos guardiões validam ações

---

## 🛠 Tecnologias Utilizadas

### Backend

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **Node.js** | 18+ | Runtime JavaScript server-side |
| **Express** | ^4.x | Framework web REST API |
| **MySQL** | 8.0+ | Banco de dados relacional (Oracle MySQL) |
| **mysql2** | ^3.x | Driver MySQL para Node.js |
| **jsonwebtoken** | ^9.x | Autenticação JWT |
| **bcryptjs** | ^2.x | Hash de senhas com salt |
| **cors** | ^2.x | Cross-Origin Resource Sharing |
| **dotenv** | ^16.x | Variáveis de ambiente |

### Frontend

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **React** | 18+ | Biblioteca UI |
| **Vite** | 5+ | Build tool e dev server |
| **React Router** | 6+ | Roteamento SPA |
| **Axios** | ^1.x | Client HTTP |
| **TailwindCSS** | 3+ | Framework CSS utilitário |
| **Lucide React** | ^0.x | Ícones |

### Banco de Dados

| Componente | Quantidade | Descrição |
|------------|------------|-----------|
| **Tabelas** | 450+ | Schema completo do sistema |
| **Stored Procedures** | 160+ | Lógica de negócio no banco |
| **Índices** | Múltiplos | Performance otimizada |
| **Functions** | 30+ | Funções auxiliares |

---

## 🏗 Arquitetura do Sistema

### Camadas da Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND                                  │
│  React + Vite + TailwindCSS + Axios                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           │
│  │ Recepção │ │ Triagem  │ │  Médico  │ │ Farmácia │           │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘           │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTP/REST
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         BACKEND                                  │
│              Node.js + Express + JWT Auth                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              ROTAS (Routes)                                 │ │
│  │  /api/auth/* | /api/fila/* | /api/triagem/* | /api/*      │ │
│  └────────────────────────────┬────────────────────────────────┘ │
│                               │                                    │
│                               ▼                                    │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │           MIDDLEWARES (Auth, Permission, Context)         │ │
│  └────────────────────────────┬────────────────────────────────┘ │
│                               │                                    │
│                               ▼                                    │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │        KERNEL GATEWAY (sp_master_dispatcher)              │ │
│  └────────────────────────────┬────────────────────────────────┘ │
│                               │                                    │
└───────────────────────────────┼────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BANCO DE DADOS                               │
│                    MySQL 8.0+                                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐            │
│  │   KERNEL     │ │  EXECUTORES  │ │    LEDGER    │            │
│  │  sp_master_* │ │ sp_executor* │ │ auditoria_*  │            │
│  └──────────────┘ └──────────────┘ └──────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

### Fluxo de Dados

1. **Requisição**: Frontend envia requisição HTTP com JWT
2. **Autenticação**: Middleware valida token JWT
3. **Autorização**: PermissionMiddleware verifica permissões
4. **Contexto**: RuntimeContextMiddleware carrega contexto do usuário
5. **Dispatch**: Requisição chega ao sp_master_dispatcher
6. **Execução**: Executor especializado processa a ação
7. **Auditoria**: Evento registrado no ledger
8. **Resposta**: Retorno para o frontend

---

## 📦 Módulos e Funcionalidades

### Módulo de Autenticação ✅

- [x] Login com usuário e senha
- [x] Logout com invalidação de sessão
- [x] Refresh token automático (15min access, 7d refresh)
- [x] Hash de senhas com bcrypt (salt 10)
- [x] Proteção de rotas via JWT
- [x] Contextos múltiplos por usuário (unidade, local, perfil)
- [x] Perfis e permissões granulares (RBAC)
- [x] Auditoria de login

### Módulo de Recepção ✅

- [x] Emissão de senhas (totem ou atendimento)
- [x] Busca de pacientes
- [x] Triagem inicial (classificação de risco)
- [x] Complementação de dados do paciente
- [x] Encaminhamento para setores
- [x] Abertura de FFA (Ficha de Atendimento)

### Módulo de Triagem ✅

- [x] Lista de senhas aguardando
- [x] Registro de sinais vitais (PA, temperatura, frequência cardíaca)
- [x] Classificação de risco (vermelho, laranja, amarelo, verde, azul)
- [x] Encaminhamento para médico

### Módulo Médico ✅

- [x] Receber paciente da triagem
- [x] Prescrição de medicamentos
- [x] Evolução clínica
- [x] Diagnóstico (CID-10)
- [x] Encaminhamento para farmácia/enfermagem
- [x] Alta ou internação

### Módulo de Farmácia ✅

- [x] Busca de prescrições por senha
- [x] Dispensação de medicamentos
- [x] Histórico de dispensação
- [x] Controle de estoque
- [x] GPAT (Gestão de Prescrição de Antimicrobianos)

### Módulo de Enfermagem ✅

- [x] Lista de pacientes
- [x] Registro de medicação administrada
- [x] Acompanhamento de evolução
- [x] Administração de medicamentos

### Módulo de Laboratório ✅

- [x] Pedido de exames
- [x] Coleta de amostras
- [x] Registro de resultados
- [x] Integração com análise clínica

### Módulo de Internação ✅

- [x] Gestão de leitos
- [x] Internação hospitalar
- [x] Evolução de internação
- [x] Alta hospitalar

### Módulo de Estoque ✅

- [x] Cadastro de produtos
- [x] Movimentação de estoque
- [x] Controle de validade
- [x] Alertas de estoque baixo

### Módulo de Ambulância ✅

- [x] Gestão de chamadas
- [x] Registro de ocorrências
- [x] Encaminhamento para atendimento

### Módulo de Painéis ✅

- [x] Painel de chamadas
- [x] Exibição de senhas por setor
- [x] Filas por local operacional
- [x] Configuração dinâmica

### Módulo de Totens ✅

- [x] Totem de senha autonomouso
- [x] Emissão de senhas por tipo (clínico, pediátrico, gyn)
- [x] Pesquisa de satisfação

---

## 📁 Estrura do Projeto

```
AtendimentoOfflineAlpha/
├── backend/                         # Servidor Node.js
│   ├── src/
│   │   ├── app.js                  # Express app principal
│   │   ├── auth/                   # Módulo de autenticação
│   │   │   ├── authController.js   # Controller de login
│   │   │   ├── authMiddleware.js   # Middleware JWT
│   │   │   ├── authRoutes.js       # Rotas de auth
│   │   │   ├── authService.js      # Lógica de auth
│   │   │   ├── permissionMiddleware.js
│   │   │   ├── permissionService.js
│   │   │   ├── runtimeContextMiddleware.js
│   │   │   └── loginContextService.js
│   │   ├── config/                 # Configurações
│   │   │   ├── database.js         # Pool MySQL
│   │   │   └── jwt.js              # Config JWT
│   │   ├── routes/                 # Rotas da API
│   │   │   ├── operacionalRoutes.js
│   │   │   ├── filaRoutes.js
│   │   │   ├── totemRoutes.js
│   │   │   ├── triagemRoutes.js
│   │   │   ├── farmaciaRoutes.js
│   │   │   ├── painelRoutes.js
│   │   │   ├── permissaRoutes.js
│   │   │   ├── sessionRoutes.js
│   │   │   └── dispatcherRoutes.js
│   │   ├── kernel/                 # Motor do kernel
│   │   │   ├── auth/               # Auth kernel
│   │   │   ├── worker/             # Worker runtime
│   │   │   ├── authz_client.js
│   │   │   ├── dispatcher_gateway.js
│   │   │   ├── ledger_client.js
│   │   │   └── worker_runner.js
│   │   ├── services/               # Serviços de negócio
│   │   │   ├── atendimento_service.js
│   │   │   ├── senha_service.js
│   │   │   ├── triagem_service.js
│   │   │   ├── farmacia_service.js
│   │   │   └── auditoria_service.js
│   │   └── runtime/                # Runtime do sistema
│   │       ├── runtimeGuard.js
│   │       ├── sessionGuard.js
│   │       ├── oracleEngine.js
│   │       └── syncQueueManager.js
│   ├── sql/                       # Scripts SQL
│   │   ├── seed*.sql              # Dados iniciais
│   │   ├── sp_*.sql               # Stored Procedures
│   │   ├── patch*.sql             # Correções
│   │   └── Dump*.sql              # Dumps do banco
│   ├── package.json
│   └── .env
│
├── frontend/                      # Aplicação React
│   ├── src/
│   │   ├── apps/
│   │   │   └── operacional/      # App operacional principal
│   │   │       ├── auth/          # Autenticação
│   │   │       ├── components/   # Componentes compartilhados
│   │   │       ├── layout/       # Layout (Sidebar, Header)
│   │   │       ├── pages/       # Páginas por setor
│   │   │       │   ├── recepcao/ # Módulo Recepção
│   │   │       │   ├── triagem/  # Módulo Triagem
│   │   │       │   ├── medico/   # Módulo Médico
│   │   │       │   ├── farmacia/ # Módulo Farmácia
│   │   │       │   ├── enfermagem/
│   │   │       │   ├── laboratorio/
│   │   │       │   ├── internacao/
│   │   │       │   ├── estoque/
│   │   │       │   └── ambulancia/
│   │   │       ├── runtime/      # Runtime client
│   │   │       └── security/    # Segurança
│   │   └── router/
│   ├── index.html
│   ├── vite.config.js
│   ├── tailwind.config.js
│   └── package.json
│
├── Captures/                     # Screenshots e demos
├── docs/                         # Documentação técnica
│   ├── MAPA_BANCO_DADOS_COMPLETO.md
│   ├── REFERENCIA_TECNICA_PROCEDURES.md
│   ├── ARQUITETURA_SISTEMA_ANALISE.md
│   ├── MAPA_6_MOTORES_SISTEMA.md
│   └── ...
│
├── .env.example
├── .gitignore
├── package.json
└── README.md
```

---

## 💾 Banco de Dados

### Tabelas Principais

| Módulo | Tabelas Principais |
|--------|-------------------|
| **Autenticação** | `usuario`, `pessoa`, `perfil`, `sessao_usuario`, `usuario_contexto` |
| **Filas** | `senhas`, `fila_operacional`, `fila_senha`, `fila_tipo` |
| **Clínico** | `ffa`, `atendimento`, `triagem`, `atendimento_evolucao` |
| **Farmácia** | `farmaco`, `dispensacao_medicacao`, `prescricao_item` |
| **Estoque** | `estoque_produto`, `estoque_movimento`, `estoque_local` |
| **Internação** | `internacao`, `leito`, `internacao_cuidados` |
| **Laboratório** | `laboratorio_pedido`, `laboratorio_amostra`, `laboratorio_resultado` |
| **Auditoria** | `auditoria_evento`, `evento_geral`, `auditoria_excecoes` |

### Stored Procedures Principais

| Procedure | Função |
|-----------|--------|
| `sp_master_dispatcher_runtime` | Ponto único de entrada para todas ações |
| `sp_master_login` | Autenticação de usuários |
| `sp_senha_emitir` | Emissão de senha |
| `sp_senha_chamar_proxima` | Chamada próxima senha |
| `sp_triagem_registrar` | Registro de triagem |
| `sp_medico_prescrever` | Prescrição médica |
| `sp_farmacia_dispensar` | Dispensação de medicamentos |

---

## 🚀 Instalação e Configuração

### Pré-requisitos

- Node.js 18+
- MySQL 8.0+
- npm ou yarn

### Configuração do Backend

```bash
# 1. Navegar para o diretório backend
cd backend

# 2. Instalar dependências
npm install

# 3. Criar arquivo .env
cp .env.example .env

# 4. Editar .env com suas configurações
# DB_HOST=localhost
# DB_USER=root
# DB_PASSWORD=sua_senha
# DB_DATABASE=pronto_atendimento
# JWT_SECRET=sua_chave_secreta

# 5. Executar scripts SQL (no MySQL Workbench ou linha de comando)
# - Criar banco de dados
# - Importar dump principal (Dump20260319.sql)
# - Executar seeds

# 6. Iniciar servidor
npm run dev
# Servidor rodando em http://localhost:3000
```

### Configuração do Frontend

```bash
# 1. Navegar para o diretório frontend
cd frontend

# 2. Instalar dependências
npm install

# 3. Criar arquivo .env
cp .env.example .env

# 4. Editar .env
# VITE_API_URL=http://localhost:3000/api

# 5. Iniciar desenvolvimento
npm run dev
# Aplicação em http://localhost:5173
```

---

## 🔐 Credenciais de Teste

O sistema inclui sementes (seeds) com usuários de teste:

| Usuário | Senha | Perfil |
|---------|-------|--------|
| `evandro.andrade` | `Senha123!` | ADMIN (Perfil 42) |
| `admin` | `Senha123!` | ADMIN_MASTER |
| `suporte` | `Senha123!` | SUPORTE |
| `recepcao1` | `Senha123!` | RECEPCAO |
| `medico_clinico` | `Senha123!` | MEDICO |
| `enfermagem1` | `Senha123!` | ENFERMAGEM |
| `farmaceutico` | `Senha123!` | FARMACIA |
| `totem01` | `Senha123!` | TOTEM_CALLER |

> ⚠️ **Importante:** Altere as senhas em produção e remova os scripts de seed ou restrinja o acesso.

---

## 🔄 Fluxo de Atendimento

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  TOTEM  │────▶│RECEPÇÃO │────▶│ TRIAGEM │────▶│ MÉDICO  │────▶│FARMÁCIA │
└─────────┘     └─────────┘     └─────────┘     └─────────┘     └─────────┘
    │                │               │               │               │
    ▼                ▼               ▼               ▼               ▼
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  SENHA   │   │  SENHA   │   │  SENHA   │   │  SENHA   │   │  SENHA   │
│ GERADA   │   │ CHAMADA  │   │CHAMADA   │   │CHAMADA   │   │CHAMADA   │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    ▼                   ▼                   ▼
             ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
             │ ENFERMAGEM  │    │ LABORATÓRIO │    │INTERNAÇÃO  │
             └─────────────┘    └─────────────┘    └─────────────┘
```

---

## 📚 Documentação Adicional

| Documento | Descrição |
|-----------|-----------|
| [MAPA_6_MOTORES_SISTEMA.md](MAPA_6_MOTORES_SISTEMA.md) | Detalhamento dos 6 motores |
| [ARQUITETURA_SISTEMA_ANALISE.md](ARQUITETURA_SISTEMA_ANALISE.md) | Análise arquitetural completa |
| [ANALISE_SISTEMA_COMPLETA.md](ANALISE_SISTEMA_COMPLETA.md) | Análise do sistema |
| [MAPA_BANCO_DADOS_COMPLETO.md](MAPA_BANCO_DADOS_COMPLETO.md) | Schema completo |
| [REFERENCIA_TECNICA_PROCEDURES.md](REFERENCIA_TECNICA_PROCEDURES.md) | Referência de procedures |
| [PROJECT_COMPLETE_STATUS.md](PROJECT_COMPLETE_STATUS.md) | Status do projeto |

---

## 🗺️ Roadmap de Implementação

### Fase 1 - Fundação ✅ (Concluído)

- [x] Estrutura de banco de dados completa
- [x] Sistema de autenticação JWT
- [x] Gestão de sessões e contextos
- [x] sp_master_dispatcher (entrada única)

### Fase 2 - Módulos Operacionais ✅ (Em Andamento)

- [x] Módulo Recepção
- [x] Módulo Triagem
- [x] Módulo Médico
- [x] Módulo Farmácia
- [ ] Módulo Enfermagem
- [x] Módulo Laboratório
- [x] Módulo Internação
- [x] Módulo Estoque
- [x] Módulo Ambulância

### Fase 3 - Infraestrutura 🟡 (Em Desenvolvimento)

- [x] Painel de chamadas
- [x] Totem de senha
- [ ] TV Rotativa automática
- [ ] Sistema de notifications

### Fase 4 - Avançado 🟡 (Planejado)

- [ ] Relatórios e dashboards
- [ ] Integração com SUS (TISS/TISS)
- [ ] Prontuário eletrônico completo
- [ ] Mobile (React Native)

---

## 🎓 Princípios Arquiteturais

1. **Offline-First**: O sistema deve funcionar sem conexão интернет
2. **Determinístico**: Mesmo input = mesmo output
3. **Auditável**: Todos os eventos registrados em ledger
4. **Segurança em Camadas**: Múltiplos guardiões validam ações
5. **Separação de Concerns**: Backend processa, frontend apresenta
6. **Idempotência**: Operações podem ser repetidas com segurança
7. **Transparência**: Código legível e manutenível

---

## 📄 Licença

Este projeto está em desenvolvimento.

---

**Criado:** 2025-2026  
**Versão:** 1.0.0  
**Status:** 🟡 Em Desenvolvimento

---

*Sistema desenvolvido para atender às necessidades de pronto atendimento e UPA, com foco em eficiência, segurança e conformidade com as normas do SUS.*
