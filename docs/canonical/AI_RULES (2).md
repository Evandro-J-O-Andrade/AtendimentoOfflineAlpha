# REGRA ABSOLUTA

O sistema NÃO é um HIS.

O sistema NÃO é um ERP.

O sistema é:

New Wave Enterprise
Enterprise Management & Analytics Platform

# FLUXO OBRIGATÓRIO

Login
↓
Portal Corporativo
↓
Aplicação
↓
Contexto (se necessário)
↓
Dashboard
↓
Operação

# PROIBIDO

- Solicitar contexto no login
- Redirecionar para módulos após login
- Misturar AuthContext e OperationalContext
- Criar JSX novos
- Criar regras de negócio no frontend
- Hardcode de permissões

# OBRIGATÓRIO

- React
- TypeScript
- TSX
- Tailwind
- Banco como fonte da verdade