# MAPA COMPLETO: FRONTEND ↔ TABELAS ↔ SPs

**Data:** 11/03/2026  
**Sistema:** Pronto Atendimento / UPA

---

## 1. FLUXO DE CONTEXTO APÓS LOGIN

O sistema já possui o contexto implementado corretamente:

```
Login → /api/auth/meus-contextos → 
   [
     { id_unidade, id_local_operacional, id_perfil, perfil_nome, local_nome }
   ]
   
   ↓
   
Se 1 resultado → Já seleciona automaticamente
Se +1 resultado → Usuário seleciona:
   - UNIDADE (se tiver mais de 1)
   - ESPECIALIDADE/Perfil (se tiver mais de 1)
   - SALA/Local Operacional (se tiver mais de 1)
   
   ↓
   
/api/auth/selecionar-contexto → Sessão atualizada com contexto
```

### Tabelas de Contexto

| Tabela | Descrição | Campos |
|--------|-----------|--------|
| `usuario_contexto` | Contexto ativo do usuário | `id_usuario`, `id_unidade`, `id_local_operacional`, `id_perfil`, `ativo` |
| `usuario_local_operacional` | Locais que o usuário pode acessar | `id_usuario`, `id_local_operacional` |
| `unidade` | Unidades (hospitais, UPAs) | `id_unidade`, `nome`, `cnes` |
| `local_operacional` | Salas/Locais internos | `id_local_operacional`, `nome`, `tipo` |
| `perfil` | Perfis de acesso | `id_perfil`, `nome` |

### Selects do Contexto

```sql
-- Buscar contextos do usuário
SELECT 
    uc.id_unidade,
    uc.id_local_operacional,
    uc.id_perfil,
    un.nome AS unidade_nome,
    lo.nome AS local_nome,
    p.nome AS perfil_nome
FROM usuario_contexto uc
JOIN unidade un ON un.id_unidade = uc.id_unidade
JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
JOIN perfil p ON p.id_perfil = uc.id_perfil
WHERE uc.id_usuario = ? AND uc.ativo = 1
```

---

## 2. PÁGINAS DO FRONTEND E SUAS TABELAS

### 2.1 RECEPÇÃO (`/operacional/recepcao`)

**Arquivo:** [`Recepcao.jsx`](frontend/src/apps/operacional/pages/recepcao/Recepcao.jsx)

**Funcionalidades:**
1. Buscar paciente por CPF/Nome
2. Abrir FFA (Formulário de Folhas de Atendimento)
3. Gerar senha
4. Ver fila de espera

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Buscar paciente | GET `/api/operacional/pacientes?termo=` | `pessoa` + `paciente` | `nome_completo`, `cpf`, `cns`, `data_nascimento`, `telefone`, `prontuario` |
| Abrir FFA | POST `/api/operacional/atendimentos` | `atendimento`, `ffa`, `senhas` | `id_paciente`, `tipo_atendimento`, `protocolo` |
| Gerar senha | POST `/api/operacional/senhas` | `senhas` | `codigo`, `tipo_atendimento`, `prefixo` |
| Ver fila | GET `/api/fila` | `fila_operacional` | `id_fila`, `id_paciente`, `status`, `prioridade`, `data_entrada` |

**Query de busca paciente (atual):**
```sql
-- Em filaRoutes.js linha 21-50
SELECT 
    fo.id_fila,
    fo.id_paciente,
    p.nome as paciente_nome,  -- FALTA JOIN com pessoa!
    p.cns as paciente_cns,    -- FALTA JOIN com pessoa!
    lo.nome as local_nome,
    u.nome as unidade_nome
FROM fila_operacional fo
LEFT JOIN paciente p ON p.id = fo.id_paciente
LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
LEFT JOIN unidade u ON u.id_unidade = fo.id_unidade
```

