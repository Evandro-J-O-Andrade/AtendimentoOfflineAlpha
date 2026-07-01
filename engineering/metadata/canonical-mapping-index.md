# CANONICAL MAPPING INDEX

## 📊 Matriz de Rastreabilidade

| Domínio | Tabelas | Procedures | MD | BR | FRONT | MAP | Contracts | Status |
|---------|---------|------------|-----|-----|-------|-----|-----------|--------|
| Core    | 36      |            |     |     |       |     |           |        |
| IAM     | 3       |            |     |     |       |     |           |        |
| HIS     | 67      |            |     |     |       |     |           |        |
| Displays|         |            |     |     |       |     |           |        |
| Workforce| 5      |            |     |     |       |     |           |        |
| BI      |         |            |     |     |       |     |           |        |
| Integration| 1    |            |     |     |       |     |           |        |
| Suporte |         |            |     |     |       |     |           |        |
| Agendamento| 3     |            |     |     |       |     |           |        |
| SAC     | 4       |            |     |     |       |     |           |        |
| Regulacao| 1      |            |     |     |       |     |           |        |
| Unknown | 358     |            |     |     |       |     |           |        |

---

## 🗂 DOMÍNIO → OBJETOS

### Core (36 tabelas)
- **Tabelas**: pessoa, usuario, tenant_registry, saas_entidade, etc.
- **Procedures**: sp_gera_protocolo_lab
- **MD**: MD-001 (pendente)

### IAM (3 tabelas)
- **Tabelas**: perfil, perfil_usuario, permissao, papel, grupo
- **MD**: MD-002 (pendente)

### HIS (67 tabelas)
- **Tabelas**: senha, fila, ffa, atendimento, triagem, totem
- **Procedures**: sp_finalizar_senha, sp_fila_*, sp_ffa_*, sp_executor_*
- **MD**: MD-021 (pendente)

### Agendamento (3 tabelas)
- **Tabelas**: agenda_disponibilidade, agendamento, agendamentos_eventos
- **MD**: (faltando)

### SAC (4 tabelas)
- **Tabelas**: ticket_sac, chamado, atendimento_sac
- **MD**: (faltando)

### Regulacao (1 tabela)
- **Tabelas**: regulacao, transferencia
- **MD**: (faltando)