# Mapa de Stored Procedures para Frontend HIS/PA

Este documento lista as principais stored procedures do banco de dados e como usá-las no frontend.

---

## 🔐 Autenticação

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Login | `sp_auth_login` | `p_login`, `p_senha` | token, usuário, contextos |
| Logout | `sp_auth_logout` | `p_id_sessao` | sucesso |
| Validar Sessão | `sp_auth_validar_sessao` | `p_token_runtime` | sessão válida |
| Permissões | `sp_auth_permissoes` | `p_token_runtime` | lista de permissões |

---

## 🎫 Senhas e Fila

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Emitir senha | `sp_senha_emitir` | `p_id_sessao_usuario` | senha gerada |
| Chamar senha | `sp_senha_chamar` | `p_id_sessao_usuario`, `p_id_fila` | senha chamada |
| Chamar próxima | `sp_senha_chamar_proxima` | `p_id_sessao_usuario` | próxima senha |
| Finalizar | `sp_senha_finalizar` | `p_id_sessao_usuario`, `p_id_fila` | atendimento finalizedo |
| Cancelar | `sp_senha_cancelar` | `p_id_sessao_usuario`, `p_id_fila` | senha cancelada |
| Não compareceu | `sp_senha_nao_compareceu` | `p_id_sessao_usuario`, `p_id_fila` | status atualizado |
| Transicionar | `sp_senha_transicionar_status` | `p_id_sessao_usuario`, `p_id_fila`, `p_status` | status alterado |

---

## 🏥 Recepção

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Gerar senha | `sp_recepcao_gerar_senha` | `p_id_sessao` | senha criada |
| Encaminhar FFA | `sp_recepcao_encaminhar_ffa` | `p_id_sessao_usuario`, `p_id_fila` | FFA criado |
| Complementar | `sp_recepcao_complementar_e_abrir_ffa` | `p_id_sessao_usuario` | FFA aberto |
| Não compareceu | `sp_recepcao_nao_compareceu` | `p_id_sessao_usuario`, `p_id_fila` | registro atualizado |

---

## 🚨 Triagem

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Classificar | `sp_triagem_classificar_senha` | `p_id_sessao`, `p_classificacao` | classificação aplicada |
| Finalizar | `sp_triagem_finalizar` | `p_id_sessao_usuario`, `p_id_fila` | triagem finalizeda |

---

## 👨‍⚕️ Médico

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Encaminhar | `sp_medico_encaminhar` | `p_id_sessao_usuario`, `p_id_ffa`, `p_destino` | encaminhamento criado |
| Finalizar | `sp_medico_finalizar` | `p_id_sessao_usuario`, `p_id_fila` | atendimento finalizedo |
| Marcar retorno | `sp_medico_marcar_retorno` | `p_id_sessao_usuario`, `p_id_fila` | retorno agendado |

---

## 💊 Farmácia

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Dispensar | `sp_farmacia_dispensar_registrar` | `p_id_sessao_usuario`, `p_id_fila` | dispensação registrada |
| Criar dispensação | `sp_farm_dispensacao_criar` | `p_id_sessao_usuario`, `p_id_fila` | dispensação criada |
| Confirmar reserva | `sp_farm_reserva_confirmar` | `p_id_sessao_usuario`, `p_id_fila` | reserva confirmada |

---

## 📊 Painel de Chamadas

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Chamar senha | `sp_painel_chamar_senha` | `p_id_sessao` | senha exibida |
| Cancelar senha | `sp_painel_cancelar_senha` | `p_id_sessao` | senha cancelada |
| Inserir senha | `sp_painel_inserir_senha` | `p_id_sessao` | senha inserida |

---

## ⚙️ Dispatcher (Ação Genérica)

| Ação | Stored Procedure | Parâmetros | Retorno |
|------|-----------------|------------|---------|
| Executar ação | `sp_master_dispatcher_runtime` | `p_id_sessao`, `p_acao`, `p_payload` | resultado da ação |

### Payload do Dispatcher:

```javascript
// Exemplo de payload para chamar senha
const payload = {
  acao: "CHAMAR_SENHA",
  parametros: {
    id_fila: 1
  }
};

// Exemplo de payload para triagem
const payload = {
  acao: "TRIAGEM_CLASSIFICAR",
  parametros: {
    id_fila: 1,
    classificacao: "VERMELHO"
  }
};
```

---

## 🔄 Como usar no Frontend

### 1. Pegar Permissões (Menu Dinâmico)

```javascript
// GET /api/auth/permissoes/:idPerfil
const permissoes = await api.get(`/auth/permissoes/${idPerfil}`);
```

### 2. Executar Ação via Dispatcher

```javascript
// POST /api/runtime/dispatch
const resultado = await api.post("/runtime/dispatch", {
  acao: "CHAMAR_SENHA",
  payload: {
    id_fila: 1
  },
  idSessao: sessao.id_sessao,
  idUsuario: sessao.id_usuario
});
```

### 3. Ações Diretas (sem dispatcher)

```javascript
// Emitir senha - POST /api/fila/emitir
const senha = await api.post("/fila/emitir", {
  id_sessao: sessao.id_sessao
});

// Chamar próxima - POST /fila/chamar-proxima
const proxima = await api.post("/fila/chamar-proxima", {
  id_sessao: sessao.id_sessao,
  id_fila: 1
});
```

---

## 📋 Códigos de Ação para Menu

| Código | Descrição | Grupo |
|--------|-----------|-------|
| `SENHA_EMITIR` | Emitir nova senha | Recepção |
| `SENHA_CHAMAR` | Chamar senha | Fila |
| `SENHA_CANCELAR` | Cancelar senha | Fila |
| `TRIAGEM_CLASSIFICAR` | Classificar na triagem | Triagem |
| `ATENDIMENTO_INICIAR` | Iniciar atendimento | Atendimento |
| `ATENDIMENTO_FINALIZAR` | Finalizar atendimento | Atendimento |
| `MEDICO_ENCAMINHAR` | Encaminhar para médico | Médico |
| `FARMACIA_DISPENSAR` | Dispensar medicamento | Farmácia |
| `PAINEL_CHAMAR` | Chamar no painel | Painel |
| `USUARIO_CADASTROS` | Cadastrar usuários | Admin |
| `PERFIL_CADASTROS` | Gerenciar perfis | Admin |

---

## 🔗 Endpoint Mapping

| Frontend | Backend Route | SP |
|----------|---------------|-----|
| Login | POST /api/auth/login | sp_auth_login |
| Permissões | GET /api/auth/permissoes/:idPerfil | sp_auth_permissoes |
| Dispatch | POST /api/runtime/dispatch | sp_master_dispatcher_runtime |
| Emitir Senha | POST /api/fila/emitir | sp_senha_emitir |
| Chamar Senha | POST /api/fila/chamar | sp_senha_chamar |
| Triagem | POST /api/triagem/classificar | sp_triagem_classificar_senha |
