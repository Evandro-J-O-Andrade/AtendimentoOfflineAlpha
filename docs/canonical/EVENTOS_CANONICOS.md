# EVENTOS_CANONICOS.md

## Catálogo Oficial de Eventos

### Identidade
- `PESSOA_CADASTRADA` - Nova pessoa criada
- `USUARIO_CRIADO` - Usuário gerado
- `SESSAO_INICIADA` - Login realizado
- `SESSAO_INVALIDA` - Sessão expirada

### Assistencial
- `SENHA_GERADA` - Senha emitida
- `FFA_ABERTA` - Ficha de atendimento criada
- `GPAT_CRIADO` - GPAT iniciado
- `TRIAGEM_REGISTRADA` - Triagem concluída
- `CONSULTA_INICIADA` - Consulta médica iniciada
- `MEDICACAO_PRESCRITA` - Medicamento prescrito
- `MEDICACAO_DISPENSADA` - Medicamento dispensado
- `ALTA_CONCLUIDA` - Alta registrada

### Farmácia
- `ESTOQUE_MOVIMENTADO` - Movimento de estoque
- `LOTE_VENCIDO` - Lote próximo ao vencimento
- `COMPRA_SOLICITADA` - Compra solicitada

### Financeiro
- `CONTA_LANCADA` - Conta lançada
- `PAGAMENTO_REALIZADO` - Pagamento confirmado

### Workflow
- `TRIGGER_DISPARADO` - Trigger executado
- `FILA_PROCESSADA` - Fila sincronizada

## Formato do Evento

```json
{
  "id_evento": "uuid",
  "tipo": "NOME_DO_EVENTO",
  "categoria": "ASSISTENCIAL",
  "id_sessao_usuario": 123,
  "id_unidade": 1,
  "payload": { ... },
  "resultado": { ... },
  "data_hora": "2026-06-18T23:49:37Z"
}
```