# TABLE → DOMAIN → MD MAPPING

## Fluxo Canônico
```
478 tabelas (dump)
   ↓
KILO descobre domínio
   ↓
KILO encontra MD correspondente
   ↓
KILO gera/atualiza documento
```

## Domínios Detectados no Dump

| Domínio | Tabelas | MD Number | Status |
|---------|---------|-----------|--------|
| ASSISTENCIAL | senha, ffa, atendimento, triagem, ... | MD-105 | 🟢 EXISTS |
| FARMACIA | farm_dispensacao, estoque_*, ... | MD-141 | 🟢 EXISTS |
| IAM | usuario, sessao_usuario, perfil | MD-34 | 🟢 EXISTS |
| DISPLAY | painel, tv_rotativo, totem | MD-125 | 🟢 EXISTS |
| FATURAMENTO | faturamento_*, gpat | MD-117 | 🟢 EXISTS |
| AGENDAMENTO | agenda_*, agenda_unidade | MD-XXX | 🟡 MISSING |
| INTERNACAO | internacao_*, leito, ... | MD-117 | 🟢 EXISTS |
| SAC | chamado_*, chamado_evento | MD-XXX | 🟡 MISSING |
| REGULACAO | regulacao_*, regulacao_evento | MD-XXX | 🟡 MISSING |

## Contagem
- Total tabelas: 478
- Domínios identificados: 17
- Tabelas mapeadas por domínio:
  - Core: 54
  - HIS: 85
  - Runtime: 70
  - IAM/Auth: 12
  - Agendamento: 3
  - SAC: 4
  - Regulacao: 1 + 4 (SUS)
  - Workforce: 10 + 10
  - Displays: 16
  - Diagnostics: 9
  - Unknown: 121
- FKs extraídas: 563
- Relationships mapeadas: 28