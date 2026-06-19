# MAPA CANÔNICO - FASE 6
Data: 2026-06-17
Fonte: consolidado de docs/canonical/*.md

---

## ESTRUTURA ALVO (DOCS CANÔNICOS)

Frontend:
- src/shell/
- src/core/
- src/apps/{portal, operacional, painel, totem, admin, social, chat, wiki, analytics}
- src/shared/
- src/themes/
- src/assets/

Backend:
- src/api/
- src/kernel/
- src/services/
- src/integrations/
- src/runtime/
- src/infrastructure/
- src/routes/
- src/middlewares/

---

## FLUXO OFICIAL

Login → Portal → Seleção Contexto → Dashboard → Sistema Operacional

---

## ONTOLOGIA OFICIAL (ordem obrigatória)

saas_entidade → pessoa → pessoa_vinculo → usuario → sessao_usuario → sistema → unidade → local_operacional → workflow → evento → auditoria_evento

---

## DIASPOSITIVOS ESPERADOS

sp_master_dispatcher [OK]
sp_master_query_dispatcher [OK]
sp_master_login [OK]
sp_master_orquestradora [OK]
sp_master_registrar_evento [OK]

---

## TELAS OFICIAIS ESPERADAS

Login, Portal Home, Seleção Contexto, Dashboard Global, Portal Social, Comunicados, Notícias, Calendário, Wiki, Chat, Perfil, Administração, Monitoramento, Auditoria, Configurações, Dashboard Executivo, HIS, Farmácia, PDV, CRM, RH, ERP, Footer Global, Header Global

FIM DO RELATÓRIO FASE 6
