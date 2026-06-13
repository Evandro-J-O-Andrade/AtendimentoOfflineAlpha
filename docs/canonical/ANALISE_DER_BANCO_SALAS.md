# Análise do DER do Banco de Dados - Pronto Atendimento

## Visão Geral

O banco de dados do sistema de Pronto Atendimento foi analisado através do arquivo [`pronto_atendimento.mwb`](backend/sql/pronto_atendimento.mwb) e do dump mais recente [`Dump20260323.sql`](backend/sql/Dump20260323.sql).

**Total de tabelas identificadas: +300 tabelas**

---

## Estrutura de Locais e Salas

### 1. Tabela `local` (Locais Físicos)

**Localização**: [`Dump20260323.sql:8974`](backend/sql/Dump20260323.sql:8974)

Representa os locais físicos do hospital/Unidade.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_local` | bigint (PK) | ID único do local |
| `id_unidade` | bigint (FK) | Unidade pertencente |
| `id_tipo_local` | bigint (FK) | Tipo de local |
| `codigo` | varchar(40) | Código identificador |
| `nome` | varchar(120) | Nome do local |
| `descricao` | text | Descrição |
| `andar` | varchar(20) | Andar |
| `bloco` | varchar(20) | Bloco |
| `ativo` | tinyint | Status ativo |
| `criado_em` | datetime | Data criação |
| `atualizado_em` | datetime | Data atualização |

**Dados seedados** (24 locais):
- HOSPITAL (ID 1) - Hospital Central
- HC-TRI-01 (ID 2) - Sala de Triagem
- HC-MED-01/02 (ID 3-4) - Consultórios Médicos
- HC-ENF-A/B (ID 5-6) - Enfermarias
- HC-EME-01 (ID 7) - Sala de Emergência
- HC-LAB-01 (ID 8) - Laboratório
- HC-FAR-01 (ID 9) - Farmácia Central
- HC-EST-01 (ID 10) - Estoque Geral
- UPA-REC-01 (ID 11) - Recepção UPA
- UPA-TRI-01 (ID 12) - Triagem UPA
- E outros...

---

### 2. Tabela `tipo_local` (Tipos de Local)

**Localização**: [`Dump20260323.sql:14550`](backend/sql/Dump20260323.sql:14550)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_tipo_local` | bigint (PK) | ID único |
| `codigo` | varchar | Código |
| `nome` | varchar | Nome do tipo |
| `categoria` | varchar | Categoria (ATENDIMENTO, ASSISTENCIAL, etc.) |

**Tipos seedados**:
- RECEPCAO (ID 1) - Recepção
- GUICHE (ID 2) - Guichê
- TRIAGEM (ID 3) - Triagem
- CONSULTORIO (ID 4) - Consultório
- EMERGENCIA (ID 5) - Emergência
- ENFERMARIA (ID 6) - Enfermaria
- LABORATORIO (ID 7) - Laboratório
- FARMACIA (ID 8) - Farmácia
- ESTOQUE (ID 9) - Estoque
- AMBULANCIA (ID 10) - Ambulância
- NUTRICAO (ID 11) - Nutrição
- ADMINISTRACAO (ID 12) - Administração
- SOCIAL (ID 13) - Assistência Social
- FATURAMENTO (ID 14) - Faturamento
- CAT (ID 15) - CAT
- OBITO (ID 16) - Serviço de Óbito
- PDV (ID 17) - PDV/Vendas
- GASOTERAPIA (ID 18) - Gasoterapia
- MANUTENCAO (ID 19) - Manutenção

---

### 3. Tabela `sala` (Salas de Atendimento)

**Localização**: [`Dump20260323.sql:13602`](backend/sql/Dump20260323.sql:13602)

**Descrição**: Sala física de atendimento (exibição em painel e uso assistencial)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_sala` | int (PK) | ID único da sala |
| `nome_exibicao` | varchar(100) | Nome para exibir no painel |
| `id_local` | int (FK) | Referência ao local físico |
| `id_especialidade` | int (FK) | Especialidade associada |
| `ativa` | tinyint(1) | Se está ativa |
| `codigo` | varchar(50) | Código identificador |
| `id_tipo_sala` | bigint (FK) | Tipo de sala |
| `permite_multiplas_especialidades` | tinyint(1) | Permite múltiplas especialidades |
| `exibir_painel` | tinyint(1) | Se exibe no painel público |
| `gerar_tts` | tinyint(1) | Se gera TTS (Text-to-Speech) |

**Campos novos adicionados** (regras de sala):
- ✅ `permite_multiplas_especialidades` - Permite que a sala atenda múltiplas especialidades
- ✅ `exibir_painel` - Controla se a sala aparece no painel público
- ✅ `gerar_tts` - Controla se há geração de áudio para chamada

---

### 4. Tabela `tipo_sala` (Tipos de Sala)

**Localização**: [`Dump20260323.sql:14583`](backend/sql/Dump20260323.sql:14583)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_tipo_sala` | bigint (PK) | ID único |
| `codigo` | varchar(50) | Código |
| `nome` | varchar(100) | Nome do tipo |
| `gera_chamada_painel` | tinyint(1) | Se gera chamada no painel |
| `usa_tts` | tinyint(1) | Se usa Text-to-Speech |
| `tipo_fila` | varchar(50) | Tipo de fila associada |

**Dados seedados**:
- ID 1: NAO_DEFINIDA - Sala Não Definida (gera_chamada_painel=0, usa_tts=0)

---

### 5. Tabela `sala_notificacao` (Notificações de Sala)

**Localização**: [`Dump20260323.sql:13637`](backend/sql/Dump20260323.sql:13637)

