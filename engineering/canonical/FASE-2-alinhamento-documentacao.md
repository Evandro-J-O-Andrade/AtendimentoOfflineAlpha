# FASE 2 — Alinhamento de Documentação do Domínio Displays/Dispositivos

**Status**: EM EXECUÇÃO  
**Versão**: 1.0  
**Data**: 2026-08-04  
**Referência**: `ADR-DISP-001-arquitetura-dispositivos.md`  

---

## 1. Objetivo

Verificar se toda a documentação existente do domínio Displays/Dispositivos está aderente ao `ADR-DISP-001`. Não se trata de criar novas decisões arquiteturais, mas de **validar a conformidade** da documentação atual contra a referência aprovada.

---

## 2. Escopo

### 2.1 Documentos Incluídos

Todos os documentos do domínio Displays/Dispositivos, incluindo mas não limitado a:

- `engineering/canonical/md-columns/MD-painel*.md`
- `engineering/canonical/md-columns/MD-totem*.md`
- `engineering/canonical/md-columns/MD-tv_rotativo*.md`
- `engineering/canonical/md-columns/MD-dispositivo*.md`
- `engineering/canonical/md-columns/MD-runtime_dispositivo.md`
- `engineering/canonical/md-columns/MD-local_dispositivo.md`
- `engineering/canonical/md-columns/MD-local_runtime.md`
- `engineering/canonical/md-columns/MD-fila_painel_runtime.md`
- `engineering/metadata/domain-mapping.md`
- `engineering/REGISTRY-CANONICO-AUDITORIA.md`
- `engineering/metadata/event-graph.md`
- `modules/painel/docs/README.md`
- `modules/display/docs/README.md`
- `modules/senha/docs/README.md`
- `modules/runtime/docs/README.md`
- Quaisquer outros documentos que mencionem Painel, Totem, TV, Display ou Dispositivo

### 2.2 Documentos Excluídos

- Documentos de outros domínios (Farmácia, Estoque, FFA, etc.)
- Documentos do Kernel genérico
- Documentos de infraestrutura

---

## 3. Etapas

### Etapa 2.1 — Inventário da Documentação

**Responsável**: Arquiteto / Tech Lead  
**Duração estimada**: 1 dia  

**Tarefas**:
1. Listar todos os documentos do domínio Displays/Dispositivos.
2. Categorizar por tipo:
   - **MDs canônicos** (`engineering/canonical/md-columns/`)
   - **Metadados** (`engineering/metadata/`)
   - **Documentos de módulo** (`modules/*/docs/`)
   - **Mapas e relatórios** (`engineering/*.md`)
3. Registrar em planilha/JSON com:
   - Caminho completo
   - Tipo
   - Objetivo declarado
   - Data de criação/última atualização
   - Autor (se identificável)

**Entregue**: `FASE-2-inventario-documentacao.json`

---

### Etapa 2.2 — Mapeamento para o ADR

**Responsável**: Arquiteto / Tech Lead  
**Duração estimada**: 2 dias  

**Tarefas**:
1. Para cada documento do inventário, identificar referências aos conceitos do ADR:
   - **Dispositivo**
   - **Painel**
   - **Configuração**
   - **Runtime**
   - **Kernel**
2. Mapear como cada documento se relaciona com a hierarquia canônica:
   ```
   Dispositivo → Painel → Configuração → Runtime
   ```
3. Identificar qual camada cada documento descreve ou afeta.

**Entregue**: `FASE-2-mapeamento-adr.md`

---

### Etapa 2.3 — Detecção de Divergências

**Responsável**: Arquiteto / Tech Lead + QA  
**Duração estimada**: 2 dias  

**Tarefas**:
1. Aplicar os **Critérios de Conformidade** (Seção 4) a cada documento.
2. Classificar cada documento em:
   - ✅ Conforme
   - 🟡 Ajuste necessário
   - 🔴 Divergente
   - ⚫ Obsoleto
3. Documentar divergências específicas:
   - Terminologia conflitante
   - Conceitos que contradizem o ADR
   - Regras de negócio que violam invariantes
   - Diagramas ou fluxos desatualizados

**Entregue**: `FASE-2-diagnostico-documentacao.md`

---

### Etapa 2.4 — Correção

**Responsável**: Arquiteto / Tech Lead  
**Duração estimada**: 3–5 dias  

**Tarefas**:
1. Para documentos 🟡 **Ajuste necessário**:
   - Atualizar terminologia para conformidade com o ADR
   - Exemplo: trocar "Domínio Totem" por "Variante TOTEM do Painel"
2. Para documentos 🔴 **Divergentes**:
   - Revisão completa
   - Realinhamento com o ADR
   - Atualização de diagramas, fluxos e exemplos
