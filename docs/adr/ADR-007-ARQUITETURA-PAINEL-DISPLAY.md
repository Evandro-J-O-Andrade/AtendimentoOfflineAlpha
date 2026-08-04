# ADR-007 — Arquitetura de Painéis/Displays

- **Status:** Aprovado (2026-08-04)
- **Revisão:** Baseado na auditoria canônica Fases 1–12
- **Domínio:** Displays (CORE)
- **Relacionado:** MD-125, MD-126, MD-127, MD-128, MD-130, MD-131, MD-100

---

## 0. Escopo

### Abrange

- Dispositivos de exibição (TV, Totem, Kiosk, VideoWall, Monitor Clínico, Tablet)
- Runtime de Painéis
- Configuração de comportamento
- Integração com o Kernel (serviços compartilhados)

### Não abrange

- Regras de negócio assistenciais (filas, senhas, priorização)
- Autenticação de usuários
- Fluxo de atendimento (chamada, cancelamento, desistência)
- Dashboards específicos e KPIs clínicos
- Integrações com sistemas hospitalares (HIS, RIS, LIS)

---

## 1. Princípio Fundamental

> **Princípio Canônico:** Todo Dispositivo executa exatamente um Painel ativo, e todo Painel possui exceamente uma Configuração efetiva em tempo de execução. O Runtime nunca contém regras de negócio específicas de um tipo de painel; ele apenas interpreta a Configuração e executa o comportamento definido.

---

## 2. Entidades e Responsabilidades

| Entidade        | Responsabilidade                          | Não deve fazer                          |
|-----------------|-------------------------------------------|-----------------------------------------|
| **Dispositivo**  | Identificar e registrar o executor        | Definir regras de negócio               |
| **Painel**       | Representar a função operacional exercida | Armazenar estado do hardware            |
| **Configuração** | Definir o comportamento                   | Executar lógica                         |
| **Runtime**      | Interpretar configuração, montar layout   | Conhecer tipos específicos de painel    |
| **Kernel**       | Serviços compartilhados                   | Conhecer Painéis                        |

### Invariantes

1. Todo Dispositivo possui uma identidade única.
2. Um Painel sempre está associado a um Dispositivo em execução.
3. O Runtime nunca altera a Configuração; ele apenas a consome.
4. O Kernel não conhece tipos de Painel.
5. Configurações podem evoluir sem exigir recompilação do Runtime.

### Diagrama de Dependências

```text
Kernel
   ▲
   │
Runtime
   ▲
   │
Configuração
   ▲
   │
Painel
   ▲
   │
Dispositivo
```

Dependências fluem apenas nesse sentido. Qualquer vínculo invertido constitui violação arquitetural.

---

## 3. Tipos de Painel (Extensível)

O campo `painel.tipo` é **extensível**. Novos tipos podem ser adicionados via configuração sem alterar o Runtime.

### Atendimento
- **Totem Senha** — Gera e exibe senhas
- **Totem Feedback** — Captura satisfação pós-atendimento

### Assistencial
- **Clínico** — Painel de chamadas por sala/coluna
- **Triagem** — Senhas setoriais
- **ECG** — Dados vitais em tempo real
- **RX** — Imagens e status de exames

### Gestão
- **Dashboard** — KPIs operacionais
- **TV Corporativa** — Mensagem institucional, notícias, clima

### Comunicação
- **Informativos** — Mensagens rotativas
- **Mural Digital** — Avisos e comunicados

> Um **Painel não representa um hardware**. Representa um papel operacional desempenhado por um Dispositivo.

---

## 4. Ciclo de Execução

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

---

## 5. Regra de Design

> **O comportamento nasce da Configuração, nunca do tipo do Painel.**

✔ Correto:
```typescript
if (configuracao.tts) ...
if (configuracao.widgets) ...
if (configuracao.filas) ...
```

❌ Incorreto:
```typescript
if (painel.tipo === "TOTEM") { ... }
```

---

## 7. Relação com o Modelo Físico

Este ADR descreve o **modelo conceitual**. O modelo físico atual no banco já implementa esse conceito:

- `dispositivo` + `dispositivo_tipo` → identidade do executor
- `painel` → função operacional (`tipo` é extensível)
- `painel_config`, `painel_config_def` → configuração efetiva
- `totem`, `tv_rotativo`, `local_dispositivo` → especializações existentes

**Futuras mudanças devem preservar a compatibilidade com a estrutura canônica existente.** Qualquer alteração no modelo físico exigirá ADR complementar e aprovação explícita.

---

## 8. Próximos Passos

1. ✅ ADR aprovado.
2. Atualizar documentação canônica (MDs, domain mapping, diagramas).
3. Auditar backend e frontend contra este ADR.
4. Levantar divergências e planos de migração.
5. Implementar alterações somente após alinhamento completo.

---

## 9. Decisão de Não-Ação

> **Nenhuma alteração de código ou banco de dados será feita nesta fase.**

A estrutura de tabelas existente (`painel`, `painel_config`, `painel_config_def`, `totem`, `tv_rotativo`, `dispositivo`, `dispositivo_tipo`, etc.) **já suporta** o modelo canônico descrito. A implementação atual está em scaffold e fragmentada; a correção deverá alinhar código e documentação ao ADR aprovado.