# FRONT-009 — AVA Experience

## Status

Documento Canônico de Frontend.
Define a experiência da plataforma AVA (Ambiente Virtual de Aprendizagem) corporativo.

---

## Objetivo

Transformar treinamentos, cursos e certificações em experiência integrada ao ecossistema.

---

## Princípio Fundamental

```text
AVA não é sistema separado.
AVA é App registrada.
Aprendizagem é experiência fluida dentro do Portal.
```

---

## Fluxo Canônico

```
Portal (FRONT-003)
  ↓
App Registry → AVA App (FRONT-009)
  ↓
Catálogo de Cursos
  ↓
Matrícula (automática por regra ou manual)
  ↓
Trilha de Aprendizagem
  ↓
Conteúdo (video, texto, avaliação)
  ↓
Certificado
  ↓
Gamificação (pontos, badges, ranking)
  ↓
Integração com:
  - Social (compartilhar conquista)
  - Notificações (lembretes)
  - RH (desenvolvimento)
  - IAM (perfil atualizado)
```

---

## Componentes

### CatalogoCursos

```text
Busca e filtros:
  - Por área (RH, Compliance, Segurança, Técnico)
  - Por tipo (curso, treinamento, webinar)
  - Por nível (básico, intermediário, avançado)
  - Por status (disponível, em andamento, concluído)
Cards de curso:
  - Título
  - Descrição
  - Carga horária
  - Instrutor
  - Avaliação média
  - Progresso pessoal
Badge obrigatório (se obrigatório)
Badge em andamento
```

### VisualizadorConteudo

```text
Player de vídeo (YouTube/Vimeo interno ou upload)
Leitor de PDF/Office
Texto enriquecido (Imagens, tabelas)
Navegação por módulos
Barra de progresso
Marcador de última posição (auto-resume)
Notas pessoais (offline-first)
Modo tela cheia
```

### Avaliacao

```text
Quiz por módulo
Múltipla escolha, verdadeiro/falso, dissertativa
Correção automática ou manual
Feedback imediato (aprovado/reprovado)
Limite de tentativas
Tempo de prova
Grade de notas
```

### Certificado

```text
Geração automática após conclusão
Template corporativo (white-label)
Validação online (código único)
Download em PDF
Envio por email
Compartilhamento no Social/Perfil
Registro na ficha do colaborador (RH)
```

### Gamificacao

```text
Pontos por curso concluído
Badges por marcos (primeiro curso, 10 cursos, área técnica)
Níveis (Bronze, Prata, Ouro, Platina)
Ranking por área/departamento
Barra de progresso geral
Metas de aprendizado mensal/semestral
```

### Trilhas

```text
Trilha obrigatória (onboarding, compliance)
Trilha recomendada (por perfil)
Trilha livre (autonomia)
Trilha personalizada (desenvolvimento individual)
Progresso visual por trilha
Desbloqueio sequencial (se configurado)
```

---

## Regras

### Matrícula

```text
Automática: curso associado ao perfil/onboarding
Manual: usuário solicita, gestor aprova (workflow)
Pública: qualquer usuário pode se inscrever
Inscrição em lista de espera (se limite)
Cancelamento com regra de prazo
```

### Progresso

```text
Persistido no banco (MD-101).
Assincrônico: salva automaticamente por módulo.
Offline-first: assiste offline, sincroniza depois (via pacote runtime).
Reinício permitido apenas a partir de módulos desbloqueados.
```

### Certificado

```text
Válido apenas se:
  - 100% dos módulos concluídos
  - Todas as avaliações aprovadas
  - Assinatura digital registrada
Inválido se:
  - Reprova em avaliação
  - Tempo de expiração atingido (se houver)
Código único consultável em portal de validação.
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-034 — Identity Access Management | Perfil, permissões |
| MD-076 — Loyalty & Rewards | Pontos e badges de gamificação |
| MD-089 — Workflow Fabric | Aprovações, matrículas automáticas |
| MD-088 — Global Notification Center | Lembretes, conclusões, certificados |
| MD-106 — Multi-Domain Architecture | Isolamento por tenant |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Acesso via Portal |
| packages/runtime | Offline-first |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Catálogo, player, avaliação, certificado, gamificação |
| Backend | APIs de cursos, matrícula, progresso, certificado |
| Dispatcher | Roteamento para SPs de AVA |
| SP | Regras de matrícula, aprovação, emissão de certificado |
| Event Store | Registrar matrícula, progresso, conclusão, certificado emitido |

---

## Métricas

```text
Cursos ativos
Matrículas por curso
Taxa de conclusão
Tempo médio de conclusão
Avaliações aprovadas vs. reprovadas
Certificados emitidos
Pontos de gamificação distribuídos
Badges conquistadas
Engagement diário/semanal/mensal
Satisfação com conteúdo (CSAT)
```

---

## Lei

```text
AVA é App.
Treinamento é direito.
Certificado é prova.
Aprendizagem é contínua.
Gamificação é incentivo, não obrigação.
```

---

## Próximo

```text
FRONT-009 completo
  ↓
FRONT-010 — Mobile PWA Experience
```
