Analisei o `Dump20260613.sql` que você anexou.

Alguns pontos importantes:

### O que já existe no banco

Você já possui estruturas relacionadas a agenda:

* `agendamento`
* `agenda_disponibilidade`
* `agendamentos_eventos`

Ou seja, para o HIS você **não precisa necessariamente criar uma tabela calendário**. Um calendário visual no React pode ser montado em cima dessas tabelas.

Também encontrei estruturas fortes de:

* `auth_sessao`
* `auditoria_*`
* `evento_*`
* `fila_*`
* `atendimento_*`
* `chamado`
* `alerta`
* `documento_*`

O banco está muito mais próximo de um motor operacional do que de um simples HIS.

---

### O que eu considero faltante para o Portal Corporativo / Intranet

Hoje o banco parece extremamente forte para operação assistencial, mas ainda não parece possuir um núcleo completo de:

* Intranet
* Rede Social Corporativa
* Portal Corporativo
* Comunicação Interna

Eu criaria um domínio próprio chamado:

```text
portal_*
```

e outro:

```text
social_*
```

---

### Tabelas recomendadas para Intranet

```sql
portal_noticia
portal_noticia_categoria
portal_noticia_anexo

portal_comunicado
portal_comunicado_destinatario

portal_evento
portal_evento_participante

portal_enquete
portal_enquete_opcao
portal_enquete_resposta

portal_wiki
portal_wiki_revisao

portal_pagina
portal_pagina_bloco

portal_banner

portal_calendario
portal_calendario_evento
```

---

### Tabelas recomendadas para Rede Social Corporativa

```sql
social_postagem
social_postagem_anexo

social_comentario

social_reacao

social_grupo

social_grupo_membro

social_chat

social_chat_mensagem

social_chat_participante

social_hashtag

social_mencao

social_notificacao
```

---

### Tabelas recomendadas para RH Social

```sql
colaborador_conquista

colaborador_reconhecimento

colaborador_aniversario

colaborador_habilidade

colaborador_certificacao
```

---

### O que eu melhoraria no documento

O seu MD atual fala muito de integração.

Mas ele não explica a arquitetura da plataforma.

Eu transformaria ele em um documento corporativo mais forte.

# ARQUITETURA CANÔNICA DA PLATAFORMA CORPORATIVA

## 1. Princípios Imutáveis

A plataforma possui arquitetura Offline-First, orientada a eventos, baseada em banco de dados transacional governado por Stored Procedures canônicas.

São regras imutáveis:

* Banco de dados é a única fonte da verdade.
* Trigger é proibido.
* Toda lógica de negócio deve residir em Stored Procedures.
* Toda operação deve possuir contexto de sessão.
* Toda operação deve ser auditável.
* Nenhuma gravação pode ocorrer sem usuário, unidade e sessão.
* Não utilizar nomenclaturas temporárias, experimentais ou versionadas.

Proibido:

* _v2
* _novo
* _legacy
* _beta
* _alpha

---

## 2. Fluxo Ontológico Oficial

Toda operação deve respeitar:

Sessão → Contexto → Fluxo → Evento → Snapshot → Auditoria

Exemplo:

auth_sessao
→ senha
→ atendimento
→ atendimento_evento
→ assistencial_snapshot_runtime
→ auditoria_evento

---

## 3. Separação Arquitetural

A plataforma é dividida em quatro camadas:

### Identidade

Responsável por:

* Login
* MFA
* Sessões
* Permissões
* Auditoria

### Portal Corporativo

Responsável por:

* Dashboard
* Intranet
* Rede Social Corporativa
* Comunicados
* Notícias
* Eventos
* Calendário

### Aplicações

Responsável pelos módulos de negócio:

* HIS
* Farmácia
* Laboratório
* Financeiro
* CRM
* RH
* Estoque

### Contexto Operacional

Responsável pela execução operacional:

* Unidade
* Local
* Sala
* Painel
* Totem
* Atendimento

---

## 4. Offline First

Nenhuma tela deve depender exclusivamente de conexão online.

Toda ação operacional deve:

1. Persistir localmente.
2. Entrar na fila de sincronização.
3. Receber UUID global.
4. Ser sincronizada posteriormente.
5. Ser processada pelas Stored Procedures canônicas.

---

## 5. Integração Frontend

O React é responsável apenas por:

* Interface
* Validação visual
* Cache local
* Sincronização
* Apresentação de dados

O React nunca implementa regras críticas de negócio.

Toda regra crítica pertence ao banco de dados.

---

## 6. Portal Corporativo

Módulos obrigatórios:

* Dashboard
* Intranet
* Rede Social Corporativa
* Comunicação
* RH
* CRM
* Financeiro
* Estoque
* Documentos
* Workflow
* BI
* IA Corporativa
* Marketplace
* Administração

---

## 7. Saúde (HIS)

Módulos obrigatórios:

* Recepção
* Senhas
* Triagem
* Atendimento
* Observação
* Medicação
* Farmácia
* Laboratório
* Radiologia
* Faturamento
* Painéis
* Totens

---

## 8. Auditoria

Toda operação deve gerar:

* Evento
* Log
* Contexto
* Responsável
* Data/Hora
* Unidade
* Origem

Nenhuma ação operacional pode ser anônima.

Esse documento fica muito mais próximo de uma **especificação arquitetural da plataforma inteira**, não apenas de um guia de integração React. Além disso, olhando seu dump atual, a maior lacuna estrutural para o novo SaaS realmente está no domínio **Portal/Intranet/Rede Social Corporativa**, porque o núcleo operacional e assistencial já está bastante avançado.
