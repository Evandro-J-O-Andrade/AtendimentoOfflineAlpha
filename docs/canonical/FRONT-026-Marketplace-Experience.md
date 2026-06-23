# FRONT-026 — Marketplace Experience

## Status

Documento Canônico de Frontend.
Define a experiência visual do Marketplace.

---

## Objetivo

Fornecer experiência única para navegação, descoberta e instalação de recursos.

---

## Princípio Fundamental

```text
Marketplace não é loja.
Marketplace é ecossistema.
Marketplace é descoberta.
Marketplace é instalação.
Marketplace é governança.
```

---

## Componentes

### CatalogBrowser

```text
Filtro por categoria (apps, plugins, widgets, prompts, agentes, workflows)
Busca full-text
Ordenação por popularidade, data, avaliação
Visualização em lista ou grid
Preview ao hover
```

### ItemCard

```text
Ícone/Imagem do recurso
Nome e descrição curta
Categoria e tags
Versão atual
Avaliação (estrelas)
Instalar button
Mais informações
```

### ResourceDetail

```text
Visualização detalhada
Screenshots/GIFs
Descrição completa
Changelog
Permissões necessárias
Licença do recurso
Reviews e avaliações
```

### OneClickInstaller

```text
Instalação com um clique
Progresso visual da instalação
Permissões em tempo real
Validação de compatibilidade
Rollback automático em falha
Notificação de conclusão
```

### LicenseManager

```text
Visualização de licenças
Validade da licença
Renovação automática
Upgrade de licença
Revogação de acesso
Limites de uso
```

### VersionManager

```text
Histórico de versões
Changelog por versão
Atualização automática (opcional)
Rollback de versão
Release notes
```

---

## Catálogo

| Tipo | Descrição |
|------|-----------|
| Apps | Aplicações completas da plataforma |
| Plugins | Extensões de funcionalidade |
| Widgets | Componentes para dashboards |
| Prompts | Templates de prompts canônicos |
| Agentes | Agentes de IA pré-treinados |
| Workflows | Templates de workflows |

---

## Regras

### Obrigatório

```text
Instalação mostra progresso
Permissões são revisadas antes da instalação
Licença é validada antes da ativação
Versão é registrada após instalação
Rollback é possível por 24h
```

### Proibido

```text
Instalação sem permissão de revisão
Plugin sem changelog
App sem screenshots
Licença sem validade
Upgrade sem rollback
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-060 — Marketplace Platform | Plataforma de marketplace |
| MD-061 — App Registry | Catálogo de apps |
| MD-062 — Plugin Framework | Plugins e extensões |
| MD-063 — Widget Registry | Widgets disponíveis |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-004 — App Registry Navigation | Navegação de apps |
| FRONT-012 — Widget Framework | Widgets instalados |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Catálogo, detalhes, instalação, gerenciamento |
| Backend | APIs de marketplace, instalação, licenciamento |
| Dispatcher | Roteamento para SPs de instalação |
| SP | Validação de compatibilidade, instalação |
| Event Store | Registrar instalação, atualização, uso |

---

## Métricas

```text
Recursos instalados por dia
Taxa de instalação com sucesso
Apps mais instalados
Plugins mais usados
Widgets mais adicionados
Licenças ativas
Renovações automáticas
Rollback requests
Buscas no marketplace
```

---

## Lei

```text
Marketplace é ecossistema.
Marketplace é descoberta.
Marketplace é instalação.
Marketplace é governança.
```

---

## Próximo

```text
FRONT-026 completo
  ↓
FRONT-027 — Integration Hub Experience
```