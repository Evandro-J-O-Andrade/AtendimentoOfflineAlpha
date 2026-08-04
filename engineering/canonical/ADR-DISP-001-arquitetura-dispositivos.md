# ADR-DISP-001 — Arquitetura Canônica do Domínio Dispositivos/Displays

**Status**: APROVADO  
**Versão**: 1.0  
**Data**: 2026-08-04  
**Autores**: Equipe de Arquitetura Enterprise  
**Aprovadores**: Equipe de Arquitetura Enterprise    

---

## 1. Contexto e Problema

O ecossistema Enterprise evoluiu organicamente. O que começou como um sistema de Painéis de chamada expandiu-se para Totens, TVs Corporativas, Dashboards, Kiosks e outros dispositivos de exibição/interação. Essa expansão ocorreu sem uma modelagem de domínio unificada, resultando em:

- **Tabelas paralelas**: `painel`, `totem`, `tv_rotativo`, `dispositivo` coexistem sem hierarquia clara.
- **Configuração fragmentada**: `totem_senha_opcao` referencia `painel`, mas `totem_evento` referencia `totem`.
- **Implementação fragmentada**: `apps/totem/` separado de `apps/portal/`, `modules/display/` e `modules/painel/` com responsabilidades sobrepostas.
- **Documentação divergente**: MDs tratam Painel, Totem e TV como domínios independentes, enquanto o banco aponta para unificação.
- **Runtime ausente**: Não existe um runtime específico para Displays; tudo é servido pelo Dispatcher genérico.

Essa fragmentação aumenta o custo de manutenção, dificulta a evolução e compromete a consistência do ecossistema.

### Princípio Canônico

> **Todo Dispositivo executa exatamente um Painel ativo, e todo Painel possui exatamente uma Configuração efetiva em tempo de execução. O Runtime nunca contém regras de negócio específicas de um tipo de painel; ele apenas interpreta a Configuração e executa o comportamento definido.**

---

## 2. Alternativas Consideradas

### Alternativa A — Manter o estado atual
Manter `painel`, `totem`, `tv_rotativo`, `dispositivo` como entidades independentes, com módulos e apps separados.

**Vantagens**:  
- Nenhuma mudança imediata necessária.  
- Cada time continua dono do seu módulo.

**Desvantagens**:  
- Código duplicado.  
- Configuração espalhada.  
- Impossível ter um runtime unificado de Dispositivos.  
- Custo de manutenção crescente.  
- Inconsistências entre banco, documentação e implementação aumentam com o tempo.

### Alternativa B — Unificação total via `painel`
Transformar `totem`, `tv_rotativo` e outros dispositivos em subtipos de `painel`, removendo tabelas paralelas.

**Vantagens**:  
- Modelo físico alinhado com a visão de produto.  
- Um único ponto de configuração.  
- Runtime unificado possível.

**Desvantagens**:  
- Migração de dados complexa.  
- Risco de quebra de funcionalidades existentes.  
- Requer mudança em backend, frontend e banco simultaneamente.

### Alternativa C — Modelo em camadas (ESCOLHIDA)
Adotar uma arquitetura de camadas onde **Dispositivo** é a identidade física, **Painel** é a função exercida e **Configuração** define o comportamento. Nenhuma tabela é removida imediatamente. A unificação é gradual, guiada por ADRs e migrações controladas.

**Vantagens**:  
- Respeita o estado atual do banco.  
- Não quebra funcionalidades existentes.  
- Permite evolução incremental.  
- Cria uma referência arquitetural clara (este ADR).  
- Alinha documentação, código e banco ao longo do tempo.

**Desvantagens**:  
- Requer disciplina para seguir o modelo.  
- Período de transição mais longo.

---

## 3. Decisão

Adotar a **Alternativa C**: Modelo em camadas.

O domínio **Dispositivos/Displays** será regido pela seguinte hierarquia canônica:

```
Dispositivo (Hardware ou Runtime)
        │
        ▼
Painel (Função exercida)
        │
        ▼
Configuração (Comportamento)
        │
        ▼
Runtime (Execução)
```

