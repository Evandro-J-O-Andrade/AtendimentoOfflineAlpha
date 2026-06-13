# ANÁLISE COMPLETA DO SISTEMA DE ATENDIMENTO

**Data:** 11/03/2026
**Status:** Em análise e correção

---

## 1. ESTRUTURA DO BANCO DE DADOS

### 1.1 Tabelas Principais (450+ tabelas)

#### Módulo de Autenticação e Sessão
- `usuario` - Usuários do sistema
- `sessao_usuario` - Sessões ativas
- `perfil` - Perfis de acesso
- `permissao` - Permissões
- `perfil_permissao` - Relação perfil-permissão
- `usuario_contexto` - Contextos do usuário
- `usuario_unidade` - Vinculo usuário-unidade
- `usuario_local_operacional` - Vinculo usuário-local

#### Módulo de Filas e Senhas
- `senha` - Senhas emitidas
- `senha_status` - Status das senhas
- `senha_eventos` - Eventos das senhas
- `fila_operacional` - Filas operacionais
- `fila_senha` - Relation between fila and senha
- `fila_evento` - Eventos de fila

#### Módulo de Dispositivos (Totens/Painéis)
- `dispositivo` - Dispositivos cadastrados
- `dispositivo_tipo` - Tipos de dispositivo
- `totem` - Totens
- `totem_evento` - Eventos do totem
- `totem_senha_opcao` - Opções de senha do totem
- `totem_feedback` - Feedback do totem
- `painel` - Painéis de chamada
- `painel_config` - Configuração dos painéis
- `painel_fila_tipo` - Tipos de fila por painel

#### Módulo de Atendimento
- `atendimento` - Atendimentos
- `atendimento_estado_ativo` - Estados ativos
- `atendimento_evento` - Eventos do atendimento
- `atendimento_movimentacao` - Movimentações

#### Módulo de Farmácia
- `farmacia_dispensacao_log` - Log de dispensação
- `farm_dispensacao` - Dispensações
- `farm_dispensacao_item` - Itens de dispensação
- `gpat` - GPAT
- `gpat_atendimento` - GPAT por atendimento
- `gpat_item` - Itens GPAT

#### Módulo de Estoque
- `estoque_produto` - Produtos
- `estoque_lote` - Lotes
- `estoque_movimento` - Movimentos
- `estoque_saldo` - Saldos

#### Módulo de Faturamento
- `faturamento_conta` - Contas
- `faturamento_conta_item` - Itens de conta
- `faturamento_convenio` - Convênios

---

## 2. STORED PROCEDURES (160+)

### Procedures de Autenticação
- `sp_auth_login` - Login
- `sp_auth_logout` - Logout
- `sp_auth_validar_sessao` - Validar sessão
- `sp_auth_criar_sessao` - Criar sessão

### Procedures Master (20 SPs)
- `sp_master_senha_emitir` - Emitir senha
- `sp_master_chamar_senha` - Chamar senha
- `sp_master_atendimento_iniciar` - Iniciar atendimento
- `sp_master_atendimento_finalizar` - Finalizar atendimento
- `sp_master_atendimento_transicionar` - Transicionar atendimento
- `sp_master_administracao_medicacao` - Adm medication
- `sp_master_administracao_medicacao_ordem` - Ord medication
- `sp_master_registrar_administracao_medicacao` - Registrar admin
- `sp_master_registrar_alerta` - Registrar alerta
- `sp_master_dispatcher` - Dispatcher
- `sp_master_dispatcher_runtime` - Dispatcher runtime
- `sp_master_fila_operacional` - Fila operacional

### Procedures de Senha
- `sp_senha_emitir` - Emitir senha
- `sp_senha_chamar` - Chamar senha
- `sp_senha_finalizar` - Finalizar senha
- `sp_senha_cancelar` - Cancelar senha
- `sp_senha_nao_compareceu` - Não compareceu
- `sp_senha_rechamar` - Rechamar senha
- `sp_totem_gerar_senha` - Gerar senha no totem

