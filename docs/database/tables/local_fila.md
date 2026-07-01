# local_fila

Objetivo: Representar filas de atendimento específicas de cada local do hospital.
Descrição: Tabela que configura filas de atendimento por local, permitindo gerenciamento de senhas e priorização de pacientes em diferentes ambientes.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local_fila` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da fila local |
| `id_local` | bigint | NOT NULL | - | Referência ao local onde a fila opera |
| `codigo_fila` | varchar(40) | NULL | NULL | Código único da fila (ex: "TRIAGEM", "LABORATORIO") |
| `nome_fila` | varchar(120) | NULL | NULL | Nome descritivo da fila |
| `prioridade` | int | NULL | '0' | Nível de prioridade da fila (valores maiores = maior prioridade) |
| `ativo` | tinyint | NULL | '1' | Indica se a fila está ativa (1) ou inativa (0) |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local_fila`
- Únicas: -
- Estrangeiras: 
  - `fk_fila_local` (`id_local`) → `local` (`id_local`) - Vincula a fila ao local

## Índices
- `idx_fila_local` (KEY) - Índice em `id_local`

## Constraints
- `fk_fila_local` FOREIGN KEY - Relaciona `id_local` com `local`.`id_local`

## Relacionamentos e Cardinalidade
- N:1 com `local` - Muitas filas podem pertencer a um local
- N:1 com `saas_entidade` - Muitas filas pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `local`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Cada local pode ter uma ou mais filas configuradas
2. Pacientes são direcionados às filas do local apropriado
3. Prioridade influencia ordem de chamada no painel
4. Fila ativa permite emissão de senhas
5. Usado para cálculo de métricas de tempo de espera
6. Base para RAIM (Risk-Adjusted Inventory Management) na triagem
7. Integração com sistema de TTS (text-to-speech) para chamadas