### 3.1 Princípios Fundamentais

1. **Dispositivo é identidade física ou virtual**: representa o equipamento, terminal, navegador ou runtime que executa o Painel.
2. **Painel é função**: representa o papel que aquele dispositivo desempenha no ecossistema (ex.: Painel Clínico, Totem de Senha, TV Corporativa).
3. **Configuração é comportamento**: define layout, widgets, filas, permissões, tema, eventos e qualquer outra regra de exibição/interação.
4. **Runtime é executor**: lê a configuração e renderiza a interface correspondente.
5. **Kernel é agnóstico**: o Kernel Enterprise não conhece detalhes de Painel, Totem ou TV. Ele fornece Dispatcher, Registry, Eventos, Contexto e Sessão.
6. **Banco é fonte de verdade física**: a estrutura do banco canônico é a referência para modelagem. Documentação e código devem convergir para ela, não o inverso.
7. **Comportamento nasce da Configuração, nunca do tipo do Painel**: regras de negócio específicas não devem ser codificadas no Runtime com base em `painel.tipo`. O Runtime deve consultar a Configuração.

### 3.2 Matriz de Responsabilidades

| Camada       | Responsabilidade                                           | Não deve fazer                                           |
| ------------ | ---------------------------------------------------------- | --------------------------------------------------------- |
| Dispositivo  | Identificar e registrar o executor                         | Definir regras de negócio                                 |
| Painel       | Representar a função exercida                              | Armazenar estado do hardware                              |
| Configuração | Definir comportamento                                      | Executar lógica                                           |
| Runtime      | Interpretar configuração e executar o comportamento        | Conhecer tipos específicos de Painel                      |
| Kernel       | Serviços compartilhados (Dispatcher, Registry, Eventos...) | Conhecer Painéis, Dispositivos ou regras de negócio       |

### 3.3 Ciclo de Execução Canônico

```text
Dispositivo inicia
        │
        ▼
Autenticação
        │
        ▼
Contexto
        │
        ▼
Painel atribuído
        │
        ▼
Configuração carregada
        │
        ▼
Runtime monta Layout
        │
        ▼
Widgets iniciam
        │
        ▼
Eventos
        │
        ▼
Atualizações
```

1. **Dispositivo inicia**: o hardware/runtime inicia e se autentica no ecossistema.
2. **Autenticação**: Kernel valida identidade e sessão.
3. **Contexto**: Kernel carrega contexto de unidade, local, usuário e tenant.
4. **Painel atribuído**: sistema identifica qual Painel está associado ao Dispositivo/Contexto.
5. **Configuração carregada**: Runtime lê `painel_config` e `painel_config_def`.
6. **Runtime monta Layout**: Runtime interpreta a configuração e renderiza widgets/layout.
7. **Widgets iniciam**: cada widget executa sua lógica de apresentação e consumo de eventos.
8. **Eventos**: Runtime subscreve eventos do Kernel e do domínio (filas, chamadas, mensagens).
9. **Atualizações**: alterações de configuração ou eventos refletem-se em tempo real no Painel.

### 3.4 Formalização do Conceito de Painel

> **Um Painel não representa um hardware. Um Painel representa um papel operacional desempenhado por um Dispositivo.**

Isso significa que:
- Um mesmo Dispositivo pode executar Painéis diferentes em momentos distintos.
- O Hardware é independente da função.
- A função é definida pela Configuração.
- O Runtime é o mesmo para todos os Painéis.

### 3.5 Tipos de Painel Canônicos

`painel.tipo` é um enum extensível. Novos tipos podem ser adicionados sem alterar o Runtime.

#### Atendimento
- `TOTEM_SENHA`
- `TOTEM_FEEDBACK`
- `TOTEM_CADASTRO`
- `TOTEM_AUTOATENDIMENTO`

#### Assistencial
- `PAINEL_CLINICO`
- `PAINEL_TRIAGEM`
- `PAINEL_ECG`
- `PAINEL_RX`
- `PAINEL_MEDICACAO`
- `PAINEL_FARMACIA`
- `PAINEL_RECEPCAO`
- `PAINEL_LABORATORIO`

