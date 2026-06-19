# MAP-006 — Permissões

## Status

Documento Canônico De Mapeamento.
Fonte: dump + backend legacy.

---

## Entidades Identificadas

| Entidade | Tabela / Arquivo | Observação |
|----------|------------------|------------|
| Usuário | usuario | login/hash/senha |
| Pessoa | pessoa | dados pessoais |
| Perfil | perfil | RBAC |
| Permissão | permissao + perfil_permissao | granural por ação |
| Sessão | sessao_usuario + auth_sessao | múltiplas representações no dump |
| Contexto | usuario_contexto + contexto_atendimento | contexto operacional por usuário |
| Unidade | usuario_unidade / unidade | multi-unidade |
| Local | usuario_local / local_operacional | multi-local |
| Grupo | auth_grupo / auth_grupo_permissao / auth_grupo_usuario | agrupamento extra de ACL |
| Token | usuario_refresh / usuario_refresh_token / auth_token | refresh + sessão |
| Dispositivo | auth_sessao_dispositivo | sessão por dispositivo |
| Profissional | usuario_profissional_registro / profissional_registro | vínculo profissional |

## SPs Relacionadas

- sp_auth_contexto_get
- sp_auth_contexto_set
- sp_auth_menu_get
- sp_contexto_assert_permissao
- sp_acl_registrar_evento

## Observações

- Há duplicidade entre `sessao_usuario`, `auth_sessao`, `sessao_ativa`; convergência canônica deve ser feita em Fase 3.
