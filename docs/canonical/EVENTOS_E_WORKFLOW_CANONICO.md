# EVENTOS_E_WORKFLOW_CANONICO.md

## Motor Único de Eventos

A plataforma possui um único motor canônico de eventos.

```
AÇÃO
↓
EVENTO
↓
ORQUESTRADOR (sp_master_dispatcher_runtime)
↓
ESTADO
```

## Stored Procedures Canônicas

```sql
procedures/
├── sp_master_dispatcher_runtime.sql  (Entrada única)
├── sp_auth_*.sql                    (Autenticação)
├── sp_evento_*.sql                  (Eventos)
├── sp_auditoria_*.sql               (Auditoria)
└── sp_executor_*.sql                (Executores especializados)
```

## Formato do Evento

```json
{
  "metodo": "GET | SET | POST | REQUEST",
  "rota": "AUTH.LOGIN | PORTAL.APLICACOES | ASSISTENCIAL.SENHA_EMITIR",
  "id_sessao": 123,
  "payload": { ... }
}
```

## Executores Especializados

| Executor | Domínio |
|----------|---------|
| sp_executor_fila | Fila e senhas |
| sp_executor_triagem | Triagem clínica |
| sp_executor_medico | Atendimento médico |
| sp_executor_farmacia | Farmácia e estoque |
| sp_executor_estoque | Movimentação estoque |
| sp_executor_painel | Painéis de chamada |

## Policentrismo Proibido

- ❌ Múltiples rotas de entrada para mesma operação
- ❌ Múltiplas procedures para mesmo caso de uso
- ❌ Acoplamento direto ao banco sem dispatcher
- ❌ Eventos sem rastreio de sessão