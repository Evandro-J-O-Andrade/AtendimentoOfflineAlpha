# MD-016 — Auditoria

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o modelo canônico de auditoria, garantindo rastreabilidade completa de toda ação relevante executada na plataforma, com imutabilidade, isolamento por tenant e conformidade regulatória.

---

## Princípio Fundamental

```text
Sem evento, não existe operação.
Sem auditoria, não existe confiança.
Sem tenant isolado, não existe conformidade.
```

---

## Modelo Canônico De Auditoria

### Evento Canônico

Toda ação relevante gera um evento canônico no Event Store.

```json
{
  "evento_uuid": "UUID",
  "uuid_transacao": "UUID",
  "dominio": "FILA",
  "acao": "SENHA_CHAMADA",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "payload": {},
  "resultado": {},
  "timestamp": "datetime"
}
```

### Campos Obrigatórios

| Campo            | Descrição                                      |
| ---------------- | ---------------------------------------------- |
| evento_uuid      | Identificador único do evento                   |
| uuid_transacao   | Identificador da transação correlacionada       |
| dominio          | Domínio da aplicação (HIS, PDV, CRM, etc.)     |
| acao             | Ação executada (SENHA_CHAMADA, VENDA_FINALIZADA) |
| id_sessao_usuario | Sessão que executou a ação                     |
| id_tenant        | Tenant proprietário do contexto                 |
| id_unidade       | Unidade operacional onde ocorreu                |
| id_local         | Local físico da operação                        |
| payload          | Dados de entrada da ação                        |
| resultado        | Dados de saída da ação                          |
| timestamp        | Momento exato da execução                       |

---

## Tipos De Evento

### Eventos Operacionais

```text
SENHA_GERADA
SENHA_CHAMADA
TRIAGEM_INICIADA
MEDICAMENTO_DISPENSADO
PACIENTE_ENCAMINHADO
VENDA_FINALIZADA
CHAMADO_ABERTO
CHAMADO_RESOLVIDO
CONTRATO_ASSINADO
PAGAMENTO_REGISTRADO
```

### Eventos De Sistema

```text
LOGIN
LOGOUT
SESSAO_CRIADA
SESSAO_INVALVIDA
CONTEXTO_ALTERADO
APLICACAO_ACESSADA
CONFIGURACAO_ALTERADA
```

### Eventos De IA

```text
IA_CHAT_RESPOSTA_GERADA
IA_ANALISE_CONCLUIDA
IA_SUGESTAO_APROVADA
IA_SUGESTAO_REJEITADA
IA_WORKFLOW_EXECUTADO
```

### Eventos De Runtime

```text
RUNTIME_SINCRONIZACAO_CONCLUIDA
RUNTIME_RECONCILIACAO
RUNTIME_FALHA_SINCRONIZACAO
RUNTIME_OFFLINE_INICIADO
RUNTIME_ONLINE_RESTAURADO
```

### Eventos De Segurança

```text
PERMISSAO_NEGADA
TENTATIVA_ACESSO_NAO_AUTORIZADO
TOKEN_INVALIDO
TENTATIVA_INTRUSAO_DETECTADA
```

---

## Imutabilidade

### Regras

1. Eventos não podem ser alterados após registro.
2. Eventos não podem ser excluídos.
3. Eventos não podem ser reordenados.
4. Correções são feitas por eventos de correção, não por alteração.
5. Exclusão de dados é feita por evento de anonimização, não por delete.

### Implementação

```text
Event Store é append-only.
Cada evento referencia o anterior via chain ou hash.
Timestamp fixo no momento do registro.
Registro em ordem de ocorrência, não de inserção.
Assinatura digital opcional para eventos críticos.
```

---

## Rastreabilidade

### Cadeia Completa

```text
Evento
  ↓
Sessão (quem executou)
  ↓
Contexto (onde executou)
  ↓
Timestamp (quando executou)
  ↓
Payload (o que foi executado)
  ↓
Resultado (qual foi o resultado)
  ↓
Evento Pai (transação pai, se houver)
  ↓
Proximos Eventos (efeitos colaterais)
```

### Correlação

```text
uuid_transacao: agrupa eventos de uma mesma operação
evento_uuid: identifica evento individual
cadeia: vincula eventos relacionados
timeline: ordena eventos no tempo real
```

