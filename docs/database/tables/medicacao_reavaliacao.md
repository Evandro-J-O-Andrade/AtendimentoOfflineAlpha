# medicacao_reavaliacao

Objetivo: Controlar reavaliações de medicação agendadas para pacientes em atendimento.
Descrição: Tabela que agenda e controla reavaliações de medicações prescritas, permitindo o monitoramento de adequação terapêutica e interrupção segura de medicamentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_reavaliacao` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da reavaliação |
| `id_fila_medicacao` | bigint | NOT NULL | - | Referência à fila de medicação |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `previsto_em` | datetime | NOT NULL | - | Timestamp previsto para reavaliação |
| `executado_em` | datetime | NULL | NULL | Timestamp de execução da reavaliação |
| `status` | enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO') | NOT NULL | 'PENDENTE' | Status da reavaliação |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que agendou a reavaliação |
| `id_local_operacional` | bigint | NULL | NULL | Local onde a reavaliação será realizada |
| `id_usuario_criador` | bigint | NOT NULL | - | Usuário que criou o agendamento |
| `id_usuario_executor` | bigint | NULL | NULL | Usuário que executou a reavaliação |
| `observacao` | text | NULL | NULL | Observações sobre a reavaliação |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_reavaliacao`
- Únicas: -
- Estrangeiras: 
  - `fk_reav_fila` (`id_fila_medicacao`) → `fila_operacional` (`id_fila`) - Vincula à fila de medicação
  - `fk_reav_local` (`id_local_operacional`) → `local_operacional` (`id_local_operacional`) - Vincula ao local
  - `fk_reav_usr_criador` (`id_usuario_criador`) → `usuario` (`id_usuario`) - Vincula ao criador
  - `fk_reav_usr_exec` (`id_usuario_executor`) → `usuario` (`id_usuario`) - Vincula ao executor

## Índices
- `idx_reav_fila` (KEY) - Índice composto em `id_fila_medicacao`, `status` e `previsto_em`
- `idx_reav_ffa` (KEY) - Índice composto em `id_ffa`, `status` e `previsto_em`
- `fk_reav_sessao` (KEY) - Índice em `id_sessao_usuario`
- `fk_reav_local` (KEY) - Índice em `id_local_operacional`
- `fk_reav_usr_criador` (KEY) - Índice em `id_usuario_criador`
- `fk_reav_usr_exec` (KEY) - Índice em `id_usuario_executor`

## Constraints
- `fk_reav_fila` FOREIGN KEY - Relaciona `id_fila_medicacao` com `fila_operacional`.`id_fila`
- `fk_reav_local` FOREIGN KEY - Relaciona `id_local_operacional` com `local_operacional`.`id_local_operacional`
- `fk_reav_usr_criador` FOREIGN KEY - Relaciona `id_usuario_criador` com `usuario`.`id_usuario`
- `fk_reav_usr_exec` FOREIGN KEY - Relaciona `id_usuario_executor` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `fila_operacional` - Muitas reavaliações podem pertencer a uma fila
- N:1 com `ffa` - Muitas reavaliações podem estar associadas a um FFA
- N:1 com `usuario` (criador) - Muitas reavaliações podem ter sido criadas pelo mesmo usuário
- N:1 com `usuario` (executor) - Muitas reavaliações podem ter sido executadas pelo mesmo usuário
- N:1 com `local_operacional` - Muitas reavaliações podem ter sido feitas no mesmo local

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `fila_operacional`, `ffa`, `usuario`, `local_operacional`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Reavaliações são agendadas com status PENDENTE
2. O sistema verifica reavaliações pendentes para exibir ao enfermeiro
3. Ao iniciar, status muda para EM_EXECUCAO
4. Após concluir, status muda para CONCLUIDO e `executado_em` é preenchido
5. Reavaliações podem ser CANCELADO se desnecessárias
6. Usado para garantir reavaliação em medicamentos críticos
7. Integração com ordem_assistencial para agendamento
8. Usado para alertas de medicamentos com necessidade de reavaliação