3. Para documentos ⚫ **Obsoletos**:
   - Marcar com aviso de descontinuação
   - Apontar para documento substituto
   - Não remover imediatamente (manter para referência histórica)

**Regra**: Nenhum documento deve ser removido na Fase 2. Apenas atualizado ou marcado.

**Entregue**: Documentos atualizados + `FASE-2-registro-mudancas.md`

---

### Etapa 2.5 — Matriz de Conformidade

**Responsável**: Arquiteto  
**Duração estimada**: 1 dia  

**Tarefas**:
1. Gerar matriz final com status de cada documento.
2. Calcular métricas:
   - Total de documentos auditados
   - % Conformes
   - % Ajuste necessário
   - % Divergentes
   - % Obsoletos
3. Produzir relatório executivo.

**Entregue**: `FASE-2-matriz-conformidade.md`

---

## 4. Critérios de Conformidade

Para cada documento, avaliar:

| Critério | Descrição | Peso |
|----------|-----------|------|
| **C1. Terminologia** | Usa **Dispositivo**, **Painel**, **Configuração** e **Runtime** conforme definido no ADR. Não usa "Domínio Totem", "Domínio Painel", "Domínio TV" como entidades independentes. | Obrigatório |
| **C2. Hierarquia** | Reflete a hierarquia `Dispositivo → Painel → Configuração → Runtime`. Não apresenta Painel, Totem e TV como camadas paralelas. | Obrigatório |
| **C3. Responsabilidades** | Cada camada tem responsabilidades bem definidas, conforme Matriz de Responsabilidades do ADR (Seção 3.2). | Obrigatório |
| **C4. Ciclo de Execução** | Se descrever fluxo de execução, está alinhado com o Ciclo de Execução Canônico do ADR (Seção 3.3). | Obrigatório |
| **C5. Invariantes** | Não contém regras que contrariem os Princípios Fundamentais do ADR (Seção 3.1), especialmente: "Comportamento nasce da Configuração, nunca do tipo do Painel". | Obrigatório |
| **C6. Separação Kernel/Runtime** | Não atribui ao Kernel regras específicas de Painel, Totem ou TV. | Obrigatório |
| **C7. Extensibilidade** | Se listar tipos de Painel, usa a taxonomia canônica do ADR (Seção 3.5) ou indica que é extensível. | Desejável |
| **C8. Referências** | Referencia `ADR-DISP-001` como fonte arquitetural quando discutir decisões de design. | Desejável |

### Classificação

- ✅ **Conforme**: atende todos os critérios obrigatórios (C1–C6) e os desejáveis (C7–C8).
- 🟡 **Ajuste necessário**: atende critérios obrigatórios, mas precisa de ajustes em critérios desejáveis.
- 🔴 **Divergente**: não atende pelo menos um critério obrigatório.
- ⚫ **Obsoleto**: documento não é mais relevante para o domínio atual.

---

## 5. Entregas

| ID | Entregue | Descrição |
|----|----------|-----------|
| E2.1 | `FASE-2-inventario-documentacao.json` | Inventário completo de documentos do domínio |
| E2.2 | `FASE-2-mapeamento-adr.md` | Mapeamento de cada documento para os conceitos do ADR |
| E2.3 | `FASE-2-diagnostico-documentacao.md` | Diagnóstico com divergências identificadas |
| E2.4 | Documentos atualizados | Documentos corrigidos/marcados |
| E2.5 | `FASE-2-registro-mudancas.md` | Registro de todas as alterações feitas |
| E2.6 | `FASE-2-matriz-conformidade.md` | Matriz final de conformidade |

---

## 6. Critérios de Conclusão

A Fase 2 é considerada concluída quando:

1. ✅ Todos os documentos do escopo foram auditados.
2. ✅ Nenhum documento 🔴 **Divergente** permanece sem correção.
3. ✅ Todos os documentos 🟡 **Ajuste necessário** foram atualizados.
4. ✅ Documentos ⚫ **Obsoletos** foram marcados.
5. ✅ Matriz de conformidade foi aprovada pelo Arquiteto.
6. ✅ Nenhuma alteração foi feita em banco, backend ou frontend.

---

## 7. Restrições

- **NÃO alterar banco de dados.**
- **NÃO alterar código backend.**
- **NÃO alterar código frontend.**
- **NÃO criar novas decisões arquiteturais.**
- **NÃO remover documentos** (apenas marcar como obsoletos).
- **Toda alteração deve ser rastreada** em `FASE-2-registro-mudancas.md`.

---

## 8. Próxima Fase

Após aprovação da Fase 2:

- **Fase 3 — Consolidação de Backend**: Auditoria do backend contra o ADR e documentação alinhada.