#### Gestão
- `DASHBOARD`
- `TV_CORPORATIVA`
- `MONITOR_MEDICOS`

#### Comunicação
- `TV_INFORMATIVOS`
- `TV_ANUNCIOS`
- `TV_SLIDES`
- `MURAL_DIGITAL`

#### Futuro
- `KIOSK`
- `MONITOR_ESPECIFICO`
- `VIDEOWALL`

---

## 4. Entidades e Agregados Canônicos

### 4.1 Dispositivo

Representa a identidade física ou virtual do equipamento.

**Responsabilidades**:
- Identificação única (`identificador`, `serial`, `uuid`)
- Tipo físico (`dispositivo_tipo`)
- Localização (`local_dispositivo`, `local_runtime`)
- Status operacional (`runtime_dispositivo.status_runtime`, `kernel_runtime_heartbeat`)
- Capacidades (`dispositivo_tipo.usa_tts`, `exibe_painel`, `requer_autenticacao`)

**Tabelas canônicas**:
- `dispositivo`
- `dispositivo_tipo`
- `local_dispositivo`
- `runtime_dispositivo`
- `kernel_runtime_heartbeat`
- `kernel_runtime_evento`

**Mapeamento atual**:
| Entidade Canônica | Tabela | Status |
|-------------------|--------|--------|
| Dispositivo | `dispositivo` | ✅ Presente |
| Tipo de Dispositivo | `dispositivo_tipo` | ✅ Presente |
| Associação Local | `local_dispositivo` | ⚠️ Falta FK para `dispositivo` |
| Runtime do Dispositivo | `runtime_dispositivo` | ✅ Presente |

### 4.2 Painel

Representa a função exercida pelo dispositivo no ecossistema.

**Responsabilidades**:
- Agrupamento de configuração (`painel_config_def`)
- Exibição de mensagens (`painel_mensagem`, `painel_mensagem_consumo`)
- Monitoramento de filas (`painel_fila_tipo`, `painel_lane`, `fila_painel_runtime`)
- Stream de eventos (`painel_evento_stream`, `painel_consumo_evento`)
- Associação a locais (`painel_local`, `painel_grupo_local`)
- Configuração de TTS, piscada, intervalo (`painel.tts_habilitado`, `painel.piscada_seg`, `painel.intervalo_segundos`)
- Especialidades monitoradas (`painel_monitoramento_especialidade`)
- Alertas de tempo (`painel_alertas_tempo`)

**Tipo canônico**: `painel.tipo` é um enum que deve evoluir para refletir todas as variantes de função:
- `PAINEL` — Painéis operacionais (Clínico, Triagem, RX, ECG, Medicação, Farmácia, Recepção, etc.)
- `TOTEM` — Totens de interação (Senha, Cadastro, Feedback, Autoatendimento)
- `TV` — TVs corporativas e informativas (Dashboard, Slides, Anúncios)
- `KIOSK` — Kiosks (futuro)
- `MONITOR` — Monitores específicos (futuro)

**Tabelas canônicas**:
- `painel` (entidade central)
- `painel_config`
- `painel_config_def`
- `painel_local`
- `painel_grupo`
- `painel_grupo_local`
- `painel_mensagem`
- `painel_mensagem_consumo`
- `painel_evento_stream`
- `painel_consumo_evento`
- `painel_lane`
- `painel_fila_tipo`
- `painel_monitoramento_especialidade`
- `painel_alertas_tempo`
- `totem_senha_opcao` (especialização de `painel` para tipo `TOTEM`)
- `tv_rotativo_tela` (especialização de `painel` para tipo `TV`)

