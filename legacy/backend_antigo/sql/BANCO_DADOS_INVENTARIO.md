# 🗄️ INVENTÁRIO CANÔNICO - DUMP 20260606

## 🔑 NÚCLEO DE IDENTIDADE (AUTH)
- `saas_entidade`: Raiz do Multi-Tenancy.
- `usuario`: Identidades globais.
- `sessao_usuario`: O elo entre Identidade e Runtime Context.
- `perfil` / `permissao`: RBAC Granular.

## ⚙️ NÚCLEO DE PROCESSO (RUNTIME)
- `ffa`: O container universal de processos de negócio.
- `atendimento`: A instância operacional ativa.
- `fila_operacional`: Motor de priorização e chamadas.
- `local_operacional`: Onde a operação ocorre (Contexto).

## 📜 NÚCLEO DE AUDITORIA (LEDGER)
- `atendimento_evento_ledger`: Audit trail imutável para conformidade.
- `erro_evento`: Rastreamento de falhas sistêmicas.
- `auditoria_contexto`: Log de trocas de unidade/local.

## 📦 NÚCLEO DE RECURSOS (OPERATIONAL)
- `estoque_produto` / `estoque_saldo`: Gestão de ativos/insumos.
- `faturamento_item`: Geração de valor financeiro a partir de eventos.
- `documento_emissao`: Repositório de saídas formais (PDF/XML).

## ⚠️ REDUNDÂNCIAS DETECTADAS
1. `anamnese` vs `atendimento_anamnese` (Migrar para atendimento_anamnese).
2. `diagnostico` vs `atendimento_diagnostico` (Migrar para atendimento_diagnostico).
3. `evolucao_medica` vs `atendimento_evolucao` (Unificar em atendimento_evolucao).