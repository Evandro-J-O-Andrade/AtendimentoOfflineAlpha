# leito

Objetivo: Gerenciar leitos hospitalares disponíveis para internações, com controle de status e capacidade.
Descrição: Tabela que representa os leitos físicos do hospital, permitindo o controle de disponibilidade, ocupação e status de cada leito. Cada leito pertence a um setor e possui identificação única.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_leito` | int | NOT NULL | AUTO_INCREMENT | Identificador único numérico do leito |
| `id_setor` | int | NOT NULL | - | Referência ao setor onde o leito está localizado |
| `identificacao` | varchar(50) | NOT NULL | - | Identificação do leito (ex: LE-001, LE-002) |
| `status` | enum('DISPONIVEL','OCUPADO','RESERVADO','LIMPEZA','MANUTENCAO','INTERDITADO') | NULL | 'DISPONIVEL' | Status atual do leito |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_leito`
- Únicas: `uk_setor_leito` (`id_setor`,`identificacao`) - Garante identificação única por setor
- Estrangeiras: 
  - `leito_ibfk_1` (`id_setor`) → `setor` (`id_setor`) - Relaciona leito ao setor

## Índices
- `idx_leito_setor_status` (KEY) - Índice composto em `id_setor` e `status` para busca por disponibilidade

## Constraints
- `leito_ibfk_1` FOREIGN KEY - Relaciona `id_setor` com `setor`.`id_setor`

## Relacionamentos e Cardinalidade
- N:1 com `setor` - Muitos leitos pertencem a um setor
- N:1 com `saas_entidade` - Muitos leitos pertencem a uma entidade
- 1:1 com `internacao` - Um leito pode ter uma internação ativa (via FK em internacao)

## Dependências
- Esta tabela é referenciada por: `internacao`
- Esta tabela depende de: `setor`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Leito é cadastrado com status DISPONIVEL
2. Quando paciente é internado, status muda para OCUPADO
3. RESERVADO indica leito reservado para paciente específico
4. LIMPEZA após alta para preparação para novo paciente
5. MANUTENCAO indica leito indisponível por manutenção
6. INTERDITADO indica leito permanentemente indisponível
7. Sistema de alocação verifica leitos disponíveis para internações
8. Usado para relatórios de ocupação e gestão de capacidade