**Mapeamento atual**:
| Entidade Canônica | Tabela | Status |
|-------------------|--------|--------|
| Painel | `painel` | ✅ Presente |
| Configuração de Painel | `painel_config` | ✅ Presente |
| Definição de Config | `painel_config_def` | ✅ Presente |
| Associação Local | `painel_local` | ✅ Presente |
| Grupos | `painel_grupo`, `painel_grupo_local` | ✅ Presente |
| Mensagens | `painel_mensagem`, `painel_mensagem_consumo` | ✅ Presente |
| Eventos | `painel_evento_stream`, `painel_consumo_evento` | ✅ Presente |
| Lanes | `painel_lane` | ✅ Presente |
| Tipos de Fila | `painel_fila_tipo` | ✅ Presente |
| Monitoramento | `painel_monitoramento_especialidade` | ✅ Presente |
| Alertas | `painel_alertas_tempo` | ✅ Presente |
| Opções de Totem | `totem_senha_opcao` | ✅ Presente, FK correta para `painel` |
| Telas de TV | `tv_rotativo_tela` | ✅ Presente, FK correta para `painel` |

### 4.3 Configuração

Representa o comportamento específico de um Painel.

**Responsabilidades**:
- Definição de chaves e valores (`painel_config_def`)
- Aplicação por tipo de Painel (`aplica_em`: PAINEL, TOTEM, TV, TODOS)
- Override por instância (`painel_config`)
- Controle de consumo (`painel_mensagem_consumo`, `painel_consumo_evento`)

**Tabelas canônicas**:
- `painel_config_def`
- `painel_config`

### 4.4 Runtime

Representa o motor que executa o Painel no dispositivo.

**Responsabilidades**:
- Carregar configuração do Painel
- Renderizar widgets/layout
- Consumir eventos e filas
- Gerenciar estado local
- Sincronizar com o Kernel

**Tabelas canônicas**:
- `runtime_dispositivo`
- `runtime_contexto`
- `runtime_execution_queue`
- `runtime_sync_queue`
- `runtime_edge_evento`
- `kernel_runtime_evento`
- `kernel_runtime_heartbeat`

**Observação**: Não existe um runtime específico para Displays. O runtime é genérico e serve a qualquer dispositivo através do Dispatcher. Isso é consistente com a arquitetura do Kernel.

---

## 5. Mapa de Dependências Canônico

```
Dispositivo
├── dispositivo
├── dispositivo_tipo
├── local_dispositivo (FK: id_local → local) ★ Necessita FK para dispositivo
├── runtime_dispositivo (FK: id_dispositivo → dispositivo)
└── kernel_runtime_heartbeat (FK: uuid_runtime → runtime_dispositivo.uuid_runtime)

Painel
├── painel (FK: id_unidade → unidade)
├── painel_config (FK: id_painel → painel)
├── painel_config_def (catálogo)
├── painel_local (FK: id_painel → painel, id_local_operacional → local)
├── painel_grupo
├── painel_grupo_local (FK: id_grupo → painel_grupo)
├── painel_mensagem (FK: id_painel → painel)
├── painel_mensagem_consumo (FK: id_painel → painel, id_mensagem → painel_mensagem)
├── painel_evento_stream (FK: id_painel → painel)
├── painel_consumo_evento
├── painel_lane (FK: id_painel → painel)
├── painel_fila_tipo (FK: id_painel → painel)
├── painel_monitoramento_especialidade (FK: id_painel → painel)
├── painel_alertas_tempo
├── totem_senha_opcao (FK: id_painel → painel) ★ Especialização TOTEM
└── tv_rotativo_tela (FK: id_painel → painel) ★ Especialização TV

Runtime
├── runtime_contexto (FK: id_sessao_usuario → sessao_usuario, id_unidade → unidade)
├── runtime_execution_queue
├── runtime_sync_queue
├── runtime_edge_evento (FK: id_unidade → unidade)
├── kernel_runtime_evento (FK: id_entidade → saas_entidade)
└── kernel_runtime_heartbeat

Local
├── local (FK: id_unidade → unidade, id_tipo_local → tipo_local)
├── local_fila (FK: id_local → local)
├── local_runtime (FK: id_local → local)
├── local_turno (FK: id_local → local)
├── local_capacidade (FK: id_local → local)
└── local_dispositivo (FK: id_local → local) ★ Necessita FK para dispositivo
```

---

## 6. Consequências

### 6.1 Banco de Dados

