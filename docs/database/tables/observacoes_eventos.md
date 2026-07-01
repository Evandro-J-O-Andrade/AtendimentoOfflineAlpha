# observacoes_eventos

Objetivo: Registrar observações e comunicações como eventos no sistema para rastreabilidade.
Descrição: Tabela que armazena observações e comunicações realizadas no decorrer do atendimento, classificadas por entidade, contexto e tipo. Cada observação é armazenada como evento para rastrear histórico.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da observação |
| `entidade` | varchar(50) | NOT NULL | - | Entidade alvo da observação (FILA_SENHA, FFA, PRESCRICAO, AGENDAMENTO) |
| `id_entidade` | bigint unsigned | NOT NULL | - | Identificador da entidade alvo (ex: ID do FFA) |
| `contexto` | varchar(50) | NULL | NULL | Contexto da observação (MEDICO, ENFERMAGEM, TECNICA, ADMIN) |
| `tipo` | varchar(50) | NULL | NULL | Tipo da observação (OBSERVACAO, ALERTA, EVASAO, ORIENTACAO) |
| `texto` | text | NOT NULL | - | Texto da observação/comunicação |
| `id_usuario` | bigint | NOT NULL | - | Usuário que criou a observação |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp da observação |

## Chaves
- Primária: `id`
- Únicas: -
- Estrangeiras: 
  - `fk_observacoes_eventos_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula à entidade
  - `observacoes_eventos_ibfk_1` (`id_usuario`) → `usuario` (`id_usuario`) - Vincula ao usuário

## Índices
- `id_usuario` (KEY) - Índice em `id_usuario`
- `idx_entidade` (KEY) - Índice composto em `entidade` e `id_entidade`
- `fk_observacoes_eventos_entidade` (KEY) - Índice em `id_entidade`

## Constraints
- `fk_observacoes_eventos_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`
- `observacoes_eventos_ibfk_1` FOREIGN KEY - Relaciona `id_usuario` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `saas_entidade` - Muitas observações pertencem a uma entidade
- N:1 com `usuario` - Muitas observações podem ter sido feitas pelo mesmo usuário

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `saas_entidade`, `usuario`

## Fluxo de utilização dentro do sistema
1. Observações são criadas como eventos durante atendimento
2. Entidade indica o objeto da observação (FFA, PRESCRICAO, etc.)
3. Contexto classifica o tipo de profissional que criou
4. Tipo permite categorização (ALERTA, ORIENTACAO, EVASAO)
5. Usado para comunicação entre profissionais (ex: orientações de medico)
6. Alertas são exibidos para equipes de enfermagem
7. Permite rastrear evasão de pacientes
8. Usado para histórico de observações no prontuário
9. Integração com sistema de notificações push
10. Base para inteligência artificial de análise de texto