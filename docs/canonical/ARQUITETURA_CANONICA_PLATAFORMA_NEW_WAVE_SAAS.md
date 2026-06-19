# ARQUITETURA CANÔNICA — PLATAFORMA NEW WAVE SAAS

## Status

Documento canônico e imutável da plataforma.

Este documento define a arquitetura oficial da Plataforma New Wave SaaS e substitui decisões conflitantes de documentos anteriores.

---

# 1. PROPÓSITO DA PLATAFORMA

A Plataforma New Wave é uma plataforma SaaS corporativa, multiempresa, multissegmento e offline-first.

A plataforma não é um HIS.

A plataforma não é um ERP.

A plataforma não é um CRM.

A plataforma é um ecossistema capaz de hospedar múltiplas aplicações de negócio sobre um núcleo comum.

---

# 2. LEI FUNDAMENTAL

Pessoa é a entidade raiz do sistema.

Pessoa não nasce paciente.

Pessoa não nasce funcionário.

Pessoa não nasce usuário.

Paciente, funcionário, usuário, profissional e gestor são papéis assumidos por uma pessoa.

---

# 3. PILARES IMUTÁVEIS

## Pessoa

Entidade raiz da plataforma.

Toda identidade humana deve originar-se em Pessoa.

---

## Usuário

Representa a identidade digital utilizada para autenticação.

Um usuário está vinculado a uma pessoa.

---

## Sessão

Toda operação executada na plataforma deve ocorrer através de uma sessão válida.

Sessão é a identidade operacional da plataforma.

---

## SaaS Entidade

Representa o cliente da plataforma.

Exemplos:

* Hospital
* Prefeitura
* Clínica
* Empresa
* Franquia
* Organização

Todos os dados pertencem a uma SaaS Entidade.

---

# 4. SEPARAÇÃO ENTRE IDENTIDADE E CONTEXTO

Identidade não é contexto operacional.

Fluxo obrigatório:

Login
→ Portal
→ Aplicação
→ Contexto Operacional
→ Dashboard

É proibido acessar funcionalidades operacionais diretamente após o login.

---

# 5. PORTAL CORPORATIVO

O Portal Corporativo é o ponto central da plataforma.

Responsabilidades:

* Autenticação
* Autorização
* Catálogo de aplicações
* Seleção de contexto operacional
* Notificações
* Preferências
* Auditoria de acesso

O Portal não executa regras assistenciais.

O Portal não executa regras de negócio específicas dos aplicativos.

---

# 6. APLICAÇÕES

As aplicações são módulos independentes hospedados na plataforma.

Exemplos:

* Assistencial
* Farmácia
* Financeiro
* Estoque
* Compras
* RH
* CRM
* BI
* Administração

Cada aplicação possui seu domínio próprio.

---

# 7. CONTEXTO OPERACIONAL

Após escolher uma aplicação, o usuário deve selecionar o contexto operacional.

Exemplos:

* Unidade
* Local
* Setor
* Sala
* Painel
* Guichê

Toda operação deve ser executada dentro de um contexto.

---

# 8. MOTOR DE EVENTOS

A plataforma possui um único motor canônico de eventos.

Toda ação relevante gera evento.

Fluxo:

Ação
→ Evento
→ Orquestrador
→ Estado
→ Auditoria

É proibida a existência de múltiplos motores concorrentes de workflow.

---

# 9. AUDITORIA

Toda operação deve gerar auditoria.

Toda auditoria deve possuir:

* Sessão
* Usuário
* Data/Hora
* Aplicação
* Contexto
* Evento

Nenhuma operação relevante pode ocorrer sem rastreabilidade.

---

# 10. ARQUITETURA OFFLINE-FIRST

A plataforma deve operar sem internet.

Fluxo:

Runtime Local
→ Fila Local
→ Reconciliação
→ Spine Central

A continuidade operacional local é obrigatória.

---

# 11. DOMÍNIO ASSISTENCIAL

O domínio assistencial é uma aplicação da plataforma.

Não representa a plataforma inteira.

---

# 12. LEI DA SENHA

A senha é o início do episódio assistencial.

Fluxo:

Pessoa
→ Senha
→ FFA
→ GPAT
→ Eventos Assistenciais

A senha não é apenas um número de fila.

A senha representa o nascimento operacional do atendimento.

---

# 13. FFA

A FFA é o container operacional do episódio assistencial.

Todos os processos assistenciais devem estar vinculados à FFA.

Exemplos:

* Triagem
* Consulta
* Exame
* Medicação
* Observação
* Faturamento

---

# 14. GPAT

GPAT identifica o episódio assistencial.

GPAT não identifica a pessoa.

Uma pessoa pode possuir múltiplos GPATs ao longo do tempo.

---

# 15. BANCO DE DADOS

O banco de dados é a fonte da verdade.

Princípios:

* Sem tabelas duplicadas por versão
* Sem objetos _legacy
* Sem objetos _v2
* Nome canônico único
* Auditoria obrigatória
* Integridade referencial obrigatória

---

# 16. FRONTEND

Fluxo obrigatório:

Login
→ Portal
→ Aplicação
→ Contexto Operacional
→ Dashboard

Arquitetura:

apps/
├── portal
├── assistencial
├── farmacia
├── financeiro
├── estoque
├── crm
├── bi
└── administracao

packages/
├── auth
├── contexto
├── eventos
├── workflow
├── auditoria
├── sdk
└── ui

---

# 17. PRINCÍPIO DE EXPANSÃO

Nenhuma nova funcionalidade pode quebrar:

* Pessoa como raiz
* Sessão como identidade operacional
* SaaS Entidade como proprietário dos dados
* Evento como mecanismo de orquestração
* Portal como ponto de entrada
* Senha → FFA → GPAT no domínio assistencial

---

# 18. RESUMO EXECUTIVO

A Plataforma New Wave é uma plataforma SaaS corporativa, multiempresa, multissegmento e offline-first.

Pessoa é a entidade raiz.

Sessão é a identidade operacional.

Portal é o ponto de entrada.

Aplicações executam regras de negócio.

Eventos orquestram o sistema.

No domínio assistencial, o episódio nasce através da sequência:

Pessoa → Senha → FFA → GPAT.

