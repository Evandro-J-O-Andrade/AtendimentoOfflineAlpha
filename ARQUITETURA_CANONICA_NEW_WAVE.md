# ARQUITETURA_CANONICA_NEW_WAVE.md

## VISÃO DO PRODUTO

A plataforma é um SaaS corporativo multiempresa desenvolvido pela New Wave Sistemas Digitais.

A plataforma deve ser capaz de atender qualquer segmento:

* Saúde
* Indústria
* Comércio
* Logística
* Educação
* Governo
* Prestação de Serviços
* Empresas Privadas

Nenhum módulo pode assumir que o sistema será utilizado apenas por hospitais.

---

# FLUXO OFICIAL

Login
↓
Portal Corporativo
↓
Aplicação
↓
Contexto Operacional (quando necessário)
↓
Dashboard

---

# REGRAS OBRIGATÓRIAS

1. Login autentica apenas identidade.

2. Login NÃO seleciona:

   * Unidade
   * Sala
   * Local
   * Especialidade
   * Guichê

3. O Portal é a entrada oficial do sistema.

4. Apenas módulos autorizados devem aparecer.

5. Módulos sem permissão não devem ser exibidos.

6. Contexto operacional somente ao entrar em módulos operacionais.

---

# SEGURANÇA

Obrigatório:

* JWT em Cookie HttpOnly
* Refresh Token HttpOnly
* Nenhum token em localStorage
* Nenhum token em sessionStorage

Proibido:

* Armazenar JWT em JavaScript

---

# AUTHCONTEXT

Responsável apenas por:

* Usuário
* Sessão
* Permissões
* Tenant
* Perfil

Não deve conter lógica operacional nova.

---

# CONTEXTCONTEXT

Responsável por:

* Unidade
* Local
* Sala
* Guichê
* Contexto operacional

---

# PORTAL CORPORATIVO

Módulos iniciais:

* Atendimento
* Farmácia
* Estoque
* Almoxarifado
* Gestão
* Intranet
* Treinamentos
* Documentos
* Chamados

---

# INTRANET CORPORATIVA

Funcionalidades:

* Comunicados
* Notícias
* Eventos
* Calendário
* Aniversariantes
* Enquetes
* Reconhecimentos

---

# REDE SOCIAL CORPORATIVA

Funcionalidades:

* Feed
* Curtidas
* Comentários
* Compartilhamentos
* Menções
* Hashtags
* Grupos

---

# TECNOLOGIA

Obrigatório:

* React
* TypeScript
* Vite
* React Router
* Axios
* Tailwind
* Lucide React

Novos módulos devem ser criados em TSX.

---

# PROIBIÇÕES

Não criar:

* _v2
* _new
* _legacy
* versões paralelas

Não remover funcionalidades existentes sem autorização.

Não alterar backend ou banco sem análise prévia.

Não alterar Stored Procedures sem aprovação.

---

# PRIORIDADES ATUAIS

Sprint 1:

* Corrigir infraestrutura TSX
* Corrigir Tailwind
* Corrigir CSS do Portal

Sprint 2:

* Portal Corporativo

Sprint 3:

* ContextContext

Sprint 4:

* Contexto sob demanda

Sprint 5:

* Intranet

Sprint 6:

* Rede Social Corporativa

---

Toda alteração deve respeitar este documento.
Em caso de conflito, este documento prevalece sobre qualquer prompt temporário.
