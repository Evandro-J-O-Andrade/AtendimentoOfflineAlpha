# BANCO CANÔNICO

Status: OFICIAL

---

# FONTE DA VERDADE

O banco é a fonte da verdade.

O frontend não implementa regras de negócio.

---

# RESPONSABILIDADES

Banco:

- Regras
- Permissões
- Contextos
- Workflows
- Auditoria

Frontend:

- Exibição
- Interação
- Navegação

---

# STORED PROCEDURES

Toda operação crítica deve ocorrer através de SPs.

Exemplos:

- autenticação
- contexto
- permissões
- execução operacional

---

# PROIBIDO

- Duplicar regras do banco no frontend
- Hardcode de permissões
- Hardcode de estados operacionais

---

# AUDITORIA

Toda ação operacional deve possuir rastreabilidade.