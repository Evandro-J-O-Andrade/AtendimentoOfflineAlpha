# FRONT-052 — Employee 360 Experience

## Status

Documento Canônico de Frontend.
Define a experiência de visão 360° do colaborador.

---

## Objetivo

Criar visão completa e unificada do colaborador dentro da plataforma.

---

## Princípio Fundamental

```text
Colaborador não é apenas funcionário.
Colaborador é pessoa, profissional, aluno e membro da comunidade.
Toda dimensão importa.
```

---

## Componentes

### PerfilCompleto

```text
Dados pessoais (LGPD compliant)
Dados profissionais (cargo, departamento, unidade)
Contatos (email corporativo, ramal, local)
Foto, bio, competências
Tags de especialidade
Status (ativo, férias, licença, desligado)
```

### Carreira

```text
Histórico de funções
Promoções
Mudanças de unidade/local
Avaliações de desempenho
PDR (Plano de Desenvolvimento Individual)
Metas e OKRs
Reconhecimentos (badges, Kudos)
```

### Aprendizagem

```text
Cursos em andamento (AVA)
Certificados obtidos
Trilhas concluídas
Treinamentos obrigatórios (compliance)
Progresso de desenvolvimento
Habilidades e gaps
```

### Presenca

```text
Escalas (enfermagem, psychiatry)
Ponto (se aplicável)
Horas extras
Férias e abonos
Licenças (médica, maternidade, etc.)
```

### Engajamento

```text
Feed social (posts, comentários)
Comunidades participa
Eventos confirmados
Reconhecimentos recebidos
Enquetes respondidas
Check-ins
```

---

## Regras

### Privacidade

```text
Dados sensíveis mascarados por perfil.
Histórico de ponto visível apenas para RH/gestor.
Dados de saúde (férias médicas) protegidos.
Colaborador vê seus próprios dados completos.
Gestor vê dados da sua equipe.
RH vê dados globais (anonimizados quando possível).
```

### Transparência

```text
Colaborador pode ver:
  - Seus próprios dados completos
  - Suas avaliações
  - Seu progresso de carreira
  - Seus treinamentos
  - Suas férias e benefícios
Colaborador pode solicitar correção de dados.
Colaborador pode exportar seus dados (LGPD).
```

### Atualização

```text
Dados atualizados via eventos.
Alteração de cargo → evento → atualização automática.
Conclusão de curso → evento → atualização de certificado.
Avaliação → evento → atualização de perfil profissional.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-029 — Digital Workplace | Workplace |
| MD-028 — Enterprise Social Network | Social |
| MD-009 — AVA | Aprendizagem |
| MD-076 — Loyalty & Rewards | Gamificação |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-006 — Social Experience | Feed |
| FRONT-007 — Intranet Experience | Comunicados |
| FRONT-009 — AVA Experience | Cursos |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Profile, Carreira, Aprendizagem, Presença, Engajamento |
| Backend | APIs de consulta unificada |
| Dispatcher | Roteamento para SPs de RH, AVA, Social |
| SP | Regras de acesso, cálculo de métricas |
| Event Store | Registrar visualizações, ações |

---

## Métricas

```text
Perfis completos (%)
Cursos em andamento por colaborador
Taxa de conclusão de treinamentos obrigatórios
Engajamento no Feed (média)
Badges conquistadas por colaborador
Taxa de atualização de dados pessoais
Satisfação com plataforma (eNPS)
```

---

## Lei

```text
Colaborador é pessoa, profissional, aluno e membro.
Toda dimensão importa.
Employee 360 é a visão humana da plataforma.
```

---

## Próximo

```text
FRONT-052 completo
  ↓
FRONT-053 — Patient 360 Experience
```
