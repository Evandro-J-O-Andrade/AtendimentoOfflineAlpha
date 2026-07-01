# local_capacidade

Objetivo: Controlar a capacidade máxima e ocupação atual de cada local do hospital.
Descrição: Tabela que mantém o controle de capacidade de cada local, permitindo o monitoramento de ocupação e gestão de recursos. Usada para relatórios de ocupação e controle de acesso.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local_capacidade` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de capacidade |
| `id_local` | bigint | NOT NULL | - | Referência ao local |
| `capacidade_maxima` | int | NULL | NULL | Número máximo de pacientes/recursos suportados |
| `ocupacao_atual` | int | NULL | '0' | Número atual de pacientes/recursos ocupados |
| `atualizado_em` | datetime(6) | NULL | NULL | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local_capacidade`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `local` - Cada registro está associado a um local
- N:1 com `saas_entidade` - Muitos registros pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `local`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Capacidade é configurada para cada local (leitos, salas, laboratórios)
2. Ocupação atual é incrementada/decrementada conforme uso do local
3. Usado para impedir superlotação de ambientes
4. Base para cálculo de RAIM (Risk-Adjusted Inventory Management)
5. Usado em assistencial_minipal_metric para score de risco
6. Controla entrada de pacientes em salas de emergência
7. Integração com sistema de triagem para priorização