# MAPA COMPLETO DE INTEGRAÇÃO: FRONTEND ↔ SPs ↔ BANCO

**Data:** 11/03/2026  
**Versão:** 1.0  
**Sistema:** Pronto Atendimento / UPA

---

## 📋 ÍNDICE

1. [Visão Geral da Arquitetura](#1-visão-geral-da-arquitetura)
2. [Módulos do Frontend](#2-módulos-do-frontend)
3. [Tabelas Principais por Módulo](#3-tabelas-principais-por-módulo)
4. [Stored Procedures Principais](#4-stored-procedures-principais)
5. [Endpoints da API e suas SPs](#5-endpoints-da-api-e-suas-sps)
6. [Joins entre Tabelas (Frontend ↔ Banco)](#6-joins-entre-tabelas)
7. [O que Falta Implementar](#7-o-que-falta-implementar)

---

## 1. VISÃO GERAL DA ARQUITETURA

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND (React)                        │
├─────────────────────────────────────────────────────────────────┤
│  /apps/admin        → Painel Administrativo                     │
│  /apps/operacional  → Módulos: Recepção, Triagem, Médico,     │
│                       Enfermagem, Farmácia                      │
│  /apps/painel       → TV Rotativa, Painéis de Chamada          │
│  /apps/totem        → Totem de Senhas, Kiosk Paciente          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    authFetch() / API REST
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      BACKEND (Node.js)                          │
├─────────────────────────────────────────────────────────────────┤
│  /api/auth/*        → Autenticação e Sessão                     │
│  /api/operacional/* → Fluxo operacional                         │
│  /api/fila/*        → Gerenciamento de fila                    │
│  /api/painel/*      → Painéis e totens                         │
│  /api/farmacia/*    → Dispensação de medicamentos               │
│  /api/dispatcher/*  → Dispatcher de SPs (sp_master_*)          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    CALL sp_xxx()
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                     BANCO DE DADOS (MySQL)                      │
├─────────────────────────────────────────────────────────────────┤
│  +200 Stored Procedures (SPs Masters + Operacionais)           │
│  ~122+ Tabelas organizadas por módulo                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. MÓDULOS DO FRONTEND

### Estrutura de Pastas

```
frontend/src/apps/
├── admin/
│   ├── pages/
│   │   ├── Admin.jsx
│   │   └── AdminModulePage.jsx
│   └── security/
│       └── AdminGuard.jsx
│
├── operacional/
│   ├── auth/
│   │   └── RuntimeAuthContext.jsx
│   ├── components/
│   │   └── PatientQueue.jsx
│   ├── layout/
│   │   ├── Layout.jsx
│   │   └── sidebar.css
│   ├── pages/
│   │   ├── Dashboard.jsx
│   │   ├── Login.jsx
│   │   ├── contexto/
│   │   │   └── SelecionarContexto.jsx
│   │   ├── recepcao/
│   │   │   └── Recepcao.jsx
│   │   ├── triagem/
│   │   │   └── Triagem.jsx
│   │   ├── medico/
│   │   │   └── Medico.jsx
│   │   ├── enfermagem/
│   │   │   └── Enfermagem.jsx
│   │   └── farmacia/
│   │       └── Farmacia.jsx
│   └── security/
│       └── SecurityGuard.jsx
│
├── painel/
│   ├── pages/
│   │   ├── Painel.jsx
│   │   └── PainelUsuario.jsx
│
└── totem/
    └── pages/
        └── Totem.jsx
```

### Mapeamento URL ↔ Página

| URL | Página | Módulo |
|-----|--------|--------|
| `/admin` | Admin.jsx | Administrativos |
| `/operacional` | Dashboard.jsx | Portal Operacional |
| `/operacional/recepcao` | Recepcao.jsx | Recepção |
| `/operacional/triagem` | Triagem.jsx | Triagem |
| `/operacional/medico` | Medico.jsx | Atendimento Médico |
| `/operacional/enfermagem` | Enfermagem.jsx | Enfermagem |
| `/operacional/farmacia` | Farmacia.jsx | Farmácia |
| `/painel` | Painel.jsx | Painel TV |
| `/painel/usuario` | PainelUsuario.jsx | Painel Usuario |
| `/totem` | Totem.jsx | Totem Senha |

---

## 3. TABELAS PRINCIPAIS POR MÓDULO

### 3.1 AUTENTICAÇÃO & SESSÃO

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `usuario` | Usuários do sistema | `id_usuario`, `id_pessoa`, `login`, `senha_hash`, `ativo` |
| `sessao_usuario` | Sessões ativas | `id_sessao_usuario`, `id_usuario`, `token`, `ativo`, `expira_em` |
| `perfil` | Perfis de acesso | `id_perfil`, `nome`, `descricao` |
| `usuario_perfil` | Usuario ↔ Perfil | `id_usuario`, `id_perfil` |

### 3.2 PACIENTE & PESSOA

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `pessoa` | Base de pessoas | `id_pessoa`, `nome_completo`, `cpf`, `cns`, `data_nascimento` |
| `paciente` | Dados clínicos | `id`, `id_pessoa`, `prontuario` |
| `pessoa_endereco` | Endereços | `id_pessoa`, `cep`, `logradouro`, `bairro`, `cidade` |
| `acompanhante` | Acompanhantes | `id_pessoa`, `id_ffa`, `tipo` |

### 3.3 FILA, SENHAS & ATENDIMENTO

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `senhas` | Central de senhas | `id`, `codigo`, `status`, `tipo_atendimento`, `prioridade`, `id_paciente` |
| `fila_senha` | Status público | `id_senha`, `status` |
| `senha_eventos` | Auditoria de senhas | `id_senha`, `tipo_evento`, `status_de`, `status_para` |
| `ffa` | Ficha de Atendimento | `id`, `id_paciente`, `id_senha`, `status`, `classificacao_cor` |
| `atendimento` | Registro de visita | `id`, `id_paciente`, `protocolo`, `status` |
| `fila_operacional` | Fila por setor | `id_fila`, `id_ffa`, `tipo`, `substatus`, `prioridade` |
| `fila_operacional_evento` | Auditoria de fila | `id_fila`, `tipo_evento` |

### 3.4 CLÍNICO & TRIAGEM

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `triagem` | Avaliação de risco | `id_triagem`, `id_atendimento`, `id_risco`, `sinais_vitais` |
| `atendimento_sinais_vitais` | Sinais vitais | `id_atendimento`, `pressao_sistolica`, `fc`, `fr`, `temperatura`, `saturacao_o2` |
| `atendimento_evolucao` | Notas clínicas | `id_atendimento`, `descricao`, `tipo_profissional` |
| `atendimento_diagnosticos` | CID-10 | `id_atendimento`, `cid10`, `tipo` |
| `atendimento_prescricao` | Prescrições | `id_atendimento`, `id_medico`, `status` |

### 3.5 FARMÁCIA & MEDICAMENTOS

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `farmaco` | Catálogo de meds | `id`, `codigo`, `nome`, `principio_ativo`, `concentracao` |
| `farmaco_lote` | Lotes | `id_farmaco`, `lote`, `validade`, `quantidade_saldo` |
| `dispensacao_medicacao` | Dispensação | `id_atendimento`, `id_farmaco`, `quantidade`, `status` |
| `gpat_atendimento` | Prescrição GPAT | `id_ffa`, `tipo_prescritor`, `status` |
| `gpat_item` | Itens da prescrição | `id_gpat`, `id_farmaco`, `posologia`, `status` |
| `gpat_dispensacao` | Dispensação GPAT | `id_gpat_item`, `quantidade_dispensada` |
| `administracao_medicacao` | Admin real | `id_atendimento`, `dose_administrada`, `via` |

### 3.6 DISPOSITIVOS (PAINEL, TOTEM, KIOSK)

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `dispositivo` | Dispositivos | `id_dispositivo`, `nome`, `tipo` (PAINEL/TOTEM/TERMINAL), `mac_address`, `token_auth` |
| `painel` | Config de painéis | `id_painel`, `codigo`, `tipo` (PAINEL/TV/TOTEM), `nome`, `intervalo_segundos`, `emite_som` |
| `painel_config` | Config KEY-VALUE | `id_painel`, `chave`, `valor_text`, `valor_json` |
| `local_operacional` | Locais internos | `id_local_operacional`, `nome`, `tipo` (TRIAGEM/CONSULTORIO/FARMACIA) |

### 3.7 ESTOQUE & ALMOXARIFADO

| Tabela | Descrição | Campos Importantes |
|--------|-----------|-------------------|
| `estoque_produto` | Catálogo produtos | `id`, `codigo`, `nome`, `unidade_padrao` |
| `estoque_almoxarifado` | Saldo por local | `id_produto`, `id_local_operacional`, `quantidade_atual` |
| `estoque_movimento` | Movimentação | `id_produto`, `tipo_movimento`, `quantidade` |

---

## 4. STORED PROCEDURES PRINCIPAIS

### 4.1 Masters (Orquestrador)

| SP | Descrição | Parâmetros |
|----|-----------|------------|
| `sp_master_dispatcher` | Orquestrador central | `p_acao`, `p_payload_json` |
| `sp_master_dispatcher_runtime` | Runtime de execução | `p_acao`, `p_payload_json`, `p_id_sessao` |
| `sp_master_senha_emitir` | Gera nova senha | `p_id_sessao`, `p_tipo`, `p_origem` |
| `sp_master_senha_chamar` | Chama senha | `p_id_sessao`, `p_id_unidade`, `p_id_local` |
| `sp_master_atendimento_iniciar` | Inicia atendimento | `p_id_paciente`, `p_tipo` |
| `sp_master_atendimento_transicionar` | Transiciona status | `p_id_atendimento`, `p_status` |
| `sp_master_atendimento_finalizar` | Finaliza atendimento | `p_id_atendimento` |

### 4.2 Operacionais (por módulo)

#### Recepção & Senhas

| SP | Descrição |
|----|-----------|
| `sp_senha_emitir` | Gera senha no totem/recepção |
| `sp_senha_chamar` | Chama próxima senha |
| `sp_senha_finalizar` | Finaliza atendimento de senha |
| `sp_recepcao_iniciar_complementacao` | Inicia complementação dados |
| `sp_recepcao_complementar_e_abrir_ffa` | Complementa e abre FFA |

#### Triagem

| SP | Descrição |
|----|-----------|
| `sp_triagem_registrar` | Registra triagem |
| `sp_triagem_classificar` | Classifica risco |

#### Médico

| SP | Descrição |
|----|-----------|
| `sp_atendimento_iniciar` | Inicia consulta médica |
| `sp_atendimento_evolucao_salvar` | Salva evolução |
| `sp_atendimento_prescrever` | Prescreve medicamento |

#### Farmácia

| SP | Descrição |
|----|-----------|
| `sp_farmacia_dispensar` | Dispensar medicamento |
| `sp_farmacia_consultar_pendentes` | Lista pendências |

#### Painel & Totem

| SP | Descrição |
|----|-----------|
| `sp_painel_listar_chamadas` | Lista chamadas ativas |
| `sp_painel_atualizar` | Atualiza painel |
| `sp_totem_autenticar` | Autentica totem |

---

## 5. ENPOINTS DA API E SUAS SPs

### 5.1 Autenticação

| Endpoint | Método | SP/Query | Descrição |
|----------|--------|----------|-----------|
| `/api/auth/login` | POST | `sp_auth_login` | Login usuário |
| `/api/auth/logout` | POST | `sp_auth_logout` | Logout |
| `/api/auth/validar` | GET | `sp_auth_validar_sessao` | Valida sessão |
| `/api/auth/permissoes` | GET | `sp_auth_permissoes` | Lista permissões |

### 5.2 Operacional

| Endpoint | Método | SP/Query | Descrição |
|----------|--------|----------|-----------|
| `/api/operacional/pacientes` | GET | Query JOIN | Busca paciente |
| `/api/operacional/atendimentos` | POST | `sp_master_atendimento_iniciar` | Inicia atendimento |
| `/api/operacional/senhas` | POST | `sp_senha_emitir` | Gera senha |

### 5.3 Fila

| Endpoint | Método | SP/Query | Descrição |
|----------|--------|----------|-----------|
| `/api/fila` | GET | Query SELECT | Lista fila |
| `/api/fila/chamar` | POST | `sp_senha_chamar` | Chama paciente |

### 5.4 Farmácia

| Endpoint | Método | SP/Query | Descrição |
|----------|--------|----------|-----------|
| `/api/farmacia/pendentes` | GET | Query SELECT | Lista pendentes |
| `/api/farmacia/prescricoes/:id` | GET | Query SELECT | Lista prescrições |
| `/api/farmacia/dispensar` | POST | `sp_farmacia_dispensar` | Dispensar |

### 5.5 Painel & Totem

| Endpoint | Método | SP/Query | Descrição |
|----------|--------|----------|-----------|
| `/api/painel/chamadas` | GET | Query SELECT | Lista chamadas |
| `/api/painel/executar` | POST | ACTION_DEFS | Executa ação totem |
| `/api/totem/emitir` | POST | `sp_senha_emitir` | Emite senha totem |

---

## 6. JOINS ENTRE TABELAS (FRONTEND ↔ BANCO)

### 6.1 Busca de Paciente na Recepção

```sql
-- Query atual em filaRoutes.js (linha 21-50)
SELECT 
    fo.id_fila,
    fo.id_paciente,
    fo.id_unidade,
    fo.id_local_operacional,
    fo.status,
    fo.prioridade,
    fo.posicao,
    fo.data_entrada,
    fo.data_atendimento,
    p.nome as paciente_nome,
    p.cns as paciente_cns,
    lo.nome as local_nome,
    u.nome as unidade_nome
FROM fila_operacional fo
LEFT JOIN paciente p ON p.id = fo.id_paciente
LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
LEFT JOIN unidade u ON u.id_unidade = fo.id_unidade
```

**JOINs necessários que FALTAM:**
- `pessoa` para pegar `nome_completo`, `cpf`, `data_nascimento`
- `senhas` para mostrar código da senha na fila

### 6.2 Busca de Paciente (Recepcao.jsx linha 27)

```javascript
// Frontend chama:
const res = await authFetch(`/api/operacional/pacientes?termo=${searchTerm}`);

// Backend (deve implementar):
SELECT 
    pac.id,
    pes.nome_completo,
    pes.cpf,
    pes.cns,
    pes.data_nascimento,
    pes.sexo,
    pac.prontuario
FROM paciente pac
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
WHERE pes.nome_completo LIKE ? OR pes.cpf = ? OR pes.cns = ?
```

### 6.3 Farmácia - Dispensação Pendente

```sql
-- Query atual em farmaciaRoutes.js (linha 21-40)
SELECT 
    fd.id_farmacia_dispensacao,
    fd.id_paciente,
    fd.id_prescricao,
    fd.status,
    fd.data_solicitacao,
    fd.data_dispensacao,
    p.nome as paciente_nome,
    p.cns as paciente_cns,
    u.nome as solicitante_nome
FROM farmacia_dispensacao fd
LEFT JOIN paciente p ON p.id = fd.id_paciente
LEFT JOIN usuario u ON u.id_usuario = fd.id_solicitante
```

**JOINs necessários que FALTAM:**
- `pessoa` para `nome_completo`
- `ffa` para vincular ao atendimento
- `atendimento_prescricao` para dados da prescrição

### 6.4 Painel de Chamadas

```sql
-- Query necessária para TV Rotativa / Painel
SELECT 
    s.codigo,
    s.status,
    s.tipo_atendimento,
    lo.nome as local_chamada,
    p.nome_completo as paciente_nome,
    TIMESTAMPDIFF(MINUTE, s.criada_em, NOW()) as tempo_espera
FROM senhas s
LEFT JOIN local_operacional lo ON lo.id_local_operacional = s.id_local_operacional
LEFT JOIN paciente pac ON pac.id = s.id_pessoa
LEFT JOIN pessoa p ON p.id_pessoa = pac.id_pessoa
WHERE s.data_ref = CURDATE()
AND s.status IN ('AGUARDANDO', 'CHAMANDO')
ORDER BY s.prioridade DESC, s.criada_em ASC
```

### 6.5 Fila Operacional Completa

```sql
-- Query necessária para Dashboard de Fila
SELECT 
    fo.id_fila,
    fo.tipo as setor,
    fo.substatus,
    fo.prioridade,
    fo.data_entrada,
    TIMESTAMPDIFF(MINUTE, fo.data_entrada, NOW()) as tempo_espera,
    ffa.id as id_ffa,
    pac.prontuario,
    pes.nome_completo as paciente_nome,
    pes.cpf,
    pes.data_nascimento,
    tr.classificacao_cor,
    lo.nome as local_nome,
    u.nome as responsavel_nome
FROM fila_operacional fo
LEFT JOIN ffa ON ffa.id = fo.id_ffa
LEFT JOIN paciente pac ON pac.id = ffa.id_paciente
LEFT JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
LEFT JOIN triagem tr ON tr.id_atendimento = ffa.id_atendimento
LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
LEFT JOIN usuario u ON u.id_usuario = fo.id_responsavel
WHERE fo.id_unidade = ?
ORDER BY 
    CASE fo.prioridade
        WHEN 'EMERGENCIA' THEN 1
        WHEN 'URGENTE' THEN 2
        WHEN 'PREFERENCIAL' THEN 3
        ELSE 4
    END,
    fo.data_entrada ASC
```

---

## 7. O QUE FALTA IMPLEMENTAR

### 7.1 Tabelas para Farmácia de Rua (PDV)

| Tabela | Descrição | Status |
|--------|-----------|--------|
| `caixa` | Controle de caixas | ❌ Não existe |
| `caixa_movimento` | Movimentos de caixa | ❌ Não existe |
| `venda` | Vendas balcão | ❌ Não existe |
| `venda_item` | Itens de venda | ❌ Não existe |
| `cliente` | Clientes particulares | ❌ Não existe |

### 7.2 Tabelas para Kiosk Paciente

| Tabela | Descrição | Status |
|--------|-----------|--------|
| `kiosk_solicitacao` | Solicitações kiosk | ❌ Não existe |
| `kiosk_feedback` | Feedback satisfação | ❌ Não existe |

### 7.3 SPs que Precisa Criar

| SP | Módulo | Descrição |
|----|--------|-----------|
| `sp_master_caixa_abrir` | Farmácia | Abre caixa |
| `sp_master_caixa_fechar` | Farmácia | Fecha caixa |
| `sp_master_venda_registrar` | Farmácia | Registra venda |
| `sp_master_venda_cancelar` | Farmácia | Cancela venda |
| `sp_master_kiosk_solicitacao` | Kiosk | Registra solicitação |
| `sp_master_painel_pediatrico` | Painel | Painel pediátrico |
| `sp_master_painel_tv_rotativa` | Painel | TV rotativa |

### 7.4 Perfis que Precisa Criar/Validar

| Perfil | Descrição | Frontend |
|--------|-----------|----------|
| `ROOT` | Administrador total | /admin |
| `ADMIN` | Administrativo | /admin |
| `ADMINISTRATIVO` | Gestão | /admin |
| `SUPORTE_TI` | Suporte | /admin |
| `MEDICO` | Atendimento médico | /operacional/medico |
| `ENFERMAGEM` | Triagem/enfermagem | /operacional/enfermagem |
| `FARMACIA` | Dispensação | /operacional/farmacia |
| `CAIXA` | Farmácia de rua | /operacional/caixa |
| `PAINEL` | Visualização | /painel |
| `TOTEM` | Emissão senha | /totem |

### 7.5 Problemas Identificados

1. **Admin entrando como médico:** Falta validação de perfil no frontend
   - Solução: Verificar `usuario_perfil` antes de renderizar página

2. **Totem abrindo módulo errado:** Falta autenticação por dispositivo
   - Solução: Validar `dispositivo.tipo` = 'TOTEM' na autenticação

3. **Faltam joins em várias queries:**
   - `fila_operacional` sem `pessoa` (nome do paciente)
   - `farmacia_dispensacao` sem `ffa` (atendimento)
   - `senhas` sem dados do paciente

---

## 📌 RESUMO: FLUXO DE DADOS

```
┌──────────────────────────────────────────────────────────────────┐
│ FRONTEND (Recepção.jsx)                                         │
│ authFetch('/api/operacional/pacientes?termo=...')               │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│ BACKEND (operacionalRoutes.js)                                  │
│ GET /api/operacional/pacientes                                   │
│ Query: SELECT * FROM paciente JOIN pessoa WHERE ...             │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│ BANCO: paciente + pessoa                                         │
│ id | nome_completo | cpf | cns | data_nascimento                │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│ RETORNO JSON                                                     │
│ { pacientes: [{ id, nome, cpf, cns, prontuario }] }            │
└──────────────────────────────────────────────────────────────────┘
```

---

## ✅ PRÓXIMOS PASSOS

1. **Criar seed inicial** com dados de teste
2. **Implementar queries com joins corretos** nas rotas
3. **Criar tabelas de farmácia de rua** (caixa, venda)
4. **Validar perfil do usuário** no frontend (guard)
5. **Testar integração frontend ↔ backend ↔ banco**

---

*Documento gerado automaticamente em 11/03/2026*