**Query CORRETA que precisa implementar:**
```sql
SELECT 
    fo.id_fila,
    fo.id_paciente,
    fo.status,
    fo.prioridade,
    fo.posicao,
    fo.data_entrada,
    fo.data_atendimento,
    pes.nome_completo as paciente_nome,
    pes.cpf as paciente_cpf,
    pes.cns as paciente_cns,
    pes.data_nascimento,
    pes.telefone,
    pac.prontuario,
    lo.nome as local_nome,
    un.nome as unidade_nome,
    s.codigo as senha_codigo
FROM fila_operacional fo
LEFT JOIN paciente pac ON pac.id = fo.id_paciente
LEFT JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
LEFT JOIN unidade un ON un.id_unidade = fo.id_unidade
LEFT JOIN senhas s ON s.id = fo.id_senha
WHERE fo.id_unidade = ?
AND fo.status IN ('AGUARDANDO', 'CHAMANDO', 'EM_ATENDIMENTO')
ORDER BY 
    CASE fo.prioridade
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        ELSE 5
    END,
    fo.posicao ASC
```

---

### 2.2 TRIAGEM (`/operacional/triagem`)

**Arquivo:** [`Triagem.jsx`](frontend/src/apps/operacional/pages/triagem/Triagem.jsx)

**Funcionalidades:**
1. Chamar próximo paciente da fila de triagem
2. Registrar sinais vitais
3. Classificar risco (vermelho, laranja, amarelo, verde, azul)
4. Finalizar triagem e encaminhar para médico
5. Ver fila de triagem

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Chamar paciente | POST `/api/operacional/atendimentos/chamar` | `fila_operacional` | `id_fila`, `status`, `id_responsavel` |
| Finalizar triagem | PUT `/api/operacional/atendimentos/:id` | `triagem`, `atendimento_sinais_vitais` | `sinais_vitais`, `prioridade`, `observacoes` |
| Encaminhar | POST `/api/operacional/atendimentos/:id/encaminhar` | `fila_operacional` | `destino`, `id_local_operacional` |
| Ver fila triagem | GET `/api/triagem/fila` | `fila_operacional` | `id_fila`, `id_paciente`, `status` |

**Sinais Vitais (campos do formulário):**
```javascript
const [vitalSigns, setVitalSigns] = useState({
    pressao_sistolica: "",      // mmHg
    pressao_diastolica: "",     // mmHg
    temperatura: "",            // °C
    frecuencia_cardiaca: "",    // bpm
    saturacao: "",              // %
    respiracao: "",             // irpm
    peso: "",                   // kg
    altura: ""                 // cm
});
```

**Classificação de Risco:**
```javascript
const riskLevels = [
    { value: 1, label: "Emergência", color: "#dc2626", icon: "🔴" },
    { value: 2, label: "Muito Urgente", color: "#f97316", icon: "🟠" },
    { value: 3, label: "Urgente", color: "#eab308", icon: "🟡" },
    { value: 4, label: "Pouco Urgente", color: "#22c55e", icon: "🟢" },
    { value: 5, label: "Não Urgente", color: "#3b82f6", icon: "🔵" }
];
```

**Query de busca de pacientes para triagem:**
```sql
-- Em triagemRoutes.js linha 31
SELECT 
    fo.id_fila,
    fo.id_paciente,
    fo.prioridade,
    fo.status,
    fo.data_entrada,
    TIMESTAMPDIFF(MINUTE, fo.data_entrada, CURDATE()) as tempo_espera,
    p.nome as paciente_nome,  -- FALTA JOIN com pessoa!
    p.cns as paciente_cns,    -- FALTA JOIN com pessoa!
    TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE()) as idade
FROM fila_operacional fo
LEFT JOIN paciente p ON p.id = fo.id_paciente
WHERE fo.id_local_operacional = ?  -- Local de triagem
AND fo.status = 'AGUARDANDO'
```

---

### 2.3 MÉDICO (`/operacional/medico`)

**Arquivo:** [`Medico.jsx`](frontend/src/apps/operacional/pages/medico/Medico.jsx)

**Funcionalidades:**
1. Chamar próximo paciente da fila médica
2. Registrar evolução clínica
3. Prescrever medicamentos (GPAT)
4. Solicitar exames
5. Encaminhar para outros setores
6. Finalizar atendimento

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Chamar paciente | POST `/api/operacional/atendimentos/chamar` | `fila_operacional` | `id_fila`, `status` |
| Salvar evolução | POST `/api/operacional/atendimentos/:id/evolucao` | `atendimento_evolucao` | `descricao`, `tipo_profissional` |
| Prescrever | POST `/api/operacional/atendimentos/:id/prescricao` | `gpat_atendimento`, `gpat_item` | `id_farmaco`, `posologia`, `quantidade` |
| Solicitar exame | POST `/api/operacional/atendimentos/:id/exame` | `atendimento_pedidos_exame` | `id_exame`, `observacao` |
| Finalizar | POST `/api/operacional/atendimentos/:id/finalizar` | `atendimento`, `ffa` | `status`, `destino_alta` |