**Imediatas**:
- Nenhuma alteração imediata no banco.
- `painel.tipo` já suporta `PAINEL`, `TOTEM`, `TV`. Futuramente pode incluir `KIOSK`, `MONITOR`, etc.
- `totem_senha_opcao` e `tv_rotativo_tela` já estão corretamente ligadas a `painel`.
- `painel_config_def.aplica_em` já suporta `PAINEL`, `TOTEM`, `TV`, `TODOS`.

**Médio prazo**:
- Adicionar FK em `local_dispositivo` para `dispositivo(id_dispositivo)`.
- Avaliar convergência de `totem` (tabela paralela) para `painel` via migração controlada.
- Avaliar se `tv_rotativo` (cabeçalho) deve ser absorvido por `painel` ou mantido como entidade auxiliar.

**Longo prazo**:
- Possível renomeação de `painel` para `display` ou `dispositivo_painel` se a evolução do domínio exigir.
- Qualquer alteração deve ser feita via migração versionada, nunca por alteração direta.

### 6.2 Backend

**Imediatas**:
- Nenhuma alteração imediata.
- `TotemService` e `TotemController` continuam funcionando.
- `DispatcherService` continua genérico.

**Médio prazo**:
- `TotemService` deve ser documentado como uma **implementação especializada** do runtime de Painel.
- Rotas `/totem/*` são interfaces específicas para dispositivos físicos de totem, mas compartilham o mesmo núcleo de `painel`.
- SPs `sp_totem_gerar_senha` e `sp_painel_*` devem ser gradualmente alinhadas para usar o mesmo modelo de dados.

**Longo prazo**:
- Possível criação de um `DisplayService` unificado que englobe Painel, Totem e TV.
- `apps/totem/` pode ser mantido como interface especializada ou integrado ao runtime unificado.

### 6.3 Frontend

**Imediatas**:
- Nenhuma alteração imediata.

**Médio prazo**:
- `modules/display/` e `modules/painel/` devem ser claramente separados por **responsabilidade**, não por entidade:
  - `modules/painel/` — runtime, tipos e lógica de Painel
  - `modules/display/` — tipos de dispositivo, Device Runtime, integração com hardware
- `apps/totem/` é uma **implementação especializada** do runtime de Painel para dispositivos físicos de totem.

**Longo prazo**:
- Possível criação de `apps/display/` como runtime unificado, com `apps/totem/`, `apps/painel/` e `apps/tv/` como configurações/view builders.

### 6.4 Kernel

**Imediatas**:
- Nenhuma alteração necessária. O Kernel já é agnóstico.

**Médio prazo**:
- Manter a agnosticidade. Qualquer runtime específico de Dispositivos/Displays deve ser construído **acima** do Kernel, não dentro dele.

### 6.5 Documentação

**Imediatas**:
- Atualizar `domain-mapping.md` para refletir o modelo unificado.
- Criar `MD-display.md` como documento agregador do domínio.
- Atualizar `MD-totem.md`, `MD-tv_rotativo.md` para indicar que são especializações de `painel`.

**Médio prazo**:
- Todos os MDs de `painel_*` devem ser cross-referenciados com `dispositivo_*`.
- Criar `MAP-DISPLAY-001` mapeando o domínio completo.

---

## 7. Estratégia de Evolução

### Fase 1 — Congelamento (Atual)
- [x] Auditoria completa do banco, código, frontend e kernel.
- [x] Identificação de conflitos e inconsistências.
- [ ] Aprovação deste ADR.
- [ ] Nenhuma alteração estrutural antes da aprovação.

### Fase 2 — Alinhamento de Documentação
- Atualizar MDs existentes para refletir o modelo unificado.
- Criar `MD-display.md` e `MAP-DISPLAY-001`.
- Marcar tabelas e SPs como parte do domínio Displays/Dispositivos.

### Fase 3 — Consolidação de Backend
- Documentar `TotemService` como especialização de Painel.
- Alinhar SPs `sp_totem_gerar_senha` e `sp_painel_*` ao mesmo modelo.
- Adicionar FK em `local_dispositivo`.

