# HIS/PA — Rebuild do Banco (V2)

Arquivo principal:
- `pronto_atendimento_v2_rebuild.sql`

## Objetivo
Reconstruir o banco **sem tabelas legadas**, preservando as regras:
- senha/ticket é entidade primária e auditável
- paciente/FFA somente na complementação da recepção
- chamadas sempre manuais, painéis somente leitura
- `usuario_sistema` como fonte da verdade
- ações com sessão/contexto (`sessao_usuario`)

## Execução (MySQL)
1) Abra o MySQL Workbench ou terminal.
2) Execute o script inteiro:

```sql
SOURCE /caminho/para/pronto_atendimento_v2_rebuild.sql;
```

## Seed (teste rápido)
O script já cria:
- Unidade: ALPHA
- Sistema: PA
- Usuário: admin (senha_hash placeholder: `admin123`)
- Locais: Recepção, Triagem, Médico Clínico, Médico Pediátrico

## Próximos blocos (para fechar 110%)
- Trocar emissão de senha (sequência) para controle por dia + reset automático
- Implementar SPs setoriais (triagem/medicação/RX): chamar/iniciar/finalizar/não atendeu
- Implementar *encaminhar* universal com motivo e trilha de auditoria
- Implementar API PHP (/api) consumindo SPs e views v2