---

## 3. FRONTEND - ESTRUTURA DE APPS

### Apps Existentes
- `/frontend/src/apps/admin/` - Módulo administrativo
- `/frontend/src/apps/operacional/` - Módulo operacional
- `/frontend/src/apps/painel/` - Módulo de painéis
- `/frontend/src/apps/totem/` - Módulo de totens
- `/frontend/src/apps/governaca/` - Módulo de governança

### Rotas do Frontend (`/frontend/src/router/index.jsx`)
```
/login           - Login
/totem           - Totem (público)
/contexto        - Seleção de contexto
/painel          - Painel do usuário
/recepcao        - Recepção
/triagem         - Triagem
/enfermagem      - Enfermagem
/medico          - Médico
/farmacia        - Farmácia
/painel-chamadas - Painel de chamadas
/admin           - Administração
/admin/modulo/:moduloId - Módulo admin
```

---

## 4. CORREÇÕES APLICADAS

### 4.1 Banco de Dados
- ✅ Adicionada coluna `ip_acesso` na tabela `totem_evento`
- ✅ Atualizado enum de eventos para incluir: SENHA_GERADA, SENHA_CHAMADA, SENHA_ATENDIDA, SENHA_CANCELADA, SENHA_REAUTUADA

### 4.2 Backend
- ✅ Corrigida chamada da procedure `sp_master_senha_emitir` em `/backend/src/routes/operacionalRoutes.js`
- ✅ Parâmetros corretos: id_sessao, id_usuario, id_perfil, payload JSON

---

## 5. IMAGENS DE REFERÊNCIA (Captures)

### Layouts Identificados
1. **totem de senha.png** - Tela inicial do totem
2. **totem de satisfação.png** - Pesquisa de satisfação
3. **tela do clinco-pediatrico.png** - Painel clínico pediátrico
4. **administrador.png** - Tela admin
5. **login.png** - Tela de login
6. **login contexto.png** - Seleção de contexto
7. **PRONTO-ATENDIMENTO** (muitas variações) - Telas de atendimento
8. **EVOLUÇÃO PACIENTE** - Evolução clínica

---

## 6. MÓDULOS NECESSÁRIOS

### 6.1 Módulos de Painel
- [x] Painel recepção
- [x] Painel triagem  
- [x] Painel clínico
- [x] Painel pediátrico
- [ ] TV rotativa (fila geral)
- [ ] Painel satisfação

### 6.2 Módulos de Totem
- [x] Totem senha
- [ ] Totem satisfação
- [ ] Kiosk paciente

### 6.3 Módulos Farmácia
- [x] Farmácia interna
- [ ] Farmácia de rua (PDV)

### 6.4 Módulos Operacionais
- [x] Recepção
- [x] Triagem
- [x] Enfermagem
- [x] Médico
- [x] Farmácia

---

## 7. PERFIS DEFINIDOS

| Perfil | Descrição |
|--------|-----------|
| ROOT | Super administrador |
| ADMIN | Administrador do sistema |
| ADMINISTRATIVO | Funções administrativas |
| SUPORTE_TI | Suporte técnico |
| MEDICO | Profissionais médicos |
| ENFERMAGEM | Profissionais de enfermagem |
| FARMACIA | Farmacêuticos |
| CAIXA | Operador de caixa |
| PAINEL | Exibição em painéis |
| TOTEM | Operação em totens |
| RECEPCAO | Atendente de recepção |
| TRIAGEM | Enfereiro de triagem |

---

## 8. PRÓXIMOS PASSOS

1. ✅ Corrigir erro do totem (coluna ip_acesso)
2. ✅ Corrigir chamada da SP de senha
3. [ ] Verificar rotas e contextos
4. [ ] Implementar TV rotativa
5. [ ] Implementar totem satisfação
6. [ ] Implementar farmácia de rua (PDV)
7. [ ] Verificar seed inicial
8. [ ] Testar todos os fluxos
