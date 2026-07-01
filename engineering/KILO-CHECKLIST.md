# KILO CHECKLIST — PRÓXIMA EXECUÇÃO

## QUANDO DUMPS DISPONÍVEIS

### 1. DISCOVERY ENGINE
- [ ] Executar inventário de tabelas
- [ ] Executar inventário de SPs
- [ ] Executar inventário de events
- [ ] Executar inventário de FKs
- [ ] Executar inventário de índices

### 2. DOMAIN MAPPING
- [ ] Mapear tabelas → domínios
- [ ] Identificar MDs correspondentes
- [ ] Identificar domínios faltando

### 3. CANONICAL SYNC
- [ ] Atualizar MD-{NUMBER} files
- [ ] Atualizar BR-{NUMBER} files
- [ ] Atualizar FRONT-{NUMBER} files
- [ ] Atualizar MAP-{NUMBER} files

### 4. GENERATION ENGINE
- [ ] Gerar SP stubs (missing)
- [ ] Gerar API contracts
- [ ] Gerar TypeScript types
- [ ] Gerar Mermaid diagrams

### 5. OUTPUT
- [ ] inventory/tables.json
- [ ] inventory/procedures.json
- [ ] metadata/domain-mapping.md
- [ ] metadata/md-mapping-index.md

---

*KILO ENGINE v7 pronto para discovery*