# NEW WAVE SISTEMAS DIGITAIS

# ARQUITETURA CANÔNICA DA PLATAFORMA CORPORATIVA SaaS

# DOCUMENTO MESTRE OFICIAL

Versão: 1.0
Status: OFICIAL
Autoridade Arquitetural: New Wave Sistemas Digitais

---

# OBJETIVO

Transformar a atual plataforma em um Ecossistema Corporativo SaaS Multiempresa capaz de atender qualquer segmento de mercado sem dependências arquiteturais de um nicho específico.

A plataforma deve atender simultaneamente:

* Saúde
* Hospitais
* Clínicas
* UPA
* UBS
* Laboratórios
* Farmácias
* Farmácias de Rua (PDV)
* Distribuidoras
* Comércio
* Indústria
* Logística
* Educação
* Governo
* Escritórios
* Empresas Privadas
* Prestadores de Serviço
* Redes Corporativas

A arquitetura deve permanecer genérica.

Nenhum módulo deve assumir que a plataforma é hospitalar.

---

# VISÃO DA PLATAFORMA

A plataforma não é um HIS.

A plataforma não é um ERP.

A plataforma não é um CRM.

A plataforma é um ECOSSISTEMA CORPORATIVO.

O sistema deve funcionar como uma central única de aplicações.

Fluxo oficial:

Login
↓
Portal Corporativo
↓
Aplicação
↓
Contexto Operacional (quando necessário)
↓
Dashboard da Aplicação

---

# PRINCÍPIO FUNDAMENTAL

Identidade ≠ Operação

Quem é o usuário:

AuthContext

Onde o usuário está trabalhando:

ContextContext

Jamais misturar.

---

# LOGIN

O login deve autenticar apenas:

* Usuário
* Senha

Não solicitar:

* Unidade
* Local
* Sala
* Setor
* Guichê
* Departamento

Essas informações pertencem ao contexto operacional.

---

# SEGURANÇA

Obrigatório:

Cookie HttpOnly
Secure
SameSite

Proibido:

localStorage para token
sessionStorage para token

Permitido no localStorage:

Tema
Última unidade utilizada
Último local utilizado
Preferências de usuário

---

# PORTAL CORPORATIVO

O Portal é a HOME oficial da plataforma.

Todo usuário autenticado deve acessar primeiro o Portal.

Nunca redirecionar diretamente para:

Recepção
Triagem
Médico
Farmácia
Dashboard

O Portal é obrigatório.

---

# DESIGN DO PORTAL

Referência visual:

Microsoft 365
Google Workspace
ClickUp
Notion
Monday
Atlassian

Características:

* moderno
* corporativo
* elegante
* espaçamento amplo
* visual limpo
* responsivo
* dark mode
* white label
* animações suaves
* skeleton loading
* microinterações

---

# EXPERIÊNCIA VISUAL

O usuário deve sentir:

Organização
Modernidade
Fluidez
Velocidade
Profissionalismo

Jamais transmitir aparência de sistema legado.

---

# LAYOUT DO PORTAL

Topo:

Logo da organização
Nome da organização
Busca global
Notificações
Perfil do usuário

Centro:

Cards de aplicações

Rodapé:

Versão
Empresa desenvolvedora
Links institucionais

---

# GRID DE APLICAÇÕES

Os módulos devem aparecer como cards modernos.

Cada card deve possuir:

* Ícone
* Nome
* Descrição
* Status
* Favorito
* Último acesso

---

# MÓDULOS CORPORATIVOS

Portal

Intranet

Rede Social Corporativa

Documentos

Treinamentos

Central de Chamados

Projetos

RH

CRM

Financeiro

BI

Gestão

Agenda

Calendário Corporativo

Chat Corporativo

Wiki Corporativa

---

# MÓDULOS OPERACIONAIS

Atendimento

Recepção

Triagem

Consultório

Internação

Observação

Farmácia Interna

Farmácia Hospitalar

Laboratório

Radiologia

Estoque

Almoxarifado

Manutenção

Patrimônio

Transporte

Auditoria

Faturamento

---

# FARMÁCIA DE RUA

A plataforma deve suportar:

PDV

Venda balcão

Leitor código barras

Controle de estoque

Lotes

Validade

Financeiro

Caixa

Comandas

Promoções

Convênios

Fidelidade

Compras

Fornecedores

Inventário

Relatórios

Multiempresa

Multiunidade

---

# INTRANET

Comunicados

Avisos

Notícias

Eventos

Calendário

Aniversariantes

Pesquisas

Reconhecimentos

Publicações

---

# REDE SOCIAL CORPORATIVA

Feed

Curtidas

Comentários

Compartilhamentos

Menções

Hashtags

Grupos

Comunidades

Ranking

Gamificação

---

# TREINAMENTOS

Cursos

Trilhas

Vídeos

Provas

Certificados

Histórico

Pontuação

---

# DOCUMENTOS

Pesquisa

Categorias

Favoritos

Versionamento

Aprovação

Downloads

Workflow

Assinatura

---

# CHAMADOS

Abertura

Acompanhamento

SLA

Técnicos

Filas

Dashboard

Base conhecimento

---

# WHITE LABEL

Todo cliente deve personalizar:

Logo

Nome

Cores

Tema

Domínio

Módulos

Menus

Permissões

---

# PROIBIÇÕES

Não utilizar:

Hospital
Clínica
UPA
UBS
Alpha

Como elementos fixos da plataforma.

Esses termos são apenas clientes ou cenários.

---

# IDENTIDADE PADRÃO

Empresa Desenvolvedora:

New Wave Sistemas Digitais

---

# ESTRUTURA OFICIAL FRONTEND

src/

apps/
portal/
corporativo/
operacional/
painel/
totem/

shared/

components/
hooks/
services/
types/
layouts/

providers/

TenantProvider
AuthProvider
ContextProvider

---

# AUTHCONTEXT

Responsável por:

Usuário

Sessão

Permissões

Tenant

Perfil

Notificações

---

# CONTEXTCONTEXT

Responsável por:

Unidade

Local

Setor

Sala

Guichê

Departamento

Projeto

Equipe

---

# PROTEÇÃO DE ROTAS

Nível 1

requireAuth

Usuário autenticado

Nível 2

requireContext

Usuário autenticado +
Contexto selecionado

---

# BRANDING

Jamais aplicar branding dentro de páginas.

Proibido:

PortalHome aplicar CSS global.

Obrigatório:

TenantProvider

Responsável por:

Logo

Nome

Tema

Variáveis CSS

Document Title

---

# TAILWIND

Obrigatório:

js
jsx
ts
tsx

---

# TYPESCRIPT

Todo código novo:

TSX

Não criar novos JSX.

Migrar gradualmente os legados.

---

# OBJETIVO FINAL

Construir uma plataforma corporativa SaaS multiempresa, multiunidade, multiaplicação e white-label capaz de atender qualquer segmento de mercado mantendo um único núcleo tecnológico desenvolvido pela New Wave Sistemas Digitais.
