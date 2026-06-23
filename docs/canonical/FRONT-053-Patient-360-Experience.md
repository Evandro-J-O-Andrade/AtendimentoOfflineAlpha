# FRONT-053 — Patient 360 Experience

## Status

Documento Canônico de Frontend.
Define a experiência de visão 360° do paciente no domínio assistencial.

---

## Objetivo

Criar visão completa e unificada do paciente, respeitando a regra canônica: senha é a entrada operacional.

---

## Princípio Fundamental

```text
Paciente existe no cadastro mestre.
Operacionalmente, quem entra no fluxo é a Senha.
Mas o histórico é do paciente.
A timeline é do paciente.
A visão é do paciente.
```

---

## Componentes

### PatientProfile

```text
Dados cadastrais (PF/PJ)
Dados complementares (contatos, responsáveis)
Classificação (convenio, particular, SUS)
Tags (alergias, cuidados especiais, risco)
Foto (se consentida)
Status (ativo, inativo, falecido)
```

### TimelineClinica

```text
Linha do tempo clínica completa:
  - Senhas emitidas
  - Atendimentos (todas as unidades)
  - Triagens
  - Prescrições
  - Dispensações (farmácia)
  - Exames (laboratório)
  - Internações
  - Procedimentos
  - Alta
  - Óbito
Filtros por:
  - Unidade
  - Período
  - Tipo de atendimento
  - Profissional
Drill-down para detalhes de cada evento
```

### AlergiasAlertas

```text
Alergias cadastradas (medicamentos, substâncias)
Alertas visuais em:
  - Prescrição (médico)
  - Dispensação (farmácia)
  - Triagem (enfermagem)
Flag de reação adversa registrada
```

### DocumentosClinicos

```text
Prontuário digital
Laudos
Receituários
Atestados
Relatórios de alta
Exames anexados
Compartilhamento seguro (consentimento)
```

### IndicadoresSaude

```text
Histórico de pressão arterial
Glicemia
Peso
Vacinação
Histórico de cirurgias
Doenças crônicas
Alertas de retorno (follow-up)
```

---

## Regras

### Lei Canônica do HIS

```text
Paciente não inicia fluxo.
Senha inicia fluxo.
Mas o histórico é do paciente.
A timeline é do paciente.
A visão é do paciente.
```

### Acesso

```text
Médico: vê timeline clínica completa de seus atendimentos
Enfermeiro: vê timeline de enfermagem
Farmacêutico: vê dispensações do paciente
Financeiro: vê faturamento do paciente
Paciente: vê seus próprios dados (portal do paciente)
Gestor: vê agregado da sua unidade
```

### Consentimento

```text
Dados sensíveis protegidos (LGPD).
Compartilhamento entre unidades requer consentimento.
Paciente pode solicitar export de seus dados.
Log de acesso ao prontuário (quem, quando, porquê).
```

### Integridade

```text
Dados são fonte única do banco.
Eventos imutáveis no Event Store.
Nenhuma alteração direta na timeline.
Correções via registro de evento (versão corrigida).
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-105 — HIS Canonical Flow | Fluxo assistencial canônico |
| MD-003 — Contexto Operacional | Contexto |
| MD-034 — Identity Access Management | Permissões |
| MD-101 — Canonical Data Architecture | Fonte da verdade |
| MD-104 — Event Convergence Architecture | Eventos |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-031 — HIS Operational Experience | Operacional |
| FRONT-032 — Queue & Panel Experience | Filas |
| FRONT-033 — Clinical Workspace Experience | Prontuário |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Profile, Timeline, Alertas, Documentos, Indicadores |
| Backend | APIs de consulta unificada |
| Dispatcher | Roteamento para SPs de saúde |
| SP | Regras de acesso, junção de dados clínicos |
| Event Store | Registrar visualizações, acessos |
| IA | Anomalias em histórico, alertas preditivos |

---

## Métricas

```text
Perfis de pacientes completos (%)
Timelines acessadas por dia
Drill-downs por profissional
Alertas de alergia exibidos
Documentos anexados por atendimento
Tempo para encontrar histórico do paciente
Satisfação com prontuário (CSAT)
Acessos não autorizados bloqueados (segurança)
```

---

## Lei

```text
Paciente não inicia fluxo.
Senha inicia fluxo.
Mas o histórico é do paciente.
A timeline é do paciente.
A visão é do paciente.
Patient 360 é a memória clínica da plataforma.
```

---

## Próximo

```text
FRONT-053 completo
  ↓
FRONT-054 — Organization 360 Experience
```
