# ANÁLISE COMPLETA: DUMP BANCO × FRONTEND × SPs × LANDING PAGES

**Data:** 17/03/2026  
**Sistema:** Pronto Atendimento / UPA  
**Versão:** 1.0

---

## 1. RESUMO EXECUTIVO

### 1.1 Banco de Dados (Dump 2026-03-16)
- **Total de tabelas:** ~300+ tabelas
- **Total de Stored Procedures:** ~64 procedures
- **Principais áreas:**
  - Atendimento/Emergência
  - Farmácia/Medicamentos
  - Estoque/Almoxarifado
  - Fila/Senhas
  - Usuários/Autenticação
  - Auditoria/Logs

### 1.2 Frontend Atual
- **Aplicações existentes:**
  - `admin/` - Administração do sistema
  - `auth/` - Login
  - `operacional/` - Operações principais
  - `painel/` - TVs de chamada
  - `totem/` - Totem de senhas
  - `governaca/` - **(VAZIO - PRECISA CRIAR)**

### 1.3 Setores para Landing Pages
Com base na análise do dump e frontend, identificamos **8 setores principais** que precisam de landing pages:

| # | Setor | Página Frontend | Status | Prioridade |
|---|-------|-----------------|--------|------------|
| 1 | Recepção | `Recepcao.jsx` | ✅ Ok | Alta |
| 2 | Triagem | `Triagem.jsx` | ✅ Ok | Alta |
| 3 | Médico/Clínico | `Medico.jsx` | ✅ Ok | Alta |
| 4 | Enfermagem | `Enfermagem.jsx` | ✅ Ok | Alta |
| 5 | Farmácia | `Farmacia.jsx` | ✅ Ok | Alta |
| 6 | Painel/TV | `Painel.jsx` | ✅ Ok | Alta |
| 7 | Totem | `Totem.jsx` | ✅ Ok | Alta |
| 8 | Admin | `Admin.jsx` | ✅ Ok | Alta |

---

## 2. MAPEAMENTO DETALHADO: SETOR × TABELAS × SPs

### 2.1 RECEPÇÃO

**Arquivo:** `frontend/src/apps/operacional/pages/recepcao/Recepcao.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Buscar paciente | GET `/api/operacional/pacientes?termo=` | `sp_paciente_buscar` | `pessoa`, `paciente` |
| Criar atendimento | POST `/api/operacional/atendimentos` | `sp_master_atendimento_iniciar` | `atendimento`, `ffa`, `fila_operacional` |
| Gerar senha | POST `/api/operacional/senhas` | `sp_master_senha_emitir` | `senha`, `fila_operacional` |
| Ver fila | GET `/api/fila` | Query direta | `fila_operacional`, `paciente`, `local_operacional` |

**JOINS necessários:**
```sql
SELECT fo.*, pes.nome_completo, pes.cpf, pes.cns, pac.prontuario
FROM fila_operacional fo
LEFT JOIN paciente pac ON pac.id = fo.id_paciente
LEFT JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
```

---

### 2.2 TRIAGEM

**Arquivo:** `frontend/src/apps/operacional/pages/triagem/Triagem.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Chamar paciente | POST `/api/operacional/atendimentos/chamar` | `sp_fila_chamar_proxima` | `fila_operacional`, `senha` |
| Finalizar triagem | PUT `/api/operacional/atendimentos/:id` | `sp_triagem_classificar_senha` | `senha`, `fila_operacional` |
| Encaminhar | POST `/api/operacional/atendimentos/:id/encaminhar` | `sp_recepcao_encaminhar_ffa` | `fila_operacional`, `ffa` |
| Ver fila triagem | GET `/api/triagem/fila` | Query direta | `fila_operacional`, `paciente` |

**JOINS necessários:**
```sql
SELECT fo.*, pes.nome_completo, pes.cns, pes.data_nascimento, 
       tr.classificacao_risco
FROM fila_operacional fo
LEFT JOIN paciente pac ON pac.id = fo.id_paciente
LEFT JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
LEFT JOIN triagem tr ON tr.id_atendimento = fo.id_atendimento
```

---

### 2.3 MÉDICO/CLÍNICO

