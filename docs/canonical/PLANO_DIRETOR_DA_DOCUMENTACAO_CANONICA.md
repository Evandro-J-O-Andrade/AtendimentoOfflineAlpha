# PLANO_DIRETOR_DA_DOCUMENTACAO_CANONICA.md

## STATUS

Documento Canônico.

Define todos os documentos obrigatórios da Plataforma New Wave SaaS.

Nenhum desenvolvimento deve iniciar sem que estes documentos existam e estejam homologados.

---

# OBJETIVO

Eliminar decisões arquitetônicas durante o desenvolvimento.

Toda decisão estratégica deve estar documentada previamente.

O código deve implementar decisões já aprovadas.

O código não deve definir arquitetura.

---

# HIERARQUIA DE AUTORIDADE

1. Constituição Arquitetural
2. MDs da Lei Arquitetural
3. Domínio Canônico
4. Banco Canônico
5. Stored Procedures
6. Eventos
7. Workflow
8. APIs
9. Frontend
10. Integrações
11. Automações
12. IA

---

# DOCUMENTOS MD DA LEI ARQUITETURAL

Os documentos MD1 a MD12 são a constituição sintética da plataforma.
Eles definem a cadeia oficial de decisão: entrada, execução, eventos, estado, consistência e evolução.

## 01 - MD1_arquitetura_canonica.md

Define a plataforma como:

```text
DB-Driven Distributed Workflow Engine
com SP Master Layer como núcleo de controle
```

## 02 - MD2_contrato_frontend.md

Define o contrato obrigatório do React:

```text
React -> sp_master_dispatcher
```

## 03 - MD3_dispatcher.md

Define a Lei de Entrada:

```text
sp_master_dispatcher
```

## 04 - MD4_orquestradora.md

Define a SP orquestradora por domínio.

## 05 - MD5_execucao.md

Define a Domain Execution Layer por Stored Procedures de negócio.

## 06 - MD6_eventos_atual.md

Registra o estado atual dos eventos fragmentados.

## 07 - MD7_state.md

Define que estado é derivado de eventos e snapshots.

## 08 - MD8_execucao.md

Define que toda regra de negócio deve ser executada por SP.

## 09 - MD9_event_store.md

Define o event store canônico futuro `kernel_event_store`.

## 10 - MD10_fluxo.md

Define o fluxo final da plataforma.

## 11 - MD11_consistencia.md

Define que nenhuma mudança de estado pode existir sem rastreabilidade.

## 12 - MD12_evolucao.md

Define que o sistema não é reescrito; é migrado por camadas canônicas.

---

# DOCUMENTOS NÍVEL CONSTITUIÇÃO

## 01 - ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md

Define:

* Visão da plataforma
* Leis imutáveis
* Pessoa como entidade raiz
* Portal corporativo
* SaaS B2B/B2C/Governo
* Offline First

---

## 02 - MIGRACAO_CANONICA_2026.md

Define:

* Processo de migração
* Legado
* Homologação
* Recuperação de artefatos

---

## 03 - ESTRUTURA_ENTERPRISE_CANONICA_NEW_WAVE_SAAS.md

Define:

* Estrutura física
* Monorepo
* Aplicações
* Packages
* Backend
* Banco
* Dispositivos
* IA
* N8N

---

# DOCUMENTOS DE DOMÍNIO

## 04 - MODELO_DOMINIO_CANONICO.md

Define:

* SaaS Entidade
* Pessoa
* Usuário
* Sessão
* Aplicação
* Contexto Operacional
* Evento
* Auditoria

Domínio Assistencial:

Pessoa
→ Senha
→ FFA
→ GPAT

---

## 05 - CONTEXTO_OPERACIONAL_CANONICO.md

Define:

Usuário
→ Aplicação
→ Empresa
→ Unidade
→ Setor
→ Local
→ Painel
→ Guichê

---

## 06 - SEGURANCA_CANONICA.md

Define:

* Perfis
* Permissões
* Sessões
* Tokens
* LGPD
* Criptografia
* Auditoria

---

# DOCUMENTOS DE BANCO

## 07 - BANCO_FONTE_DA_VERDADE_CANONICO.md

Lei:

O Dump Oficial é a Fonte da Verdade.

Proibido:

* Criar tabela diretamente
* Alterar estrutura diretamente
* Depender exclusivamente de ORM

---

## 08 - ARQUITETURA_SP_FIRST_CANONICA.md

Lei:

Stored Procedures são a camada oficial de negócio.

Fluxo:

Frontend
→ API
→ SP
→ Evento
→ Auditoria

---

## 09 - AUDITORIA_ARQUITETURA_BANCO_SP_MASTER_CANONICA.md

Define:

* Prompt mestre de auditoria
* Análise neutra do Dump Oficial
* Evidências, inferências e riscos
* SPs master, dispatcher, orquestradoras e executoras
* Eventos, logs, auditoria e estado
* Classificação de maturidade arquitetural

