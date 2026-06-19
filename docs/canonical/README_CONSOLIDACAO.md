# 🏥 Pronto Atendimento Alpha - Plataforma New Wave SaaS

> **Status:** Em período de Freeze Arquitetural - aguardando aprovação dos documentos canônicos

## 📌 Status Atual

O projeto está em transição para a arquitetura canônica da Plataforma New Wave SaaS.

### Freeze Arquitetural Ativo

Veja `docs/canonico/FREEZE_ARQUITETURAL_2026.md` para detalhes.

**Nenhuma nova funcionalidade está sendo desenvolvida até a consolidação dos documentos canônicos.**

## 📚 Documentos Canônicos

| Documento | Status |
|-----------|--------|
| ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md | ✅ Consolidado |
| MIGRACAO_CANONICA_2026.md | ✅ Consolidado |
| ESTRUTURA_REPOSITORIO_CANONICO.md | ✅ Consolidado |
| MODELO_DOMINIO_CANONICO.md | ✅ Consolidado |
| FRONTEND_CANONICO.md | ✅ Consolidado |
| BACKEND_CANONICO.md | ✅ Consolidado |
| EVENTOS_E_WORKFLOW_CANONICO.md | ✅ Consolidado |
| OFFLINE_FIRST_CANONICO.md | ✅ Consolidado |
| SEGURANCA_E_IDENTIDADE_CANONICO.md | ✅ Consolidado |

## 📁 Estrutura do Projeto

```text
AtendimentoOfflineAlpha/
│
├── docs/
│   └── canonico/           # Documentos canônicos (12 documentos)
│
├── apps/                   # 16 aplicações enterprise (vazias - aguardando homologação)
│   ├── portal/
│   ├── saude/
│   ├── farmacia/
│   ├── financeiro/
│   ├── faturamento/
│   ├── suprimentos/
│   ├── logistica/
│   ├── rh/
│   ├── ti/
│   ├── crm/
│   ├── compliance/
│   ├── bi/
│   ├── administracao/
│   ├── comercial/
│   ├── contratos/
│   ├── convenios/
│   ├── atendimento/
│   ├── ouvidoria/
│   ├── juridico/
│   ├── patrimonio/
│   └── projetos/
│
├── dispositivos/           # 5 tipos de dispositivos
│   ├── painel/
│   ├── totem/
│   ├── kiosk/
│   ├── mobile/
│   └── tv_corporativa/
│
├── packages/               # 17 packages canônicos
├── backend/                # Backend canônico
├── database/               # Schema e procedures
├── dashboards/             # 17 dashboards
├── workflow/               # Workflows por domínio
├── ia/                     # IA e automações
├── runtime/                # Runtime offline-first
├── integracoes/            # Integrações externas
├── assets/                 # Styles, imagens, ícones
│
└── legacy/
    ├── frontend_antigo/
    ├── backend_antigo/
    ├── docs_antigos/
    └── frontend_rebuild_candidate/
    └── backend_rebuild_candidate/
```

## 🎯 Próximos Passos

1. Finalizar documentos pendentes (Portal Corporativo Canônico, Assistencial Canônico)
2. Realizar auditoria técnica dos artefatos legados
3. Iniciar processo de recuperação homologada
4. Reativar desenvolvimento após aprovação