**Campos de Evolução Clínica:**
```javascript
// Deve ter campos de:
- Historico da doença atual
- Exame físico
- Hipótese diagnóstica (CID-10)
- Conduta/tratamento
```

**Query para buscar atendimentos médicos:**
```sql
SELECT 
    fo.id_fila,
    fo.id_ffa,
    fo.id_paciente,
    fo.status as fila_status,
    fo.data_entrada,
    ffa.id_atendimento,
    ffa.classificacao_cor,
    pes.nome_completo as paciente_nome,
    pes.cpf,
    pes.data_nascimento,
    TIMESTAMPDIFF(YEAR, pes.data_nascimento, CURDATE()) as idade,
    pes.sexo,
    pac.prontuario,
    tr.classificacao_risco
FROM fila_operacional fo
JOIN ffa ON ffa.id = fo.id_ffa
JOIN paciente pac ON pac.id = ffa.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
LEFT JOIN triagem tr ON tr.id_atendimento = ffa.id_atendimento
WHERE fo.id_local_operacional = ?  -- Consultório/Médico
AND fo.status IN ('AGUARDANDO', 'CHAMANDO')
```

---

### 2.4 ENFERMAGEM (`/operacional/enfermagem`)

**Arquivo:** [`Enfermagem.jsx`](frontend/src/apps/operacional/pages/enfermagem/Enfermagem.jsx)

**Funcionalidades:**
1. Ver fila de enfermagem/medicação
2. Administrar medicamentos
3. Registrar sinais vitais
4. Preparar paciente para procedimentos

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Ver fila medicação | GET `/api/enfermagem/fila` | `fila_operacional`, `ordem_assistencial_item` | `id_item`, `medicamento`, `dose`, `via` |
| Administrar | POST `/api/enfermagem/administrar` | `administracao_medicacao_ordem` | `id_item`, `quantidade`, `status` |
| Registrar sinais | POST `/api/enfermagem/sinais-vitais` | `atendimento_sinais_vitais` | `pressao_sistolica`, `fc`, `temperatura`, etc. |

---

### 2.5 FARMÁCIA (`/operacional/farmacia`)

**Arquivo:** [`Farmacia.jsx`](frontend/src/apps/operacional/pages/farmacia/Farmacia.jsx)

**Funcionalidades:**
1. Ver dispensações pendentes
2. Buscar medicamentos em estoque
3. Dispensar medicamentos (GPAT)
4. Ver histórico de dispensação

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Ver pendentes | GET `/api/farmacia/pendentes` | `gpat_atendimento`, `gpat_item` | `id_gpat`, `id_paciente`, `status` |
| Buscar meds | GET `/api/farmacia/medicamentos?termo=` | `farmaco` | `nome`, `principio_ativo`, `concentracao` |
| Dispensar | POST `/api/farmacia/dispensar` | `gpat_dispensacao`, `farmaco_lote` | `id_gpat_item`, `quantidade` |
| Ver estoque | GET `/api/farmacia/estoque` | `farmaco_lote` | `id_farmaco`, `lote`, `quantidade_saldo` |

**Query de dispensações pendentes (atual):**
```sql
-- Em farmaciaRoutes.js linha 21-40
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

**Query CORRETA (com joins faltando):**
```sql
SELECT 
    gpat.id as id_gpat,
    gpat.id_ffa,
    gpat.data_emissao,
    gpat.data_validade,
    gpat.status as gpat_status,
    gpat.tipo_prescritor,
    gpat.nome_prescritor,
    pes.nome_completo as paciente_nome,
    pes.cpf as paciente_cpf,
    pes.cns as paciente_cns,
    pac.prontuario,
    un.nome as unidade_nome,
    item.id as id_item,
    item.id_farmaco,
    item.quantidade_total,
    item.posologia,
    item.status as item_status,
    f.nome as medicamento_nome,
    f.concentracao,
    f.principio_ativo
