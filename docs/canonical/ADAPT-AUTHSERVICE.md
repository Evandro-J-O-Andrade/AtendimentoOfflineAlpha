# ADAPT-AUTHSERVICE

```text
Tipo:           ADAPT cirúrgico (porta de entrada do Kernel)
Status:         READ ONLY
Classificação:  REUSE / ADAPT
Implementação:  NÃO
```

> Caso cirúrgico: `AuthService` é o **primeiro elo** da cadeia (Cliente → Kernel). Qualquer decisão
> incorreta aqui se propaga para Sessão, Contexto, Permissões, Runtime e Discovery. Responde a três
> perguntas: (1) o que faz hoje, (2) o que deveria fazer, (3) gap de cada etapa. Vinculado a
> `GATE-BACKEND-RUNTIME`, `BACKEND-RUNTIME-AUDIT`, `BACKEND-CONTEXT-ADAPT-PLAN`.

## 1. O que o AuthService faz hoje (evidências)

```text
AuthService.authenticate()
   ↓ SELECT id_usuario, senha, ativo FROM usuario   (AuthService.ts:59)
   ↓ bcrypt.compare(password, usuario.senha)         (AuthService.ts:71)
   ↓ jwt.sign(...)                                    (AuthService.ts:76-80)
   ↓ login() → sp_master_login                        (AuthService.ts:82 / :11)
   ↓ retorna sessão ao frontend                       (AuthService.ts:49-53)
```

| Passo | Arquivo:Linha | Banco Vivo correspondente | Classificação |
| --- | --- | --- | --- |
| Buscar usuário | `AuthService.ts:59` | `usuario` (tabela existe) | ADAPT (SQL direto = bypass) |
| Validar senha | `AuthService.ts:71` | nenhuma SP valida senha (auditado) | REUSE (Backend dono) / AUDITAR |
| Gerar JWT | `AuthService.ts:76` | `sp_master_login` espera `token_jwt` (não gera) | REUSE / AUDITAR papel |
| Criar sessão | `AuthService.ts:11` | `sp_master_login:25668` | ADAPT (não popula `id_entidade`/`id_unidade`) |
| `session()` | `AuthService.ts:87` | `sp_sessao_contexto_get:32241` | ADAPT (`id_entidade←id_sistema :97`; `id_local_operacional :99`) |
| `context()` | `AuthService.ts:108` | `sp_auth_contexto_get:17380` | REUSE |
| `selectContext()` | `AuthService.ts:128` | `sp_auth_contexto_set:17479` | REUSE |

## 2. O que deveria fazer (só Banco Vivo)

```text
Cliente
   ↓ AuthService
   ↓ sp_master_login
sessao_usuario
   ↓ sp_auth_contexto_get
Frontend escolhe contexto
   ↓ sp_auth_contexto_set
sp_sessao_assert
   ↓ JWT
Resposta
```

Sem componentes novos. O `AuthService` **orquestra** o Kernel; não contorna.

## 3. Gap de cada etapa

| Etapa | Atual | Kernel | Classificação |
| --- | --- | --- | --- |
| Buscar usuário | SQL direto | `sp_master_login` (via token) | ADAPT |
| Validar senha | Backend (bcrypt) | (não há SP) — **AUDITAR dono** | REUSE (Backend) / decidir via GATE |
| Criar sessão | Parcial | `sp_master_login` | ADAPT |
| Resolver tenant | Ausente/errado (`id_entidade←id_sistema`) | `sessao_usuario.id_entidade` + `sp_auth_contexto_get` | ADAPT |
| Resolver contexto | Ausente | `sp_auth_contexto_get/set` | ADAPT |
| JWT | Backend (`jwt.sign`) | `sp_master_login` espera `token_jwt` | AUDITAR papel |

## AUDITORIA — Validação da senha (fonte primária consultada)

```text
AUDITORIA
Objeto:   Validação da senha de login
Existe no Banco Vivo?        NÃO  (nenhuma SP valida credencial; sp_master_login lê usuario.senha
                                mas NÃO compara — exige apenas token_jwt presente)
Existe equivalente?          NÃO  (sp_atendimento_senha_*, sp_chamar_senha, sp_complementar_senha
                                são de fila; sp_permissao_validar/sp_usuario_refresh_token_validar
                                são outros domínios)
Responsável oficial:         Backend (AuthService.authenticate + bcrypt) — atual
Classificação:               REUSE (manter no Backend)
Nota: Mover para SP = ADAPT/PROPOSE e EXIGE decisão de GATE. Não por preferência arquitetural.
```

## MAPEAMENTO DE IDENTIDADE (campos do Runtime)

| Backend | Banco Vivo | Status | Classificação |
| --- | --- | --- | --- |
| `idSistema` | `id_entidade` | ❌ INVÁLIDO | ADAPT |
| `idLocalOperacional` | `id_local` | ❌ INVÁLIDO | ADAPT |
| `tenant` | `id_entidade` | ⚠️ | ADAPT |
| `context` | `usuario_contexto` | ⚠️ | ADAPT |
| `session` | `sessao_usuario` | ✅ | REUSE |
| `id_usuario` | `id_usuario` | ✅ | REUSE |
| `id_unidade` | `id_unidade` | ⚠️ (sp_master_login não popula) | ADAPT |
| `id_perfil` | `id_perfil` | ⚠️ (sp_master_login não popula) | ADAPT |

## CONCLUSÃO

```text
REUSE    2   (id_usuario · session)
ADAPT    6   (SQL direto · tenant · contexto · id_local · id_unidade · id_perfil)
EXTEND   0
MERGE    0
PROPOSE  0   (sem novo componente; validação de senha permanece no Backend — REUSE)

DECISÃO
ADAPT cirúrgico do AuthService: eliminar SQL direto (router tudo por sp_master_login), corrigir
MAPEAMENTO DE IDENTIDADE (id_entidade/id_local), e NÃO mover a validação de senha sem GATE.
```
