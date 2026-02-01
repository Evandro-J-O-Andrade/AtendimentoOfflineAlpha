# 🏥 AtendimentoOfflineAlpha - Arquitetura e Progresso

## Status da Implementação

✅ **Completo:**
- ✅ Hooks de Gerenciamento de Estado (useFFAs, useEvolucoes, useLocaisAtendimento, useAlertasFFAs, useUI)
- ✅ Contexto Global (AtendimentoContextoV2) com Immer para imutabilidade
- ✅ Componente FilaLocal (com countdown de Manchester)
- ✅ Layout Recepção (Cadastro, Fila, Chamada)
- ✅ Layout Triagem (Registro de Sinais Vitais + Manchester)
- ✅ Layout Consultório (Atendimento Médico + Prescrição)
- ✅ Layout Internação (Movimentação de Leitos + Evoluções)
- ✅ Painel Central (Dashboard em tempo real)

🚧 **Em Progresso:**
- 🚧 Integração com WebSocket (para atualizações em tempo real)
- 🚧 Serviços backend para domínios adicionais (FARMACIA, SAMU, TI, GLPI, MANUTENCAO)

📋 **Pendente:**
- 📋 Layout Farmácia (Dispensação, Inventário)
- 📋 Layout SAMU (Solicitação, Rastreamento)
- 📋 Layout Exame (Rastreamento de Resultados)
- 📋 Layout TI/GLPI (Helpdesk, Chamados)
- 📋 Layout Manutenção (Chamados, Execução)
- 📋 Testes E2E para fluxo completo
- 📋 Autenticação e controle de acesso por local
- 📋 Relatórios e analytics

---

## 🏗️ Arquitetura

### Frontend Stack
- **Framework:** React 18 + Context API
- **Estado:** Immer (mutação imutável)
- **Styling:** CSS modular por componente
- **Hooks Customizados:** useFFAs, useEvolucoes, useLocaisAtendimento, useAlertasFFAs, useUI

### Backend Stack
- **API:** PHP (refatorada em domínios)
- **Database:** MySQL 8.0.x
- **Padrão:** Domain-Driven Design (atendimento/, triagem/, internacao/, etc.)

### Fluxo de Dados
```
Recepção (Cadastro) → Triagem (Manchester) → Consultório (Diagnóstico) → Exame/Medicação → Internação → Alta
```

---

## 📁 Estrutura de Pastas

```
src/
├── api/                              # Backend PHP refatorado
│   ├── atendimento/
│   ├── triagem/
│   ├── internacao/
│   ├── farmacia/                     # NOVO (pendente)
│   ├── samu/                         # NOVO (pendente)
│   └── ...
│
├── components/
│   ├── FilaLocal.jsx                 # ✅ Componente de Fila
│   ├── FilaLocal.css
│   └── ...
│
├── context/
│   └── AtendimentoContextoV2.jsx     # ✅ Estado global com Immer
│
├── shared/
│   ├── hooks/
│   │   ├── useFFAs.js                # ✅ Gerenciamento de FFAs
│   │   ├── useEvolucoes.js           # ✅ Evolução médica/enfermagem
│   │   ├── useLocaisAtendimento.js   # ✅ Gerenciamento de locais
│   │   ├── useAlertasFFAs.js         # ✅ Alertas de Manchester
│   │   ├── useUI.js                  # ✅ Modais e notificações
│   │   └── ...
│   │
│   └── services/
│       ├── api.js                    # Base para chamadas API
│       ├── atendimento.service.js
│       ├── triagem.service.js
│       ├── internacao.service.js
│       ├── farmacia.service.js       # NOVO (pendente)
│       ├── samu.service.js           # NOVO (pendente)
│       └── ...
│
└── pages/
    ├── recepcao/
    │   ├── RecepcaoLayout.jsx        # ✅ Recepção
    │   └── RecepcaoLayout.css
    │
    ├── triagem/
    │   ├── TriagemLayout.jsx         # ✅ Triagem
    │   └── TriagemLayout.css
    │
    ├── consultorio/
    │   ├── ConsultorioLayout.jsx     # ✅ Consultório
    │   └── ConsultorioLayout.css
    │
    ├── internacao/
    │   ├── InternacaoLayout.jsx      # ✅ Internação
    │   └── InternacaoLayout.css
    │
    ├── painel/
    │   ├── PainelCentralLayout.jsx   # ✅ Painel Central
    │   └── PainelCentralLayout.css
    │
    ├── farmacia/                     # NOVO (pendente)
    ├── samu/                         # NOVO (pendente)
    ├── exame/                        # NOVO (pendente)
    ├── ti/                           # NOVO (pendente)
    └── manutencao/                   # NOVO (pendente)
```

---

## 🔄 Fluxo de Atendimento

