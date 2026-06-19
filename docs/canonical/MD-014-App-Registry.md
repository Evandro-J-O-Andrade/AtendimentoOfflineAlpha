# MD-014 — App Registry

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Registrar todas as aplicações da plataforma como módulos plugáveis, controlar rotas, permissões, temas e dependências de contexto em um catálogo oficial único.

---

## Princípio Fundamental

```text
Nenhuma aplicação existe fora do Registry.
Nenhuma rota operacional existe sem entrada no Registry.
Nenhuma aplicação carrega sem permissão e contexto.
```

---

## Modelo Canônico

```json
{
  "codigo": "PDV",
  "nome": "Ponto de Venda",
  "rota": "/pdv",
  "icone": "shopping_cart",
  "contexto_obrigatorio": true,
  "ativo": true,
  "permissoes": ["PDV.ACESSAR", "PDV.VENDER"],
  "modulos": ["venda", "caixa", "produto"],
  "tema": {
    "cor_primaria": "#0066CC",
    "cor_secundaria": "#004499"
  },
  "dependencias": ["FATURAMENTO", "ESTOQUE"]
}
```

---

## Aplicações Registradas (Exemplos)

```text
PORTAL
HIS
PDV
CRM
SAC
CAT
FINANCEIRO
AVA
BI
ESTOQUE
FARMACIA
ADMIN
```

---

## Estrutura Física Do Registry

```
backend/
  apps/
    registry/
      __init__.py
      routes.py
      handlers.py
      modelos.py
      servicos.py
      repositorio.py

  kernel/
    registry.py

frontend/
  registry/
    config/
      apps.config.ts
    services/
      registry.api.ts
    components/
      AppCard/
      AppGrid/
      AppLauncher/
```

---

## Regras

1. Toda aplicação entra no sistema exclusivamente pelo Registry.
2. Toda aplicação possui código único e imutável.
3. Toda aplicação define se contexto operacional é obrigatório.
4. Toda aplicação declara permissões mínimas de acesso.
5. Toda aplicação pode ser ativada ou desativada por tenant.
6. Nenhuma aplicação pode carregar módulo não listado no Registry.
7. Nenhuma aplicação pode criar rota sem correspondência no Registry.
8. Registry é consultado no login e no carregamento do Portal.
9. Alterações no Registry requerem migração de configuração versionada.
10. Registry alimenta tanto backend (rotas, permissões) quanto frontend (Shell, menu).

---

## Responsabilidades Do Registry

Registry é responsável por:

```text
Catálogo de aplicações
Metadados de cada aplicação
Validação de ativação por tenant
Mapeamento de permissões por aplicação
Configuração de tema por aplicação
Listagem de módulos dependentes
Histórico de versões de aplicação
```

Registry NÃO é responsável por:

```text
Regras de negócio da aplicação
Execução de operações
Autenticação (usa Auth canônico)
Contexto operacional (usa OperationalContext canônico)
Event Store (usa EventStore canônico)
```

---

## Integração Com Backend

Backend consome Registry para:

```text
Validar se aplicação está ativa para o tenant
Validar se usuário tem permissão na aplicação
Carregar módulos da aplicação
Rotear requisições internas
Configurar filtros de contexto
Aplicar regras de auditoria específicas da aplicação
```

---

## Integração Com Frontend

Frontend consome Registry para:

```text
Montar menu do Portal
Habilitar/desabilitar aplicações por tenant
Aplicar tema e branding da aplicação
Validar permissão antes de abrir aplicação
Carregar configuração da aplicação
Lazy load de aplicações registradas
```

---

## Integração Com App Registry Anterior

Este documento expande e substitui MD-007 com:

```text
Suporte a multi-tenant nativo
Metadados de tema e branding
Dependências entre aplicações
Versionamento de aplicação
Controle de módulos por aplicação
Histórico e auditoria de alterações
Integração com Design System e Runtime
```

---

## Ciclo De Vida De Aplicação

```text
Registro (novo código)
  ↓
Configuração (tema, permissões, módulos)
  ↓
Ativação por tenant
  ↓
Uso (via Portal, via API, via mobile)
  ↓
Atualização (nova versão)
  ↓
Desativação (fim de vida)
  ↓
Arquivo (somente leitura)
```

---

## Proibições

São proibidos:

```text
Aplicação ativa sem entrada no Registry
Aplicação carregada por módulo avulso
Rota criada sem correspondência no Registry
Permissão de aplicação hardcoded
Tema definido dentro da aplicação
Módulo listado mas não implementado
Versão de aplicação sem correspondência em código
Alteração manual do Registry em produção
Registry diferente entre backend e frontend
Aplicação acessando Registry de outro tenant
```

---

## Lei Do Registry

```text
Registry é a porta de entrada de toda aplicação.
Sem Registry, não existe aplicação.
```

---

## Responsabilidades

Time De Plataforma É Responsável Por:

```text
Manter catálogo de aplicações
Aprovar novas aplicações
Gerenciar ativação por tenant
Garantir consistência backend-frontend
Controlar versionamento
Documentar metadados
```

Time De Aplicação É Responsável Por:

```text
Registrar aplicação antes do desenvolvimento
Declarar permissões e módulos corretamente
Seguir metadatos do Registry
Atualizar versão quando houver mudança
NÃO criar rotas ou módulos não registrados
NÃO assumir defaults não documentados no Registry
