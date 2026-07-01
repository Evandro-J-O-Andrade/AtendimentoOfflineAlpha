# local_turno

Objetivo: Definir horários de funcionamento (turnos) de cada local do hospital.
Descrição: Tabela que configura os turnos de funcionamento de cada local, permitindo o controle de disponibilidade por período do dia.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local_turno` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do turno do local |
| `id_local` | bigint | NOT NULL | - | Referência ao local |
| `turno` | varchar(40) | NULL | NULL | Nome do turno (ex: "MANHA", "TARDE", "NOITE") |
| `inicio` | time | NULL | NULL | Horário de início do turno (formato 24h) |
| `fim` | time | NULL | NULL | Horário de fim do turno (formato 24h) |
| `ativo` | tinyint | NULL | '1' | Indica se o turno está ativo (1) ou inativo (0) |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local_turno`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `local` - Muitos turnos podem pertencer a um local
- N:1 com `saas_entidade` - Muitos turnos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `local`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Turnos são configurados para cada local durante setup
2. O sistema verifica turno ativo para validar atendimentos
3. Local indisponível fora do turno não aceita senhas
4. Usado para cálculo de capacidade por turno
5. Integração com sistema de agendamento para verificar disponibilidade
6. Usado para relatórios de produtividade por turno
7. Permite diferentes horários para diferentes locais (ex: laboratório 24h)