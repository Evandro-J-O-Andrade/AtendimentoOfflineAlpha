# local_dispositivo

Objetivo: Associar dispositivos físicos ou lógicos aos locais do hospital.
Descrição: Tabela que mapeia dispositivos (como totens, impressoras, leitores de RFID) aos locais onde estão instalados. Permite controle de ativação e gerenciamento de infraestrutura.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local_dispositivo` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da associação local-dispositivo |
| `id_local` | bigint | NOT NULL | - | Referência ao local onde o dispositivo está |
| `id_dispositivo` | bigint | NOT NULL | - | Identificador do dispositivo |
| `ativo` | tinyint | NULL | '1' | Indica se a associação está ativa (1) ou inativa (0) |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local_dispositivo`
- Únicas: -
- Estrangeiras: 
  - `local_dispositivo_ibfk_1` (`id_local`) → `local` (`id_local`) - Vincula ao local

## Índices
- `id_local` (KEY) - Índice em `id_local`

## Constraints
- `local_dispositivo_ibfk_1` FOREIGN KEY - Relaciona `id_local` com `local`.`id_local`

## Relacionamentos e Cardinalidade
- N:1 com `local` - Muitos dispositivos podem estar associados a um local
- 1:1 com `dispositivo` - Cada dispositivo pode estar em um local

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `local`, `dispositivo`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Dispositivos são associados a locais durante configuração
2. Totens de senha são associados a salas de triagem
3. Impressoras são associadas a laboratórios ou farmácias
4. O campo `ativo` permite desativar dispositivos sem remover associação
5. Usado para descoberta automática de dispositivos no ambiente
6. Base para configuração de painéis de senhas por local
7. Permite verificar qual dispositivo está em qual local para manutenção