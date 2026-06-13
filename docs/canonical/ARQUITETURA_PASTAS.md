# Estrutura de Pastas (Canonico Imutável + Contextos)

Esta estrutura organiza backend (PHP) e frontend (React) alinhados ao projeto imutável e ao domínio do banco `pronto_atendimento`, com foco em contextos de `unidade` e `local_atendimento`, autenticação e módulos operacionais.

## Backend (`src/api/`)

```
src/api/
  auth/
    login.php          # autenticação (gera JWT), mantém cookie de sessão
    logout.php         # encerra sessão/cookies
    refresh.php        # renova token (suportado pelo axios interceptor)
    me.php             # retorna usuário autenticado e perfis

  contexto/
    contexto_local.php   # GET/POST contexto de local (cookie ctx_local_id)
    contexto_unidade.php # GET/POST contexto de unidade (cookie ctx_unidade_id)
    contexto_sessao.php  # (opcional) controle de sessão operacional

  atendimento/
    abrir.php
    finalizar.php
    recepcao.php
    mudar_local.php

  triagem/
    registrar.php

  fila/
    geral.php
    chamar.php

  internacao/
    inicial.php
    alta.php

  _core/               # helpers internos
  controllers/         # camadas de controle/domain adapters
  routes/              # roteadores agregadores (se aplicável)
  config.php           # getPDO, constantes (JWT_SECRET), .env
  middleware.php       # validação de JWT e usuário ativo
  utils.php            # helpers de perfis e resposta padrão JSON
  jwt.php              # utilitários JWT
  ping.php             # sanity check
```

- Padrões de resposta: JSON com `ok`, `erro`/`mensagem` e payloads consistentes.
- Segurança: exigir perfis por endpoint (ex.: `RECEPCAO`, `TRIAGEM`, `CONSULTORIO`, `INTERNACAO`, `ADMIN`).
- Contexto: cookies (8h) para contexto de unidade/local; pode evoluir para persistência em tabela específica.

## Frontend (`src/`)

```
src/
  shared/
    entities/        # EntidadeFactory (FFA, Fila, Ordem, ContextoLocal, ContextoUnidade)
    operations/      # Operacoes imutáveis por entidade
    validations/     # Validacoes de transições
    history/         # Historico de eventos/snapshots
    constants/       # chaves, enumeradores, contratos

  context/
    AuthContext.jsx
    LocalContext.jsx      # provider de contexto de local
    UnidadeContext.jsx    # provider de contexto de unidade

  services/
    api.js                # cliente axios com refresh
    contexto.service.js   # chamadas de contexto unidade/local
    fila.service.js
    triagem.service.js
    painel.service.js
    usuario.service.js

  routes/
    PrivateRoute.jsx
    RequireContexto.jsx   # garante que há unidade/local definidos
    Routes.jsx            # define módulos operacionais

  pages/
    recepcao/
    triagem/
    consultorio/
    internacao/
    painel/
    contexto/             # telas para selecionar unidade/local

  modules/
    operacao/
    painel/

  components/             # UI compartilhada
  layouts/                # Admin, Operacao, Painel
```

### Fluxo de Contexto (Frontend)
- Montagem: `LocalProvider` e `UnidadeProvider` consultam GET inicial e populam estado.
- Atualização: ao escolher `local_id`/`unidade_id`, chamam POST e atualizam estado.
- Guard: `RequireContexto` redireciona para `pages/contexto` se contexto não estiver configurado.

### Contratos e Imutabilidade
- `entities`: objetos criados por fábricas, sem mutação interna; transformações via `operations`.
- `validations`: regras de negócio para prevenir transições inválidas (ex.: mudar local sem sessão ativa).
- `history`: toda operação relevante gera evento e snapshot legível por auditoria.

## Mapeamento Banco → Domínio
- `unidade`: tabela `unidade` (chave de contexto; escopo).  
- `local_atendimento`: tabela `local_atendimento` (sub-contexto).  
- `usuario` e `perfil`: autenticam e autorizam operações por módulo.  
- `atendimento`, `triagem`, `fila`: entidades processuais alinhadas a operações imutáveis.

## Observações
- Cookies de contexto são transição rápida; pode-se migrar para `usuario_contexto` com persistência no BD e expiração.
- Adapte perfis exigidos por endpoint conforme sua matriz de perfis (docs/API_ENDPOINTS.md).
- `.env`: mova segredos e credenciais do MySQL (usuário dedicado), JWT_SECRET e API_BASE.