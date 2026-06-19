# ARQUITETURA_SP_FIRST_CANONICA.md

## STATUS

Documento Canônico.

Possui autoridade superior sobre ORM, Repositories, CRUDs, Migrations, Frameworks, Geradores de Código, Inteligências Artificiais, N8N e qualquer camada de aplicação.

Complementa:

* ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md
* BANCO_FONTE_DA_VERDADE_CANONICO.md
* ESTRUTURA_ENTERPRISE_CANONICA_NEW_WAVE_SAAS.md

---

# PRINCÍPIO FUNDAMENTAL

A Plataforma New Wave utiliza arquitetura:

SP-FIRST

Stored Procedures são a camada oficial de negócio.

O Backend não implementa regras de negócio.

O Frontend não implementa regras de negócio.

O ORM não implementa regras de negócio.

As regras de negócio pertencem ao Banco Canônico através de Stored Procedures.

---

# FLUXO OFICIAL

Frontend
→ API
→ Service
→ Stored Procedure
→ Evento
→ Auditoria
→ Banco

---

# PROIBIÇÕES

É proibido:

INSERT direto em tabelas.

UPDATE direto em tabelas.

DELETE direto em tabelas.

TRUNCATE direto em tabelas.

ALTER TABLE executado pela aplicação.

CREATE TABLE executado pela aplicação.

DROP TABLE executado pela aplicação.

---

# CRUD DIRETO É PROIBIDO

A plataforma não é orientada a CRUD.

A plataforma é orientada a processos.

Exemplo incorreto:

Criar Pessoa

Editar Pessoa

Excluir Pessoa

Exemplo correto:

Cadastrar Pessoa

Atualizar Cadastro

Bloquear Pessoa

Reativar Pessoa

Transferir Pessoa

Vincular Pessoa

---

# ORM NÃO É FONTE DE VERDADE

Nenhum ORM possui autoridade sobre o domínio.

ORMs podem ser utilizados apenas para:

* Mapeamento
* Serialização
* Conversão de objetos
* Consultas auxiliares

ORM nunca define regras de negócio.

ORM nunca altera estrutura do banco.

ORM nunca substitui Stored Procedures.

---

# BACKEND

O Backend é um orquestrador.

Responsabilidades:

* Autenticação
* Autorização
* Validação de entrada
* Chamada de Stored Procedures
* Retorno de dados
* Integrações
* Webhooks
* N8N
* IA

Responsabilidades proibidas:

* Implementar regra de negócio assistencial
* Implementar regra financeira
* Implementar regra farmacêutica
* Implementar regra de faturamento

Estas regras pertencem às Stored Procedures.

---

# FRONTEND

O Frontend nunca acessa tabelas.

O Frontend nunca conhece a estrutura física do banco.

O Frontend consome apenas APIs oficiais.

---

# TODA OPERAÇÃO DEVE PASSAR POR SP

Exemplos:

sp_pessoa_cadastrar

sp_pessoa_atualizar

sp_usuario_criar

sp_sessao_iniciar

sp_senha_gerar

sp_ffa_abrir

sp_gpat_criar

sp_farmacia_dispensar

sp_estoque_movimentar

sp_financeiro_lancar

sp_faturamento_processar

---

# TODA SP RECEBE SESSÃO

Obrigatório.

Toda Stored Procedure pública deve receber:

p_id_sessao_usuario

Exemplo:

sp_pessoa_cadastrar(
p_id_sessao_usuario,
p_nome,
p_cpf
)

---

# TODA SP DEVE VALIDAR CONTEXTO

Obrigatório validar:

* Usuário
* Sessão
* Aplicação
* Contexto Operacional
* Permissões

antes da execução.

---

# TODA SP DEVE GERAR EVENTO

Fluxo obrigatório:

SP
→ Evento
→ Auditoria
→ Persistência

Nenhuma operação relevante pode ocorrer sem evento.

---

# TODA SP DEVE GERAR AUDITORIA

Obrigatório registrar:

* Sessão
* Usuário
* Aplicação
* Contexto
* Data
* Evento
* Resultado

---

# EVENTOS

A plataforma possui apenas um motor canônico de eventos.

É proibido criar motores paralelos.

Fluxo:

Ação
→ Stored Procedure
→ Evento
→ Orquestrador
→ Estado

---

# LEITURAS

Consultas críticas:

Obrigatoriamente por Stored Procedure.

Exemplos:

sp_ffa_obter

sp_prontuario_obter

sp_financeiro_obter

sp_farmacia_obter

---

# VIEWS

Dashboards podem utilizar Views Canônicas.

Exemplos:

vw_dashboard_executivo

vw_dashboard_assistencial

vw_dashboard_farmacia

vw_dashboard_financeiro

vw_dashboard_rh

vw_dashboard_ti

---

# N8N

N8N nunca acessa tabelas diretamente.

N8N deve consumir:

* APIs Oficiais
  ou
* Stored Procedures homologadas

Fluxo:

N8N
→ API
→ Stored Procedure
→ Evento
→ Auditoria

---

# WEBHOOKS

Webhooks nunca acessam tabelas diretamente.

Fluxo:

Webhook
→ API
→ Stored Procedure
→ Evento
→ Auditoria

---

# INTELIGÊNCIA ARTIFICIAL

IA nunca altera tabelas diretamente.

IA nunca executa SQL direto.

Fluxo:

IA
→ API
→ Stored Procedure
→ Evento
→ Auditoria

---

# APIS

Toda API deve ser apenas uma fachada.

Fluxo:

API
→ Validação
→ Stored Procedure
→ Resposta

A API não possui autoridade de domínio.

---

# BANCO CANÔNICO

O Banco Canônico é a Fonte da Verdade.

Stored Procedures são a Camada Oficial de Negócio.

Views são a Camada Oficial de Consulta.

Eventos são a Camada Oficial de Orquestração.

Auditoria é a Camada Oficial de Rastreabilidade.

---

# ORDEM DE AUTORIDADE

1. Arquitetura Canônica
2. Banco Fonte da Verdade
3. Stored Procedures
4. Eventos
5. Auditoria
6. APIs
7. Frontend
8. N8N
9. IA
10. Integrações Externas

---

# LEI FINAL

Nenhum desenvolvedor, IA, automação, N8N, webhook, API, frontend ou backend pode criar, alterar ou remover dados de negócio diretamente em tabelas.

Toda operação obrigatoriamente passa por Stored Procedures Canônicas.

Stored Procedures são a Camada Oficial de Negócio da Plataforma New Wave.
