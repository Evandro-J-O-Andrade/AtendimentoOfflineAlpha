# WORKFLOW_CANONICO.md

## Estado Canônico

```
AGUARDANDO
→ EM_PROCESSAMENTO
→ CONCLUIDO
→ ERRO
```

## Transição por Evento

```
EVENTO
→ Validação
→ Execução SP
→ Atualização Estado
→ Auditoria
```

## Workflows Assistenciais

- `SENHA_GERADA` → Fila → `FFA_ABERTA`
- `TRIAGEM_CONCLUIDA` → `CONSULTA_AGUARDANDO`
- `MEDICO_INICIA` → `FFA_EM_ATENDIMENTO`