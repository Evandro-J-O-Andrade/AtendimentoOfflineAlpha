# manutencao_execucao

Objetivo: Registrar a execução técnica de chamados de manutenção de equipamentos e infraestrutura.
Descrição: Tabela que documenta a execução dos serviços de manutenção, contendo descrição do serviço, datas de início/fim e status da execução.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_execucao` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da execução |
| `id_chamado` | bigint | NOT NULL | - | Referência ao chamado de manutenção |
| `tecnico` | bigint | NOT NULL | - | Usuário técnico responsável pela execução |
| `descricao_servico` | text | NULL | NULL | Descrição do serviço realizado |
| `inicio_em` | datetime | NULL | NULL | Timestamp de início da execução |
| `fim_em` | datetime | NULL | NULL | Timestamp de conclusão da execução |
| `status` | enum('INICIADO','PAUSADO','FINALIZADO') | NULL | 'INICIADO' | Status da execução do serviço |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_execucao`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `chamado_manutencao` - Muitas execuções podem pertencer a um chamado
- N:1 com `usuario` (tecnico) - Muitas execuções podem ter sido feitas pelo mesmo técnico
- N:1 com `saas_entidade` - Muitas execuções pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `chamado_manutencao`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Chamado de manutenção é criado para equipamento com defeito
2. Técnico inicia execução definindo `status='INICIADO'`
3. O serviço pode ser pausado (`status='PAUSADO'`) se necessário
4. Ao concluir, `fim_em` é definido e `status='FINALIZADO'`
5. A `descricao_servico` documenta o que foi feito
6. Usado para SLA de manutenção
7. Base para relatórios de tempo médio de resolução
8. Usado para controle de qualidade de serviços de manutenção