FROM gpat_atendimento gpat
JOIN gpat_item item ON item.id_gpat = gpat.id
JOIN ffa ON ffa.id = gpat.id_ffa
JOIN paciente pac ON pac.id = ffa.id_pessoa
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
JOIN unidade un ON un.id_unidade = gpat.id_unidade
JOIN farmaco f ON f.id = item.id_farmaco
WHERE gpat.status IN ('ABERTO', 'DISPENSADO')
AND item.status IN ('PENDENTE_DISPENSACAO', 'DISPENSADO')
ORDER BY gpat.data_emissao DESC
```

---

### 2.6 PAINEL / TV ROTATIVA (`/painel`)

**Arquivo:** [`Painel.jsx`](frontend/src/apps/painel/pages/Painel.jsx)

**Funcionalidades:**
1. Exibir chamadas de senha
2. Mostrar fila de espera
3. Exibir informações do paciente chamado

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Ver chamadas | GET `/api/painel/chamadas` | `senhas`, `local_operacional` | `codigo`, `status`, `nome_local` |
| Atualizar | GET (polling) | `painel_config` | `intervalo_segundos` |

**Configurações de painel:**
```sql
SELECT 
    p.id_painel,
    p.codigo,
    p.nome,
    p.tipo,  -- PAINEL, TOTEM, TV
    p.intervalo_segundos,
    p.emite_som,
    p.tts_habilitado,
    pc.chave,
    pc.valor_text,
    pc.valor_json
