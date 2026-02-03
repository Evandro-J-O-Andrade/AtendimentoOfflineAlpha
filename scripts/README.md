# Scripts de Banco de Dados (scripts/)

Este diretório contém utilitários para reparar e garantir o esquema do banco de dados local `pronto_atendimento`.

Passo a passo para recuperação quando a execução de `antendimento.sql` falhar no meio (ex.: rotina/triggers incompletos):

1. No MySQL Workbench ou CLI, execute o script de reparo para remover objetos parciais:
   - `mysql -u root -p < scripts/db_repair.sql`  (ou abra o arquivo e execute no Workbench)
   - OU `php scripts/db_repair.php` (executa os comandos via PDO usando `src/api/config.php`)

2. Re-execute `antendimento.sql` (preferível executar no Workbench para acompanhar saídas e delimitadores DOT/$$):
   - Abra `antendimento.sql` e execute tudo (ou execute partes até a área onde falhou anteriormente).

3. Após `antendimento.sql` concluir com sucesso, garanta o esquema básico chamando a procedure adicionada:
   - `mysql -u root -p < scripts/ensure_schema_call.sql`  ou execute `CALL sp_ensure_schema()` no Workbench.

Observações:
- Os scripts usam `IF EXISTS`/`IF NOT EXISTS` onde aplicável para evitar erros.
- Tenha certeza de que o usuário MySQL usado tem permissões de DDL (CREATE/DROP/ALTER) para aplicar essas mudanças.
- Se encontrar erros de permissões, execute os comandos com um usuário com privilégios administrativos.


## Autenticação: migration de refresh tokens

Adicionado `scripts/create_refresh_tokens.sql` para criar a tabela `usuario_refresh` (hash do token, expiração, revogação, user_agent, ip).

Como aplicar:
1. No MySQL Workbench ou CLI: `mysql -u root -p pronto_atendimento < scripts/create_refresh_tokens.sql`
2. Confirme a presença da tabela: `SELECT * FROM usuario_refresh LIMIT 1;` (deve retornar zero linhas inicialmente).

Endpoints novos/atualizados:
- `POST /api/auth.php` — retorna `{ token, usuario }` e **seta cookie HttpOnly** `refresh_token` (30 dias)
- `POST /api/auth/refresh.php` — usa **cookie HttpOnly** `refresh_token` para rotacionar e retorna novo `{ token }` (novo cookie setado)
- `POST /api/auth/logout.php` — usa **cookie HttpOnly** `refresh_token` para revogar e limpa o cookie (logout)

Sessões / gestão:
- `GET /api/auth/sessions.php` — retorna lista de sessões do usuário autenticado; aceita `?user_id=` para admins
- `POST /api/auth/revoke_session.php` — body `{ id_refresh }` — revoga sessão específica (admin ou dono)
- `POST /api/auth/revoke_all.php` — revoga todas as sessões do usuário (admin pode passar `{ user_id }` para outro usuário)

Exemplo (curl, usando cookie):
- curl -i -c cookies.txt -X POST -H "Content-Type: application/json" -d '{"login":"recepcao1","senha":"Senha123!"}' http://localhost/api/auth.php
- curl -b cookies.txt http://localhost/api/auth/sessions.php
- curl -b cookies.txt -X POST http://localhost/api/auth/revoke_all.php

UI:
- A nova rota `/account/sessions` exibe as sessões do usuário logado.
- Usuários com perfil `ADMIN` podem inserir um `user_id` para visualizar sessões de outro usuário e revogá-las.


### Teste rápido (PowerShell)
Criei `scripts/test_auth_flow.ps1` que executa uma sequência simples (login → refresh → logout). Ajuste URL/credenciais se necessário e execute no PowerShell:

pwsh scripts\test_auth_flow.ps1 -Login "recepcao1" -Senha "Senha123!"

### Teste rápido (Node)
Também adicionei um script Node `scripts/test_auth_flow.js` que roda a mesma sequência. Execute com:

node scripts/test_auth_flow.js

(Use as variáveis de ambiente `BASE_URL`, `TEST_LOGIN`, `TEST_SENHA` se precisar alterar o host/credenciais.)

Se quiser, posso adicionar testes E2E com Playwright/Cypress para executar isso no CI.

Se quiser, posso executar os passos de migração e validação localmente — confirme que quer que eu rode os scripts no seu ambiente. 🎯