---

## 10 - DICIONARIO_CANONICO_DE_DADOS.md

Define:

* Tabelas
* Campos
* Índices
* FKs
* Tipos
* Convenções

---

# DOCUMENTOS DE EVENTOS

## 11 - EVENTOS_CANONICOS.md

Catálogo oficial de eventos.

Exemplos:

PESSOA_CADASTRADA

USUARIO_CRIADO

SESSAO_INICIADA

SENHA_GERADA

FFA_ABERTA

GPAT_CRIADO

MEDICACAO_EXECUTADA

ALTA_CONCLUIDA

---

## 12 - WORKFLOW_CANONICO.md

Define:

Estado
→ Evento
→ Transição
→ Novo Estado

---

# DOCUMENTOS DE FRONTEND

## 13 - FRONTEND_CANONICO.md

Define:

Login
→ Portal
→ Aplicação
→ Contexto
→ Dashboard

---

## 14 - DESIGN_SYSTEM_CANONICO.md

Define:

* Layout
* CSS Global
* CSS Local
* Componentes
* Temas
* Tabelas
* Formulários
* Dashboards

---

## 15 - DASHBOARDS_CANONICOS.md

Define:

Dashboard Executivo

Dashboard Gestor

Dashboard Assistencial

Dashboard Farmácia

Dashboard Financeiro

Dashboard RH

Dashboard TI

Dashboard BI

Dashboard Compliance

---

# DOCUMENTOS DE DISPOSITIVOS

## 16 - DISPOSITIVOS_CANONICOS.md

Define:

* Portal
* Painéis
* Totens
* Mobile
* Tablet
* TV Corporativa

---

# DOCUMENTOS DE INTEGRAÇÃO

## 17 - INTEGRACOES_CANONICAS.md

Define:

* APIs
* Webhooks
* Mensageria
* Gov
* Convênios
* Bancos
* PIX
* E-mail
* SMS
* WhatsApp

---

## 18 - N8N_CANONICO.md

Define:

* Estrutura dos Workflows
* Credenciais
* Auditoria
* Retry
* Monitoramento

Lei:

N8N nunca acessa tabelas diretamente.

---

# DOCUMENTOS DE IA

## 19 - IA_CANONICA.md

Define:

* Copilots
* Assistentes
* Classificadores
* Analytics
* Automações

Lei:

IA nunca acessa tabelas diretamente.

IA nunca executa SQL.

IA utiliza APIs oficiais.

---

# DOCUMENTOS DE NEGÓCIO

## 20 - SAUDE_CANONICO.md

Pessoa
→ Senha
→ FFA
→ GPAT

Recepção

Triagem

Consulta

Observação

Medicação

Prontuário

Alta

---

## 21 - FARMACIA_CANONICO.md

Farmácia Assistencial

Farmácia Ambulatorial

Farmácia de Rua

PDV

Dispensação

Estoque

Lotes

Compras

---

## 22 - FINANCEIRO_CANONICO.md

Contas

Tesouraria

Orçamento

Custos

Fluxo de Caixa

---

## 23 - FATURAMENTO_CANONICO.md

SUS

Convênios

Particular

Glosas

Produção

---

## 24 - LOGISTICA_CANONICO.md

Ambulâncias

Remoções

Frota

Abastecimento

---

## 25 - RH_CANONICO.md

Funcionários

Escalas

Ponto

Treinamentos

---

## 26 - TI_CANONICO.md

CAT

Ativos

Inventário

Monitoramento

Chamados

---

## 27 - SAC_CANONICO.md

Atendimento

Ouvidoria

Protocolos

Pesquisa de Satisfação

---

## 28 - CRM_CANONICO.md

Leads

Clientes

Oportunidades

Contratos

---

# DOCUMENTOS DE GOVERNANÇA

## 29 - GOVERNANCA_CANONICA.md

Define:

* Aprovação arquitetural
* Homologação
* Versionamento documental
* Fluxo de mudanças

---

## 30 - ROADMAP_CANONICO.md

Define:

Fase 1
Portal + Auth + Sessão

Fase 2
Saúde + Senha + FFA + GPAT

Fase 3
Farmácia + PDV + Estoque

Fase 4
Financeiro + Faturamento

Fase 5
RH + TI + Logística

Fase 6
IA + N8N + Marketplace

---

# LEI FINAL

Nenhum código possui autoridade sobre a arquitetura.

Nenhuma API possui autoridade sobre o domínio.

Nenhum frontend possui autoridade sobre o negócio.

O domínio é definido pelos Documentos Canônicos.

O Banco Canônico é a Fonte da Verdade.

As Stored Procedures são a Camada Oficial de Negócio.

Os Eventos são a Camada Oficial de Orquestração.

A Auditoria é a Camada Oficial de Rastreabilidade.

Toda expansão futura da Plataforma New Wave deve obedecer integralmente esta documentação.