### Fase 4 — Consolidação de Frontend
- Clarificar responsabilidades entre `modules/painel/` e `modules/display/`.
- Documentar `apps/totem/` como interface especializada.

### Fase 5 — Unificação de Runtime (futuro)
- Avaliar criação de `DisplayRuntime` unificado.
- Migrar `apps/totem/` para configuração do runtime unificado.
- Manter `apps/portal/` como orquestrador.

### Fase 6 — Limpeza de Legado (futuro)
- Avaliar remoção da tabela `totem` após migração completa.
- Avaliar absorção de `tv_rotativo` por `painel`.
- Qualquer remoção deve ser feita via migração versionada com plano de rollback.

---

## 8. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|--------|---------|---------------|-----------|
| Migração de `totem` quebra histórico | Alto | Média | Manter `totem` como legado read-only até migração completa |
| `local_dispositivo` sem FK causa dados órfãos | Médio | Alta | Adicionar FK em migração futura com validação prévia |
| Documentação desatualizada gera confusão | Médio | Alta | Este ADR serve como referência única; atualizar MDs antes de qualquer implementação |
| Runtime unificado não suporta casos específicos | Alto | Média | Manter `apps/totem/` como fallback durante transição |
| Fragmentação de conhecimento | Médio | Alta | Este documento é a "constituição" do domínio; todas as decisões futuras devem referenciá-lo |

---

## 9. Referências

- Auditoria Canônica Completa — Domínio Dispositivos/Painéis/Displays (2026-08-04)
- `engineering/canonical/md-columns/MD-painel.md`
- `engineering/canonical/md-columns/MD-totem.md`
- `engineering/canonical/md-columns/MD-tv_rotativo.md`
- `engineering/canonical/md-columns/MD-dispositivo.md`
- `engineering/canonical/md-columns/MD-dispositivo_tipo.md`
- `engineering/canonical/md-columns/MD-local_dispositivo.md`
- `engineering/canonical/md-columns/MD-runtime_dispositivo.md`
- `engineering/metadata/domain-mapping.md`
- `engineering/REGISTRY-CANONICO-AUDITORIA.md`
- `database/dump/Dump20260726.sql`

---

## 10. Aprovação

| Função | Nome | Data | Assinatura |
|--------|------|------|------------|
| Arquiteto Enterprise | | | |
| Tech Lead Backend | | | |
| Tech Lead Frontend | | | |
| Product Owner | | | |
| QA Lead | | | |

**Status**: APROVADO — [Data de aprovação]

---

## 11. Próximas Fases

Após aprovação deste ADR, a sequência recomendada é:

1. **Fase 2 — Alinhamento de Documentação**
   - Atualizar `domain-mapping.md` para refletir o modelo unificado.
   - Criar `MD-display.md` como documento agregador do domínio.
   - Atualizar `MD-totem.md`, `MD-tv_rotativo.md` para indicar que são especializações de `painel`.
   - Criar `MAP-DISPLAY-001` mapeando o domínio completo.

2. **Fase 3 — Consolidação de Backend**
   - Documentar `TotemService` como especialização de Painel.
   - Alinhar SPs `sp_totem_gerar_senha` e `sp_painel_*` ao mesmo modelo.
   - Adicionar FK em `local_dispositivo`.

3. **Fase 4 — Consolidação de Frontend**
   - Clarificar responsabilidades entre `modules/painel/` e `modules/display/`.
   - Documentar `apps/totem/` como interface especializada.

4. **Fase 5 — Unificação de Runtime (futuro)**
   - Avaliar criação de `DisplayRuntime` unificado.
   - Migrar `apps/totem/` para configuração do runtime unificado.
   - Manter `apps/portal/` como orquestrador.

5. **Fase 6 — Limpeza de Legado (futuro)**
   - Avaliar remoção da tabela `totem` após migração completa.
   - Avaliar absorção de `tv_rotativo` por `painel`.
   - Qualquer remoção deve ser feita via migração versionada com plano de rollback.

**Nenhuma alteração de código, banco ou documentação deve ser iniciada antes da conclusão da Fase 2.**
