# PLANO DE DOCUMENTAÇÃO — DUMP20260606.PRONTO_ATENDIMENTO
**Data:** 2026-06-30  
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Status:** Em execução — Etapas 1-5 paralelas

---

## ETAPAS CONCLUÍDAS

### ✅ Checklist de Integridade Canônico
- 132 MDs | 45 MAPs | 5 BRs | 83 FRONTs | 3 ADRs
- 478 tabelas no dump
- 481 docs de tabela (3 extras: INVENTARIO_COMPLETO, portal_categoria, portal_noticia)
- 228 procedures documentadas (objetivo genérico)
- 0 views/functions/triggers/events documentados
- **Gap:** ~273 procedures faltantes, todas as procedures precisam de detalhamento

### ✅ Âncora Contextual
- `docs/database/ESTADO_DOCUMENTACAO.md` criado

---

## ETAPAS EM EXECUÇÃO (PARALELAS)

1. **Inventário Tabelas Dump20260606** → classificação por domínio, status de documentação
2. **Inventário Procedures** → varredura completa de procedures no código e docs
3. **Inventário Views/Functions/Triggers/Events** → caça a esses objetos
4. **Mapa Dependências e ERD** → grafos de FKs, tabelas raiz/folha/centrais

---

## PRÓXIMAS ETAPAS (APÓS CONCLUSÃO DAS PARALELAS)

5. **Catálogo de Stored Procedures** — base para MDs/MAPs/BRs
   - Nome, objetivo, domínio
   - Tabelas lidas (SELECT)
   - Tabelas escritas (INSERT/UPDATE/DELETE)
   - SPs chamadas
   - Fluxo de consumo

6. **Matriz de Dependência das Tabelas** — hierarquia tipo árvore
   - Pessoa → Usuario → UsuarioPerfil → UsuarioSistema
   - FFA → Atendimento → Prescricao → Internacao
   - etc.

7. **Mapa de Consumo por Módulo**
   - Portal → sp_auth_menu_get, sp_notification, sp_profile
   - HIS → sp_atendimento_create, sp_prescription, etc.
   - Runtime → sp_runtime_*, sp_worker_*

8. **Catálogo de Entidades do Core**
   - Identity: pessoa, usuario, auth_*, perfil, permissao
   - Portal: portal_*, painel_*, totem_*, tv_rotativo_*
   - Runtime: runtime_*, kernel_*
   - ACL/Authorizacao: kernel_authz_policy, guardiao_*
   - Auditoria: auditoria_*, log_*, auth_log
   - Event Store: *_evento, *_ledger, *_historico
   - SaaS: tenant_registry, saas_*, entity_*
   - Healthcare: senha, fila_*, ffa, atendimento_*, triagem, gpat
   - Financeiro: caixa, venda_*, faturamento_*
   - Estoque: estoque_*, almoxarifado_*
   - Farmácia: administracao_medicacao, dispensacao_medicacao
   - Laboratório: lab_*, laboratorio_*, procedimento_protocolo_*
   - Display: painel_*, totem_*, tv_rotativo_*
   - Integração: integracao_*, webhook_*, sinan_*

9. **Mapa de Escrita**
   - Para cada tabela: quais SPs fazem INSERT/UPDATE/DELETE
   - Respeita filosofia SP-First

10. **Documentação 100% Tabelas**
    - Completar objetivo, descrição, função de cada coluna
    - Relacionamentos, cardinalidade, dependências
    - Fluxo de utilização

11. **Documentação 100% Procedures**
    - Detalhar todas as 228 procedures
    - Depois completar as ~273 faltantes

12. **Documentação Views/Functions/Triggers/Events**

13. **Gerar Blueprints, MDs, BRs, MAPs, FRONTs**
    - Alinhados com o banco real
    - Referenciando tabelas e SPs reais

---

## DIRETRIZES

- NUNCA resumir
- NUNCA omitir objetos
- NUNCA criar v2
- SEMPRE atualizar documentos existentes
- SEMPRE seguir a Constituição (000-CONSTITUICAO-IA.md)
- SEMPRE usar Dump20260606.sql como fonte da verdade
- NUNCA usar portal_schema.sql como referência principal (é histórico)

---

## COMO CONTINUAR

Quando retomar:
1. Ler ESTADO_DOCUMENTACAO.md
2. Verificar quais tasks paralelas concluíram
3. Consolidar relatórios
4. Executar etapas 5-13 na ordem definida
5. Atualizar ESTADO_DOCUMENTACAO.md a cada etapa