FROM painel p
LEFT JOIN painel_config pc ON pc.id_painel = p.id_painel
WHERE p.ativo = 1
```

---

### 2.7 TOTEM (`/totem`)

**Arquivo:** [`Totem.jsx`](frontend/src/apps/totem/pages/Totem.jsx)

**Funcionalidades:**
1. Emitir senha (sem login)
2. Ver posição na fila
3. Ver tempo estimado de espera

**Endpoints e Tabelas:**

| Ação | Endpoint | Tabela(s) | Campos |
|------|----------|-----------|--------|
| Emitir senha | POST `/api/totem/emitir` | `senhas` | `codigo`, `tipo_atendimento`, `prefixo` |
| Ver posição | GET `/api/totem/posicao/:codigo` | `senhas`, `fila_operacional` | `posicao`, `tempo_espera` |

---

## 3. CAMPOS POR TABELA (PARA FRONTEND)

### 3.1 Tabela: `pessoa`
```javascript
{
    id_pessoa: 1,
    nome_completo: "João Silva Santos",
    nome_social: "João",
    cpf: "123.456.789-00",
    cns: "123456789012345",
    rg: "123456789",
    data_nascimento: "1990-05-15",
    sexo: "M",  // M, F, O
    nome_mae: "Maria Silva Santos",
    email: "joao@email.com",
    telefone: "(11) 99999-9999"
}
```

### 3.2 Tabela: `paciente`
```javascript
{
    id: 1,
    id_pessoa: 1,
    prontuario: "PR000001",
    cns_vigente: "123456789012345"
}
```

### 3.3 Tabela: `senhas`
```javascript
{
    id: 1,
    id_sistema: 1,
    id_unidade: 1,
    numero: 1,
    prefixo: "A",
    codigo: "A001",
    data_ref: "2026-03-11",
    status: "AGUARDANDO",  // GERADA, AGUARDANDO, CHAMANDO, EM_COMPLEMENTACAO, ENCAMINHADO, EM_ATENDIMENTO, NAO_COMPARECEU, FINALIZADO, CANCELADO
    tipo_atendimento: "CLINICO",  // CLINICO, PEDIATRICO, PRIORITARIO, EMERGENCIA
    prioridade: 0,
    origem: "TOTEM",  // TOTEM, RECEPCAO, ADMIN, SAMU
    lane: "ADULTO",  // ADULTO, PEDIATRICO, PRIORITARIO
    id_paciente: 1,
    id_local_operacional: 1,
    criada_em: "2026-03-11 10:00:00",
    chamada_em: null,
    inicio_atendimento_em: null,
    finalizada_em: null
}
```

### 3.4 Tabela: `ffa` (Ficha de Folhas de Atendimento)
```javascript
{
    id: 1,
    id_paciente: 1,
    id_senha: 1,
    id_atendimento: 1,
    status: "EM_TRIAGEM",  // ABERTO, EM_TRIAGEM, AGUARDANDO_CHAMADA_MEDICO, EM_ATENDIMENTO_MEDICO, ENCAMINHADO, INTERNADO, FINALIZADO
    classificacao_cor: "AMARELO",  // VERMELHO, LARANJA, AMARELO, VERDE, AZUL
    motivo: "Dor abdominal",
    retorno_ativo: 0,
    criado_em: "2026-03-11 10:00:00",
    data_triagem: "2026-03-11 10:15:00",
    data_chamada_medico: "2026-03-11 10:30:00"
}
```

### 3.5 Tabela: `atendimento`
```javascript
{
    id: 1,
    id_unidade: 1,
    id_paciente: 1,
    id_senha: 1,
    origem: "TOTEM",
    protocolo: "GPAT-20260311-0000000001",
    status: "ABERTO",  // ABERTO, FINALIZANDO, FINALIZADO
    criado_em: "2026-03-11 10:00:00",
    atualizado_em: "2026-03-11 10:30:00"
}
```

### 3.6 Tabela: `fila_operacional`
```javascript
{
    id_fila: 1,
    id_ffa: 1,
    id_paciente: 1,
    id_unidade: 1,
    id_local_operacional: 1,
    tipo: "TRIAGEM",  // TRIAGEM, MEDICO, RX, ECG, MEDICACAO, etc.
    substatus: "AGUARDANDO",  // AGUARDANDO, CHAMANDO, EM_EXECUCAO, FINALIZADO
    prioridade: "AMARELO",  // VERMELHO, LARANJA, AMARELO, VERDE, AZUL
    posicao: 1,
    data_entrada: "2026-03-11 10:00:00",
    entrada_original_em: "2026-03-11 10:00:00",
    data_inicio: null,
    data_fim: null,
    id_responsavel: null,
    observacao: null
}
```

### 3.7 Tabela: `triagem`
```javascript
{
    id_triagem: 1,
    id_atendimento: 1,
    id_risco: 1,  // FK para classificacao_risco
    queixa: "Dor abdominal intensa",
    sinais_vitais: JSON,  // { pa: "120/80", fc: 80, etc. }
    observacao: "Paciente lúcido,汗出",
    id_enfermeiro: 3,
    data_hora: "2026-03-11 10:15:00"
}
```

### 3.8 Tabela: `local_operacional`
```javascript
{
    id_local_operacional: 1,
    id_unidade: 1,
    nome: "Recepção Principal",
    tipo: "RECEPCAO",  // RECEPCAO, TRIAGEM, CONSULTORIO, RX, LABORATORIO, FARMACIA, MEDICACAO
    complexidade: "MEDIA",
    exibe_em_painel_publico: 1,
    gera_tts_publico: 1,
    ativo: 1
}
```

---

## 4. SPs PRINCIPAIS E SEUS PARÂMETROS

### 4.1 Senhas e Fila

```sql
-- Gerar senha
CALL sp_senha_emitir(
    p_id_sessao_usuario BIGINT,
    p_tipo_atendimento VARCHAR(20),  -- CLINICO, PEDIATRICO, PRIORITARIO
    p_origem VARCHAR(20)              -- TOTEM, RECEPCAO
);

-- Chamar senha
CALL sp_senha_chamar(
    p_id_sessao_usuario BIGINT,
    p_id_unidade BIGINT,
    p_id_local_operacional BIGINT,
    p_id_saas_entidade BIGINT
);

-- Finalizar senha
CALL sp_senha_finalizar(
    p_id_sessao_usuario BIGINT,
    p_id_senha BIGINT
);
```

### 4.2 Atendimento

```sql
-- Iniciar atendimento
CALL sp_atendimento_iniciar(
    p_id_paciente BIGINT,
    p_tipo_atendimento VARCHAR(20),
    p_id_unidade BIGINT,
    p_id_local_operacional BIGINT,
    p_id_sessao_usuario BIGINT,
    OUT p_id_atendimento BIGINT,
    OUT p_id_ffa BIGINT
);