**Descrição**: Notificações específicas de salas (violência, agravo)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_notificacao` | bigint (PK) | ID único |
| `id_unidade` | bigint (FK) | Unidade |
| `id_senha` | bigint (FK) | Senha associada |
| `id_ffa` | bigint (FK) | FFA associado |
| `tipo` | enum | VIOLENCIA, AGRAVO, OUTRO |
| `status` | enum | ABERTO, EM_ATENDIMENTO, FINALIZADO, CANCELADO |
| `detalhes` | text | Detalhes da notificação |
| `id_usuario_abertura` | bigint (FK) | Usuário que abriu |
| `criado_em` | datetime | Data criação |
| `atualizado_em` | datetime | Data atualização |

---

### 6. Tabela `sala_notificacao_evento` (Eventos de Notificação)

**Localização**: [`Dump20260323.sql:13672`](backend/sql/Dump20260323.sql:13672)

Registra eventos de timeline das notificações de sala.

---

### 7. Tabela `usuario_sala` (Vinculação Usuário-Sala)

**Localização**: [`Dump20260323.sql:15302`](backend/sql/Dump20260323.sql:15302)

**Descrição**: Vincula profissionais às salas que они atendem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_usuario_sala` | bigint (PK) | ID único |
| `id_usuario` | bigint (FK) | Usuário profissional |
| `id_sala` | int (FK) | Sala associada |
| `ativo` | tinyint(1) | Se vínculo está ativo |
| `criado_em` | datetime | Data criação |

**Relacionamentos**:
- UNIQUE KEY `uk_usuario_sala` (`id_usuario`,`id_sala`)
- FK para `sala` e `usuario`

**Dados seedados**: 15 registros (usuários vinculados à sala "Não Definida" ID=1)

---

## Novas Regras de Sala Implementadas

### 1. Multiplas Especialidades por Sala
```sql
`permite_multiplas_especialidades` tinyint(1) DEFAULT '1'
```
- Permite que uma sala atendimento múltiplas especialidades diferentes
- Valor padrão: 1 (ativo)

### 2. Controle de Exibição no Painel
```sql
`exibir_painel` tinyint(1) DEFAULT '1'
```
- Controla se a sala aparece no painel público
- Valor padrão: 1 (exibe)
- Pode ser desativado para salas internas

### 3. Geração de TTS (Text-to-Speech)
```sql
`gerar_tts` tinyint(1) DEFAULT '1'
```
- Controla se há geração de áudio para chamada de paciente
- Valor padrão: 1 (gera)
- Útil para desativar som em áreas silenciosas

### 4. Tipo de Sala com Configurações de Painel
```sql
`gera_chamada_painel` tinyint(1)
`usa_tts` tinyint(1)
`tipo_fila` varchar(50)
```
- Define se o tipo de sala gera chamadas no painel
- Define se usa TTS
- Associa um tipo de fila específico

---

## Estrutura de Filas e Senhas

### Tabela `fila_operacional`

**Localização**: [`Dump20260323.sql:6741`](backend/sql/Dump20260323.sql:6741)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id_fila` | bigint (PK) | ID único |
| `tipo` | enum | Tipo de fila (ATENDIMENTO, etc.) |
| `id_unidade` | bigint (FK) | Unidade |
| `id_local_operacional` | bigint (FK) | Local operacional |
| `id_senha` | bigint (FK) | Senha associada |
| `substatus` | varchar | Substatus atual |
| `prioridade` | int | Prioridade |
| `data_entrada` | datetime | Data entrada |

---

## Integração Sala-Local

O sistema usa `local_operacional` (provavelmente uma view ou tabela auxiliar) para integrar:

1. **Local físico** (`local`) - Onde fica o consultório/sala
2. **Sala** (`sala`) - Configurações de painel e atendimento
3. **Tipo de sala** (`tipo_sala`) - Comportamento de chamada

**Stored Procedure de Seed**: [`sp_local_operacional_seed_padrao`](backend/sql/Dump20260323.sql:22730)

Cria locais operacionais padrão para:
- Recepção (guichês)
- Triagem (salas)
- Médico Clínico
- Médico Pediátrico
- Medicação (Adulto)
- Medicação (Pediátrico)
- Raio-X (RX)

Cada um com configuração de:
- Código
- Nome
- Tipo
- Sala associada
- Se exibe em painel público
- Se gera TTS público
- Se é "não definido"

---

## Resumo das Novas Funcionalidades

| Funcionalidade | Descrição | Status |
|----------------|-----------|--------|
| Multiplas especialidades | Sala pode atender várias especialidades | ✅ Implementado |
| Controle painel | Exibir/ocultar sala do painel público | ✅ Implementado |
| TTS por sala | Controlar geração de áudio por sala | ✅ Implementado |
| Notificações de sala | Registrar violência/agravo por sala | ✅ Implementado |
| Vinculação usuário-sala | Associar profissionais às salas | ✅ Implementado |
| Tipo de sala | Configurações de chamada por tipo | ✅ Implementado |

---

## Arquivos Analisados

1. [`backend/sql/pronto_atendimento.mwb`](backend/sql/pronto_atendimento.mwb) - Arquivo MySQL Workbench (DER)
2. [`backend/sql/Dump20260323.sql`](backend/sql/Dump20260323.sql) - Dump SQL mais recente

---

## Próximos Passos Sugeridos

1. Popular a tabela `tipo_sala` com tipos específicos (CONSULTORIO, TRIAGEM, etc.)
2. Criar salas adicionais para os consultórios existentes
3. Configurar `permite_multiplas_especialidades` e `exibir_painel` conforme necessidade
4. Vincular usuários às salas corretas na tabela `usuario_sala`
5. Implementar a lógica de TTS no backend baseado no campo `gerar_tts`