**Arquivo:** `frontend/src/apps/operacional/pages/medico/Medico.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Chamar paciente | POST `/api/operacional/atendimentos/chamar` | `sp_fila_chamar_proxima` | `fila_operacional`, `senha` |
| Salvar evolução | POST `/api/operacional/atendimentos/:id/evolucao` | `sp_atendimento_transicionar` | `atendimento_evolucao` |
| Prescrever | POST `/api/operacional/atendimentos/:id/prescricao` | `sp_master_registrar_administracao_medicacao` | `gpat_atendimento`, `gpat_item` |
| Solicitar exame | POST `/api/operacional/atendimentos/:id/exame` | Query direta | `atendimento_pedidos_exame` |
| Finalizar | POST `/api/operacional/atendimentos/:id/finalizar` | `sp_master_atendimento_finalizar` | `atendimento`, `ffa` |

**JOINS necessários:**
```sql
SELECT fo.*, ffa.id_atendimento, ffa.classificacao_cor,
       pes.nome_completo, pes.cpf, pes.data_nascimento, pes.sexo,
       pac.prontuario, tr.classificacao_risco
FROM fila_operacional fo
JOIN ffa ON ffa.id = fo.id_ffa
JOIN paciente pac ON pac.id = ffa.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
LEFT JOIN triagem tr ON tr.id_atendimento = ffa.id_atendimento
```

---

### 2.4 ENFERMAGEM

**Arquivo:** `frontend/src/apps/operacional/pages/enfermagem/Enfermagem.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Ver fila medicação | GET `/api/enfermagem/fila` | Query direta | `fila_operacional`, `ordem_assistencial_item` |
| Administrar | POST `/api/enfermagem/administrar` | `sp_master_registrar_administracao_medicacao` | `administracao_medicacao_ordem` |
| Registrar sinais vitais | POST `/api/enfermagem/sinais-vitais` | Query direta | `atendimento_sinais_vitais` |

**JOINS necessários:**
```sql
SELECT fo.*, pes.nome_completo, pes.data_nascimento,
       item.id as id_item, item.medicamento, item.dose, item.via
FROM fila_operacional fo
JOIN ordem_assistencial_item item ON item.id_ffa = fo.id_ffa
JOIN paciente pac ON pac.id = fo.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
```

---

### 2.5 FARMÁCIA

**Arquivo:** `frontend/src/apps/operacional/pages/farmacia/Farmacia.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Ver pendentes | GET `/api/farmacia/pendentes` | Query direta | `gpat_atendimento`, `gpat_item` |
| Buscar medicamentos | GET `/api/farmacia/medicamentos?termo=` | `sp_estoque_buscar` | `estoque_produto`, `estoque_lote` |
| Dispensar | POST `/api/farmacia/dispensar` | `sp_farmacia_dispensar_registrar` | `gpat_dispensacao`, `farmaco_lote` |
| Ver estoque | GET `/api/farmacia/estoque` | Query direta | `farmaco_lote` |

**JOINS necessários:**
```sql
SELECT gpat.*, pes.nome_completo, pes.cpf, pes.cns, pac.prontuario,
       item.id as id_item, item.quantidade_total, item.posologia,
       f.nome as medicamento_nome, f.concentracao
FROM gpat_atendimento gpat
JOIN gpat_item item ON item.id_gpat = gpat.id
JOIN ffa ON ffa.id = gpat.id_ffa
JOIN paciente pac ON pac.id = ffa.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
JOIN farmaco f ON f.id = item.id_farmaco
```

---

### 2.6 PAINEL/TV

**Arquivo:** `frontend/src/apps/painel/pages/Painel.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Ver chamadas | GET `/api/painel/chamadas` | `sp_painel_listar_*` | `senhas`, `local_operacional` |
| Atualizar | GET (polling) | Query direta | `painel_config` |

**SPs de painel:**
- `sp_painel_listar_recepcao`
- `sp_painel_listar_triagem`
- `sp_painel_listar_clinico`
- `sp_painel_listar_pediatrico`
- `sp_painel_tv_rotativa`

---

### 2.7 TOTEM

**Arquivo:** `frontend/src/apps/totem/pages/Totem.jsx`

| Funcionalidade | Endpoint | SP | Tabelas |
|---------------|----------|-----|---------|
| Gerar senha | POST `/api/totem/gerar-senha` | `sp_totem_gerar_senha` | `senha`, `fila_operacional` |
| Consultar senha | GET `/api/totem/consultar/:senha` | `sp_totem_consultar` | `senha`, `fila_operacional` |
| Cancelar senha | POST `/api/totem/cancelar` | `sp_painel_cancelar_senha` | `senha`, `fila_operacional` |

---

