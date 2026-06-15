# ARQUITETURA CANÔNICA CONSOLIDADA - NEW WAVE ENTERPRISE

## LEI DE EVOLUÇÃO DA PLATAFORMA NEW WAVE

1. O núcleo da plataforma deve permanecer genérico e independente de segmento.
2. Nenhuma tabela nova pode ser criada sem auditoria prévia comprovando que o conceito não existe no banco.
3. Motores corporativos existentes devem ser reutilizados: autenticação, sessão, auditoria, agenda, alertas, documentos.
4. Novas tabelas serão criadas apenas para domínios inexistentes.
5. O Portal Corporativo é um agregador de aplicações e não um sistema isolado.
6. A plataforma deve atender igualmente B2B, B2C, Saúde, Varejo, Serviços, Indústria, Educação, Governo.
7. Toda nova modelagem deve ser orientada por: SAAS_ENTIDADE → PESSOA → (USUARIO Opcional) → SESSAO_USUARIO → CONTEXTO_OPERACIONAL → WORKFLOW → EVENTO → AUDITORIA

---

## ARQUITETURA ONTOLÓGICA CANÔNICA

### Nível 1: SAAS_ENTIDADE (Raiz Organizacional)
Tenant multiempresa - raiz de todos os dados

### Nível 2: PESSOA (Raiz Humana)
Raiz de todas as interações. Sub-tipos: Paciente, Cliente, Fornecedor, Colaborador, Profissional, Contato.

### Nível 3: USUARIO (Credencial Opcional)
Extensão da Pessoa para acesso ao sistema. Nem toda Pessoa é um Usuário (ex: Leads, Clientes PDV).

### Nível 4: PERFIL
Conjunto de permissões atribuídas ao Usuário.

### Nível 5: SESSAO_USUARIO (Identidade operacional ativa)
ID único da permanência do Usuário na plataforma (Login → Logout).

### Nível 6: CONTEXTO_OPERACIONAL (Onde o trabalho ocorre)
Vínculo dinâmico da Sessão com:
* **SISTEMA**: Qual App está aberta (HIS, CRM, ERP, etc)
* **UNIDADE/LOCAL**: Onde a operação está sendo executada.

### Nível 7: UNIDADE (Contexto organizacional)
Filial/empresa

### Nível 8: LOCAL (Contexto operacional)
Triagem, Consultório, Farmácia

### Nível 9: WORKFLOW
Fila, senhas, FFA, atendimento

### Nível 10: EVENTO
Fato ocorrido - usando `evento_geral`

### Nível 11: AUDITORIA
Rastro imutável - usando `atendimento_evento_ledger`

---

## MAPA DE REAPROVEITAMENTO DO NÚCLEO (Stage 199)

### Tabelas a REUTILIZAR (NÃO criar novas)
- `usuario` → Portal usa diretamente
- `sessao_usuario` → Portal usa sessão existente
- `evento_geral` → Portal usa com `dominio='PORTAL'`
- `agendamento` → Portal usa com novos serviços
- `alerta` → Portal usa com severidade INFO
- `documento_arquivo` → Portal usa para anexos

### Procedures a REUTILIZAR
- `sp_master_dispatcher` → Portal usa dispatcher universal
- `sp_ledger_registrar_evento` → Portal usa para auditoria
- `sp_sessao_assert` → Portal usa validação de sessão

---

## STAGE 200 - PORTAL CORPORATIVO

Tabelas a criar:
- `portal_noticia`
- `portal_noticia_categoria`
- `portal_comunicado`
- `portal_comunicado_destinatario`
- `portal_enquete`
- `portal_enquete_opcao`
- `portal_enquete_resposta`
- `portal_banner`
- `portal_pagina`
- `portal_pagina_bloco`

Procedure: `sp_portal_dispatch`

---

## ESTRUTURA FRONTEND CORRETA

```
src/
├── apps/
│   ├── operacional/
│   │   ├── auth/AuthProvider.tsx
│   │   └── security/RequireContext.tsx
│   └── portal/
│       ├── components/
│       ├── layouts/PortalLayout.tsx
│       └── pages/IntranetPage.tsx
├── features/
│   └── atendimento/AppOperacional.tsx
├── pages/
│   ├── auth/LoginPage.tsx
│   └── portal/PortalRoutes.tsx
├── app/
│   ├── providers/TenantProvider.tsx
│   └── providers/RuntimeContext.tsx
└── main.tsx
```