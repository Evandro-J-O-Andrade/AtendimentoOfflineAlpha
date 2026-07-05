# Matriz Front × Procedure

## Tela → SP → Tabela → Evento → Permissão

### Login
- SP: `sp_master_login`
- Domínio: IAM
- Tela → /portal/login

### Portal
- SP: `sp_auth_contexto_get`
- Domínio: IAM
- Tela → /portal/portal

### Portal
- SP: `sp_master_dispatcher`
- Domínio: Core
- Tela → /portal/portal

### Recepção
- SP: `sp_master_atendimento_iniciar`
- Domínio: HIS
- Tela → /portal/recepção

### Senha
- SP: `sp_master_senha_emitir`
- Domínio: HIS
- Tela → /portal/senha

### Painel
- SP: `sp_senha_emitir`
- Domínio: HIS
- Tela → /portal/painel

### Triagem
- SP: `sp_senha_chamar`
- Domínio: HIS
- Tela → /portal/triagem

### Senha
- SP: `sp_senha_finalizar`
- Domínio: HIS
- Tela → /portal/senha

### Atendimento
- SP: `sp_fila_chamar_proxima`
- Domínio: HIS
- Tela → /portal/atendimento

### Atendimento
- SP: `sp_fila_finalizar`
- Domínio: HIS
- Tela → /portal/atendimento

### Recepção
- SP: `sp_recepcao_iniciar_complementacao`
- Domínio: HIS
- Tela → /portal/recepção

### FFA
- SP: `sp_recepcao_complementar_e_abrir_ffa`
- Domínio: HIS
- Tela → /portal/ffa

### FFA
- SP: `sp_recepcao_encaminhar_ffa`
- Domínio: HIS
- Tela → /portal/ffa

### FFA
- SP: `sp_ffa_orquestrador_transicao`
- Domínio: HIS
- Tela → /portal/ffa

### Triagem
- SP: `sp_triagem_finalizar`
- Domínio: HIS
- Tela → /portal/triagem

### Médico
- SP: `sp_medico_encaminhar`
- Domínio: HIS
- Tela → /portal/médico

### Médico
- SP: `sp_medico_finalizar`
- Domínio: HIS
- Tela → /portal/médico

### Dashboard
- SP: `sp_atendimento_transicionar`
- Domínio: HIS
- Tela → /portal/dashboard

### Dashboard
- SP: `sp_atendimento_finalizar_evasao`
- Domínio: HIS
- Tela → /portal/dashboard

### Farmácia
- SP: `sp_farmacia_dispensar_registrar`
- Domínio: HIS
- Tela → /portal/farmácia

### Estoque
- SP: `sp_estoque_movimento_criar`
- Domínio: Financeiro
- Tela → /portal/estoque


---

## Matriz Completa

| Tela | SP | Endpoint |
|------|-----|----------|
| Login | `sp_master_login` | `/api/iam` |
| Portal | `sp_auth_contexto_get` | `/api/iam` |
| Portal | `sp_master_dispatcher` | `/api/core` |
| Recepção | `sp_master_atendimento_iniciar` | `/api/his` |
| Senha | `sp_master_senha_emitir` | `/api/his` |
| Painel | `sp_senha_emitir` | `/api/his` |
| Triagem | `sp_senha_chamar` | `/api/his` |
| Senha | `sp_senha_finalizar` | `/api/his` |
| Atendimento | `sp_fila_chamar_proxima` | `/api/his` |
| Atendimento | `sp_fila_finalizar` | `/api/his` |
| Recepção | `sp_recepcao_iniciar_complementacao` | `/api/his` |
| FFA | `sp_recepcao_complementar_e_abrir_ffa` | `/api/his` |
| FFA | `sp_recepcao_encaminhar_ffa` | `/api/his` |
| FFA | `sp_ffa_orquestrador_transicao` | `/api/his` |
| Triagem | `sp_triagem_finalizar` | `/api/his` |
| Médico | `sp_medico_encaminhar` | `/api/his` |
| Médico | `sp_medico_finalizar` | `/api/his` |
| Dashboard | `sp_atendimento_transicionar` | `/api/his` |
| Dashboard | `sp_atendimento_finalizar_evasao` | `/api/his` |
| Farmácia | `sp_farmacia_dispensar_registrar` | `/api/his` |
| Estoque | `sp_estoque_movimento_criar` | `/api/financeiro` |
