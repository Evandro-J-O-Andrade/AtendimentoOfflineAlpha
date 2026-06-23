# FRONT-024 — AI Experience Framework

## Status

Documento Canônico de Frontend.
Define padrão de interação com IA em toda a plataforma.

---

## Objetivo

Padronizar toda interação com IA em componentes canônicos e modos contextuais.

---

## Princípio Fundamental

```text
IA não é genérica.
IA é contextual.
IA é assistente.
IA é transparente.
IA é controlável.
```

---

## Componentes

### ChatIA

```text
Conversa em texto puro
Mensagens com timestamp
Indicador de digitação
Anexos suportados
Histórico de conversas
Export de conversa
```

### Copilot

```text
Assistente lateral flutuante
Sugestões em tempo real
Ações rápidas (1 clique)
Contextual (baseado na tela atual)
Minimizável
Multi-chat
```

### ContextualAssistant

```text
Assistente específico por contexto
HIS: "Como usar o prontuário?"
CRM: "Qual cliente está em negociação?"
Financeiro: "Qual o saldo do orçamento?"
Personalizado por app
```

### ResumoIA

```text
Resumo de documentos
Resumo de conversas
Resumo de relatórios
Resumo de reuniões (transcritos)
Formato configurável (bullet, parágrafo)
Tamanho configurável (curto, médio, longo)
```

### SugestõesIA

```text
Sugestões de próximos passos
Sugestões de campos
Sugestões de valores
Treinamento contínuo
Feedback explícito (útil/não útil)
```

### AutomacoesIA

```text
Automação sugerida
Trigger configurável
Condições visuais
Preview da automação
Ativar/desativar
Histórico de execuções
```

---

## Modos

### Portal (IA Corporativa)

```text
Assistente geral da plataforma
Acesso a todos os dados do tenant
Sugestões de produtividade
Resumos executivos
Geração de relatórios
```

### HIS (Assistente Clínico)

```text
Foco em prontuário
Sugestões clínicas (não diagnóstico)
Atenção a privacidade (LGPD)
Integração com pacientes
Histórico de atendimentos
```

### RH (Assistente de Pessoas)

```text
Foco em colaboradores
Sugestões de benefícios
Análise de performance
Recuperação de vagas
Onboarding guiado
```

### CRM (Assistente Comercial)

```text
Foco em vendas
Previsão de pipeline
Sugestões de follow-up
Análise de clientes
Propostas automáticas
```

---

## Regras

### Obrigatório

```text
Todo acesso a IA é logado
Tokens são contabilizados
Custo é exibido (quando configurado)
Modo determina contexto
Feedback é coletado
```

### Proibido

```text
IA sem log de uso
Sugestão sem contexto
Resumo de dados sensíveis (sem anonimização)
Automação sem rollback
Feedback ignorado
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-104 — AI Platform | Plataforma de IA canônica |
| MD-054 — AI Gateway | Gateway de provedores |
| MD-055 — AI Providers | OpenAI, Gemini, Claude, Locais |
| MD-056 — AI Training | Treinamento de modelos |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-025 — AI Command Center | Governança de IA |
| FRONT-003 — Portal Enterprise | IA no Portal |
| FRONT-005 — Dashboard Framework | IA em dashboards |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Chat, copilot, resumo, sugestões, automações |
| Backend | APIs de IA, tokens, custos, feedback |
| Dispatcher | Roteamento para provedores de IA |
| SP | Formatação de prompts, regras de negócio |
| Event Store | Registrar uso de IA, feedback, custo |

---

## Métricas

```text
Tokens consumidos por dia
Custo de IA por tenant
Conversas por usuário
Sugestões aceitas vs. rejeitadas
Automações ativas
Tempo médio de resposta da IA
Taxa de erro da IA
Satisfação com IA (CSAT)
```

---

## Lei

```text
IA é contextual.
IA é assistente.
IA é transparente.
IA é controlável.
```

---

## Próximo

```text
FRONT-024 completo
  ↓
FRONT-025 — AI Command Center
```