-- Transicionar atendimento
CALL sp_atendimento_transicionar(
    p_id_atendimento BIGINT,
    p_novo_status VARCHAR(30),
    p_id_usuario BIGINT,
    OUT p_resultado VARCHAR(100)
);

-- Finalizar atendimento
CALL sp_atendimento_finalizar(
    p_id_atendimento BIGINT,
    p_destino_alta VARCHAR(30),  -- ALTA, INTERNACAO, TRANSFERENCIA
    p_id_usuario BIGINT
);
```

### 4.3 Triagem

```sql
-- Registrar triagem
CALL sp_triagem_registrar(
    p_id_atendimento BIGINT,
    p_id_enfermeiro BIGINT,
    p_queixa TEXT,
    p_sinais_vitais JSON,
    p_classificacao_risco VARCHAR(20),
    p_observacao TEXT,
    OUT p_id_triagem BIGINT
);
```

### 4.4 Farmácia

```sql
-- Dispensar medicamento
CALL sp_farmacia_dispensar(
    p_id_gpat_item BIGINT,
    p_id_usuario_dispensador BIGINT,
    p_quantidade_dispensada DECIMAL(10,2),
    OUT p_resultado VARCHAR(100)
);

-- Buscar estoque
CALL sp_farmacia_consultar_estoque(
    p_termo_busca VARCHAR(100),
    p_id_local_operacional BIGINT
);
```

---

## 5. RESUMO: O QUE FALTA IMPLEMENTAR

### 5.1 Queries para Corrigir (Joins Faltando)

| Arquivo | Problema |
|---------|----------|
| `filaRoutes.js` | Faltam joins com `pessoa` e `senhas` |
| `triagemRoutes.js` | Faltam joins com `pessoa` |
| `farmaciaRoutes.js` | Faltam joins com `gpat_item`, `farmaco`, `ffa`, `pessoa` |

### 5.2 Páginas para Criar/Completar

| Página | Status | O que falta |
|--------|--------|-------------|
| Painel TV Rotativa | Parcial | Configuração de tipos (pediátrico, clínico) |
| Kiosk Paciente | ❌ Não existe | Página de autoatendimento |
| Farmácia de Rua (PDV) | ❌ Não existe | Tabelas: caixa, venda, cliente |

### 5.3 Tabelas para Farmácia de Rua

```sql
-- CAIXA
CREATE TABLE caixa (
    id_caixa BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_unidade BIGINT,
    id_usuario_abertura BIGINT,
    id_usuario_fechamento BIGINT,
    data_abertura DATETIME,
    data_fechamento DATETIME,
    saldo_inicial DECIMAL(12,2),
    saldo_final DECIMAL(12,2),
    status ENUM('ABERTO', 'FECHADO')
);

-- VENDA
CREATE TABLE venda (
    id_venda BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_caixa BIGINT,
    id_paciente BIGINT,  -- pode ser NULL para cliente particular
    cliente_nome VARCHAR(200),
    cliente_cpf VARCHAR(14),
    valor_total DECIMAL(12,2),
    valor_pago DECIMAL(12,2),
    troco DECIMAL(12,2),
    forma_pagamento VARCHAR(20),
    status ENUM('PENDENTE', 'PAGO', 'CANCELADO'),
    data_venda DATETIME
);

-- VENDA_ITEM
CREATE TABLE venda_item (
    id_venda_item BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_venda BIGINT,
    id_farmaco BIGINT,
    quantidade INT,
    valor_unitario DECIMAL(12,2),
    valor_total DECIMAL(12,2)
);
```

---

## 6. PRÓXIMOS PASSOS

1. ✅ Contexto de seleção (Unidade/Especialidade/Sala) - **IMPLEMENTADO**
2. Corrigir queries com joins faltantes
3. Completar frontend de Farmácia
4. Criar tabela de farmácia de rua (caixa, venda)
5. Criar página de Kiosk Paciente
6. Criar Seed inicial completo

---

*Documento gerado em 11/03/2026*
