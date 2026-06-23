# MAP-009 — Mapa de Analytics & Data

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada + MDs de dados.

---

## Componentes Identificados

| Componente | Fonte | Status |
|------------|-------|--------|
| Analytics Canônico | docs/canonical/ANALYTICS_CANONICO.md | TEORIA |
| Enterprise Analytics | docs/canonical/MD-030-Enterprise-Analytics.md | CANONICO |
| Analytics Governance | docs/canonical/MD-033-Analytics-Governance.md | CANONICO |
| Analytics Data Intelligence | docs/canonical/MD-039-Analytics-Data-Intelligence.md | CANONICO |
| Data Lake Architecture | docs/canonical/MD-051-Data-Lake-Architecture.md | CANONICO |
| Data Lakehouse Platform | docs/canonical/MD-085-Data-Lakehouse-Platform.md | CANONICO |
| AI Data Fabric | docs/canonical/MD-052-AI-Data-Fabric.md | CANONICO |
| Knowledge Graph | docs/canonical/MD-054-Knowledge-Graph.md | CANONICO |
| Enterprise Search | docs/canonical/MD-053-Enterprise-Search.md | CANONICO |
| BI Canônico | apps/bi + painel_* + tv_rotativo_* | PARCIAL |

---

## Mapeamento Técnico (Dump + Legado)

| Mecanismo | Tipo | Observação |
|-----------|------|------------|
| painel_* | Tabelas de painéis BI | Presente no dump |
| tv_rotativo_* | TV Dashboard | Presente no dump |
| analytics_* | Dados analíticos | Presente no dump |
| dashboard_* | Metadados de dashboard | Presente no dump |
| Event Store Central | kernel_ledger / auditoria_evento | CANONICO |

---

## Observações

- BI no legado possui estrutura mínima (apps/bi + painéis).
- Analytics canônico está em fase teórica (documentos MD).
- Falta consolidar Data Lakehouse (MD-051 + MD-085).
- Knowledge Graph (MD-054, MD-084) aguarda implementação.
- Enterprise Search (MD-053, MD-087) aguarda implementação.

---

## Próximos Passos

1. Definir camada de Data Warehouse canônica.
2. Consolidar Event Store como fonte primária de analytics.
3. Implementar Data Lakehouse (Raw/Curated/Business/AI).
4. Conectar BI legado aos novos blobs/views canônicas.