---

## Isolamento Multi-Tenant

### Regras

1. Eventos de um tenant não são misturados com eventos de outro tenant.
2. Filtros de tenant são obrigatórios em toda consulta de auditoria.
3. Indexação de Event Store inclui id_tenant.
4. Backup e exportação respeitam isolamento de tenant.
5. Auditoria externa acessa apenas eventos de tenants autorizados.

### Implementação

```sql
CREATE INDEX idx_evento_tenant ON evento (id_tenant, timestamp);
```

```text
Toda query de auditoria inicia com:
WHERE id_tenant = ?
```

---

## Retenção E Armazenamento

### Retenção

| Tipo de Evento       | Retenção Mínima | Justificativa           |
| -------------------- | --------------- | ----------------------- |
| Operacional          | Permanente      | Histórico clínico/financeiro |
| Sistema              | 7 anos          | Conformidade            |
| IA                   | 3 anos          | Rastreabilidade         |
| Segurança            | Permanente      | Investigação de incidentes |
| Runtime              | 1 ano           | Debug operacional       |

### Armazenamento

```text
Eventos quentes (recentes): em banco primário
Eventos mornos (últimos 90 dias): em data warehouse
Eventos frios (histórico): em armazenamento de longo prazo
Eventos críticos: replicados em cofre imutável
```

### Compressão E Particionamento

```text
Particionamento por tenant e por mês
Compressão para eventos históricos
Arquivo morto automatizado
Restauração sob demanda com SLA definido
```

---

## Replay E Reconstrução

### Capacidades

1. Eventos permitem reconstruir estado de qualquer recurso.
2. Replay de eventos reproduz histórico exato.
3. Snapshot periódico reduz tempo de replay.
4. Replay é usado para debug, auditoria externa e migração.

### Implementação

```text
Replay determinístico (mesmos eventos = mesmo resultado)
Replay seletivo (por tenant, por domínio, por período)
Checkpoint para replay longo
Log de replay para auditoria do próprio processo
```

---

## Eventos Críticos E Compliance

### Eventos Que Requerem Tratamento Especial

```text
Operações financeiras: assinatura digital
Eventos clínicos: imutabilidade reforçada
Ações de IA: registro de confirmação humana
Exclusões: evento de anonimização, nunca delete
Alterações de permissão: duplo registro
```

### Compliance Regulatório

```text
LGPD: direito ao esquecimento via anonimização rastreável
Regulamentação de saúde: histórico imutável conforme exigido
Regulamentação financeira: não-repúdio e imutabilidade
ISO 27001: trilha de auditoria completa
SOC 2: logs de acesso e modificação imutáveis
```

---

## Ferramentas E Interfaces

### Event Store API

```text
Escrita: append-only, retorna confirmacao
Leitura: por filtro, por correlacao, por dominio
Replay: seletivo, com callback
Stream: eventos em tempo real por dominio
```

### Interfaces De Auditoria

```text
Painel Operacional: eventos recentes por tenant
Painel de Segurança: eventos de segurança críticos
Painel de Compliance: relatórios regulatórios
Painel de Debug: replay seletivo para desenvolvimento
API de Exportação: exportação oficial para autoridades
```

---

## Integração Com Outros Módulos

- Event Store: implementa o modelo canônico de auditoria.
- Dispatcher: toda ação executada pelo Dispatcher gera evento.
- Security: eventos de segurança são priorizados e replicados.
- Analytics: eventos alimentam métricas e KPIs.
- Runtime: ações locais são registradas como eventos.
- IA: toda ação de IA gera evento para rastreabilidade.

---

## Responsabilidades

Time De Auditoria É Responsável Por:

```text
Manter modelo canônico de eventos
Garantir imutabilidade do Event Store
Implementar retenção e arquivo morto
Disponibilizar interfaces de consulta
Gerar relatórios de compliance
Manter políticas de retenção alinhadas a regulamentação
Treinar times em registro correto de eventos
```

Times De Aplicação São Responsáveis Por:

```text
Registrar evento para toda ação relevante
Utilizar tipos de evento canônicos
Fornecer payload e resultado completos
NÃO registrar eventos duplicados
NÃO registrar eventos incompletos
NÃO registrar eventos fora do formato canônico
Reportar gaps de auditoria identificados
