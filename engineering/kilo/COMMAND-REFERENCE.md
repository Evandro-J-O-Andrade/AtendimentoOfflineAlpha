# KILO ENGINE v7 — COMMAND REFERENCE

## USO BÁSICO

```bash
# Descoberta completa
kilo discover --dumps ./engineering/dumps/

# Atualizar MDs baseado no dump
kilo sync --target md --domain assistencial

# Gerar contrato API
kilo generate --type api --domain agenda

# Verificar impacto
kilo impact --table senha --change "ADD COLUMN"

# Sincronizar todo o sistema
kilo sync --all
```

## FLAGS PRINCIPAIS

| Flag | Função |
|------|--------|
| discover | inventário dump |
| sync | atualizar artefatos |
| impact | análise de mudanças |
| generate | criar contratos |
| --target | md/br/front/map/adr/contracts |
| --domain | assistencial/farmacia/estoque/etc |
| --change | descrição da mudança |
| --all | sincronização completa |