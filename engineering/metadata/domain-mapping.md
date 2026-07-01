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
- Domínios identificados: 9
- Tabelas mapeadas por domínio:
  - Core: 36
  - IAM: 3
  - HIS: 67
  - Agendamento: 3
  - SAC: 4
  - Regulacao: 1
  - Workforce: 5
  - Integration: 1
  - Unknown: 358
- MDs faltando: 3 (agendamento, SAC, regulação)