### 2.8 ADMIN

**Arquivo:** `frontend/src/apps/admin/pages/Admin.jsx`

| Funcionalidade | Área | Tabelas |
|---------------|------|---------|
| Gerenciar usuários | Autenticação | `usuario`, `pessoa`, `perfil` |
| Gerenciar permissões | Segurança | `permissao`, `perfil_permissao` |
| Configurar sistema | Administração | `configuracao`, `config_sistema` |
| Relatórios | BI/Analytics | Diversas tabelas |

---

## 3. ANÁLISE: FRONTEND × BANCO - FALTAS E CORREÇÕES

### 3.1 Queries que precisam de JOINs

| Página | Query Atual | Problema | Query Correta |
|--------|-------------|----------|---------------|
| Recepção | `SELECT p.nome...` | Falta JOIN com `pessoa` | Precisa: `pes.nome_completo` |
| Triagem | `SELECT p.nome...` | Falta JOIN com `pessoa` | Precisa: `pes.nome_completo` |
| Médico | Já tem JOINs | Verificar completude | OK |
| Farmácia | `SELECT p.nome...` | Falta JOINs | Precisa: `ffa`, `paciente`, `pessoa` |
| Enfermagem | Query básica | Falta JOINs | Precisa: `ffa`, `paciente`, `pessoa` |

### 3.2 Tabelas Novas Identificadas no Dump

| Tabela | Descrição | Área |
|--------|-----------|------|
| `assistencia_social_atendimento` | Assistência Social | Novo setor |
| `gpat_atendimento` | Prescrição/GPAT | Farmácia |
| `farmacia_atendimento_externo_dispensacao` | Dispensação externa | Farmácia |
| `nucleo_governanca_assistencial` | Núcleo de governança | Novo |
| `ordem_assistencial_*` | Ordens de serviço | Enfermagem |
| `internacao_*` | Internação | Novo setor |

---

## 4. SETORES QUE PRECISAM DE LANDING PAGES

### 4.1 Setores Existentes (Precisam de Landing Page Central)

1. **Recepção** - `frontend/src/apps/operacional/pages/recepcao/`
2. **Triagem** - `frontend/src/apps/operacional/pages/triagem/`
3. **Médico** - `frontend/src/apps/operacional/pages/medico/`
4. **Enfermagem** - `frontend/src/apps/operacional/pages/enfermagem/`
5. **Farmácia** - `frontend/src/apps/operacional/pages/farmacia/`
6. **Painel** - `frontend/src/apps/painel/pages/`
7. **Totem** - `frontend/src/apps/totem/pages/`
8. **Admin** - `frontend/src/apps/admin/pages/`

### 4.2 Setores Novos Identificados (Precisam Criar)

1. **Governança** - `frontend/src/apps/governaca/` (pasta vazia)
2. **Laboratório** - Análises clínicas
3. **Internação** - Unidade de internação
4. **Estoque/Almoxarifado** - Gestão de estoque

---

## 5. RECOMENDAÇÕES

### 5.1 Correções Imediatas (Bugs)
- [ ] Adicionar JOINs com `pessoa` nas queries de Recepção
- [ ] Adicionar JOINs com `pessoa` nas queries de Triagem
- [ ] Completar JOINs na página de Farmácia

### 5.2 Melhorias Estruturais
- [ ] Criar landing page central para cada setor
- [ ] Implementar menu de navegação entre setores
- [ ] Criar setor de Governança (pasta vazia)
- [ ] Padronizar componentização entre páginas

### 5.3 SPs para Revisar
- [ ] `sp_master_dispatcher_runtime` - Verificar joins
- [ ] `sp_master_atendimento_iniciar` - Verificar completude
- [ ] `sp_fila_chamar_proxima` - Verificar retorno de dados

---

## 6. CONCLUSÃO

O frontend está **parcialmente alinhado** com o banco de dados:
- ✅ Estrutura de pastas organizada por setor
- ✅ Páginas principais existem para todos os setores operacionais
- ⚠️ Queries precisam de ajustes nos JOINs
- ⚠️ setors novos (Governança, Laboratório, Internação) não têm páginas
- ⚠️ Landing pages centralizadas por setor precisam ser implementadas

**Próximos passos recomendados:**
1. Corrigir JOINs nas queries do backend
2. Criar landing pages centralizadas por setor
3. Implementar setor de Governança
4. Avaliar necessidade de novos setores (Laboratório, Internação)