1. **RECEPÇÃO:** Paciente chega, preenche cadastro, gera FFA (Ficha de Fluxo)
2. **TRIAGEM:** Enfermeiro coleta sinais vitais, classifica por Manchester (VERMELHO/LARANJA/AMARELO/VERDE/AZUL)
3. **CONSULTÓRIO:** Médico avalia, faz diagnóstico, prescreve medicações e exames
4. **EXAME:** Lab/RX/ECG realiza exame conforme solicitação
5. **MEDICAÇÃO:** Farmácia prepara e administra medicações prescritas
6. **INTERNAÇÃO:** Enfermeiro registra paciente em leito, acompanhamento contínuo
7. **ALTA:** Médico libera alta, paciente recebe orientações e sai

---

## 🎨 Componentes Principais

### FilaLocal
- Exibe fila de pacientes do local atual
- Mostra countdown de Manchester em tempo real
- Permite seleção de paciente para atendimento
- Cores indicam prioridade (vermelho/laranja/amarelo/verde/azul)

### Painel Central
- Dashboard em tempo real com todas as FFAs ativas
- Distribuição por prioridade (gráfico)
- Alertas críticos (expiradas/urgentes)
- Filtro por local de atendimento
- Tabela de FFAs com status e tempo restante

---

## ⏱️ Manchester Classification Tempos Limite

- 🔴 **VERMELHO:** 0 minutos (imediato)
- 🟠 **LARANJA:** 10 minutos
- 🟡 **AMARELO:** 60 minutos (1 hora)
- 🟢 **VERDE:** 120 minutos (2 horas)
- 🔵 **AZUL:** 240 minutos (4 horas)

*Tempos calculados automaticamente por triggers no BD ao classificar paciente*

---

## 🔧 Próximas Tarefas

### 1. WebSocket para Tempo Real
- [ ] Configurar Socket.io no backend PHP
- [ ] Emitir eventos quando FFA muda de status
- [ ] Atualizar filas automaticamente em todos os clientes
- [ ] Atualizar countdown de Manchester em tempo real

### 2. Serviços Restantes
- [ ] Farmacia.service.js (dispensação, inventário)
- [ ] Samu.service.js (solicitação, rastreamento)
- [ ] Exame.service.js (pedido, resultado)
- [ ] Ti.service.js / Glpi.service.js (help desk)
- [ ] Manutencao.service.js (chamados)

### 3. Layouts Restantes
- [ ] Layout Farmácia
- [ ] Layout SAMU
- [ ] Layout Exame
- [ ] Layout TI/GLPI
- [ ] Layout Manutenção

### 4. Autenticação
- [ ] Implementar JWT no login
- [ ] Controle de acesso por local (usuário só vê sua fila)
- [ ] Controle de permissões por perfil (médico, enfermeiro, farmacêutico, etc)

### 5. Relatórios
- [ ] Tempo médio de atendimento por local
- [ ] Taxa de exame resolvidos
- [ ] Performance por médico/enfermeiro
- [ ] Satisfação de paciente

---

## 🎯 Objetivos Atingidos

✅ Estado global imutável e escalável (Immer + Context)
✅ Filas por local com countdown visual
✅ Classificação Manchester com tempos automáticos
✅ Workflow flexível (FFAs fluem entre locais)
✅ Painel de monitoramento em tempo real
✅ Alertas visuais para FFAs críticas
✅ Interface intuitiva e responsiva
✅ Integração com backend PHP refatorado

---

## 📊 Estatísticas de Código

- **Hooks Customizados:** 5 (useFFAs, useEvolucoes, useLocaisAtendimento, useAlertasFFAs, useUI)
- **Layouts Implementados:** 5 (Recepção, Triagem, Consultório, Internação, Painel Central)
- **Componentes:** 1 principal (FilaLocal) + 5 layouts
- **Linhas de CSS:** ~800 (modular por componente)
- **API Endpoints Refatorados:** 10+ (com tratativa de erro e standardização)

---

## 🚀 Como Executar

```bash
# Install dependencies
npm install

# Start dev server
npm run dev

# Backend PHP
# Certifique que o servidor local está rodando (Apache/Nginx com PHP)
# Acesse http://localhost:5173 (frontend)
```

---

## 📝 Notas Importantes

1. **Imutabilidade:** Todas as atualizações de estado usam Immer (`draft` pattern)
2. **Hooks:** Reutilizáveis em qualquer componente dentro do `<AtendimentoProviderV2>`
3. **CSS:** BEM-like naming (`.componente__elemento--estado`)
4. **Responsividade:** Mobile-first design com breakpoints em 768px
5. **Acessibilidade:** ARIA labels e semantic HTML

---

## 🤝 Contribuindo

Para adicionar novos locais/domínios:

1. Criar hook em `src/shared/hooks/use[Nome].js`
2. Criar service em `src/shared/services/[nome].service.js`
3. Criar layout em `src/pages/[nome]/[Nome]Layout.jsx`
4. Adicionar ações no `AtendimentoContextoV2.jsx`

---

**Última atualização:** Janeiro 2025
**Status:** 🚀 MVP Pronto (Falta apenas domínios adicionais e WebSocket)
