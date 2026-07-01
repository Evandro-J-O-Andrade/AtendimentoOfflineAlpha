# medico_especialidade

Objetivo: Gerenciar múltiplas especialidades por médico via tabela de associação.
Descrição: Tabela de associação que permite que um médico tenha múltiplas especialidades, implementando um relacionamento N:N entre médico e especialidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_usuario` | bigint | NOT NULL | - | Referência ao médico (usuário) |
| `id_especialidade` | bigint | NOT NULL | - | Referência à especialidade |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_usuario`,`id_especialidade` (chave composta)
- Únicas: -
- Estrangeiras: 
  - `fk_medico_especialidade_assoc` (`id_especialidade`) → `especialidade` (`id_especialidade`) - Vincula à especialidade
  - `fk_medico_especialidade_usuario` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula ao médico

## Índices
- `fk_medico_especialidade_assoc` (KEY) - Índice em `id_especialidade`

## Constraints
- `fk_medico_especialidade_assoc` FOREIGN KEY - Relaciona `id_especialidade` com `especialidade`.`id_especialidade` (ON DELETE RESTRICT ON UPDATE CASCADE)
- `fk_medico_especialidade_usuario` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario` (ON DELETE CASCADE)

## Relacionamentos e Cardinalidade
- N:1 com `usuario` - Muitas associações podem estar relacionadas ao mesmo usuário
- N:1 com `especialidade` - Muitas associações podem estar relacionadas à mesma especialidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `especialidade`, `usuario`

## Fluxo de utilização dentro do sistema
1. Médico pode ter múltiplas especialidades registradas
2. Usado para validação de atendimentos por especialidade
3. Permite médicos multi-especialistas (ex: clínico geral + cardiologia)
4. Integração com sistema de agendamento para definição de especialidade
5. Usado para relatórios de produtividade por especialidade
6. Permite restringir atendimentos a especialidades cadastradas
7. Útil para médicos que passaram por residência em múltiplas áreas
8. Permite gerenciamento de permissões por especialidade