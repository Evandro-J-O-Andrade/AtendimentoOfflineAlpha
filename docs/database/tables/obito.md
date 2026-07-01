# obito

Objetivo: Registrar óbitos ocorridos durante atendimentos para documentação e notificações.
Descrição: Tabela que documenta óbitos registrados no sistema, vinculando ao FFA e ao local onde ocorreu, com evoluções inicial e final.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_obito` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de óbito |
| `id_ffa` | bigint | NOT NULL | - | Referência ao FFA (Fila de Atendimento) do paciente |
| `id_sessao_usuario` | bigint | NOT NULL | - | Sessão do usuário que registrou o óbito |
| `id_local_operacional` | bigint | NULL | NULL | Local onde o óbito ocorreu |
| `data_hora_obito` | datetime | NOT NULL | - | Data e hora do óbito |
| `id_usuario_responsavel` | bigint | NOT NULL | - | Usuário responsável pelo registro |
| `evolucao_inicial` | text | NOT NULL | - | Evolução do caso desde o início |
| `evolucao_final` | text | NOT NULL | - | Evolução final até o óbito |
| `observacao` | text | NULL | NULL | Observações complementares |
| `status` | enum('REGISTRADO','CANCELADO') | NOT NULL | 'REGISTRADO' | Status do registro |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `atualizado_em` | datetime | NULL | NULL | Timestamp da atualização |
| `cancelado_em` | datetime | NULL | NULL | Timestamp do cancelamento |
| `cancelado_por` | bigint | NULL | NULL | Usuário que cancelou o registro |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_obito`
- Únicas: `uk_obito_ffa` (`id_ffa`) - Garante um óbito por FFA
- Estrangeiras: -

## Índices
- `idx_obito_data` (KEY) - Índice em `data_hora_obito`
- `idx_obito_status` (KEY) - Índice em `status`
- `idx_obito_sessao` (KEY) - Índice em `id_sessao_usuario`
- `idx_obito_ffa_status` (KEY) - Índice composto em `id_ffa` e `status`

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- 1:1 com `ffa` - Cada FFA pode ter um registro de óbito único
- N:1 com `usuario` (responsável) - Muitos registros podem ter sido feitos pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitos registros podem estar associados a uma sessão
- N:1 com `local_operacional` - Muitos registros podem ter ocorrido no mesmo local

## Dependências
- Esta tabela é referenciada por: `obito_evento`
- Esta tabela depende de: `ffa`, `usuario`, `sessao_usuario`, `local_operacional`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Óbito é registrado ao final de atendimento crítico
2. Evolução inicial documento desde admissão
3. Evolução final documento causa e desenvolvimento
4. Status REGISTRADO indica óbito confirmado
5. Status CANCELADO permite corrigir registros equivocados
6. Usado para estatísticas de mortalidade
7. Necessário para declaração de óbito e alvará
8. Integração com cartório para protocolo de óbito
9. Usado para análise de causas de mortalidade