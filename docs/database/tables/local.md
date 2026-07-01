# local

Objetivo: Representar locais físicos ou lógicos onde os atendimentos e serviços são realizados no hospital.
Descrição: Tabela que cataloga todos os locais do sistema - desde alas do hospital até salas de triagem, consultórios, enfermarias, laboratórios e farmácias. Permite o gerenciamento de capacidade, dispositivos associados e filas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do local |
| `id_unidade` | bigint unsigned | NOT NULL | - | Referência à unidade de saúde onde o local está |
| `id_tipo_local` | bigint | NOT NULL | - | Referência ao tipo de local (ex: HOSPITAL, TRIAGEM, CONSULTORIO, ENFERMARIA) |
| `codigo` | varchar(40) | NULL | NULL | Código único do local para identificação |
| `nome` | varchar(120) | NOT NULL | - | Nome descritivo do local (ex: "Enfermaria A", "Laboratório Central") |
| `descricao` | text | NULL | NULL | Descrição detalhada do local |
| `andar` | varchar(20) | NULL | NULL | Andar onde o local se encontra |
| `bloco` | varchar(20) | NULL | NULL | Bloco/ala onde o local está localizado |
| `ativo` | tinyint | NULL | '1' | Indica se o local está ativo (1) ou inativo (0) |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação com precisão |
| `atualizado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) | Timestamp da última atualização |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local`
- Únicas: -
- Estrangeiras: 
  - `fk_local_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula local à entidade proprietária
  - `fk_local_tipo` (`id_tipo_local`) → `tipo_local` (`id_tipo_local`) - Vincula ao tipo de local
  - `fk_local_unidade` (`id_unidade`) → `unidade` (`id_unidade`) - Vincula local à unidade

## Índices
- `idx_local_unidade` (KEY) - Índice em `id_unidade`
- `idx_local_tipo` (KEY) - Índice em `id_tipo_local`
- `idx_local_entidade` (KEY) - Índice em `id_entidade`

## Constraints
- `fk_local_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`
- `fk_local_tipo` FOREIGN KEY - Relaciona `id_tipo_local` com `tipo_local`.`id_tipo_local`
- `fk_local_unidade` FOREIGN KEY - Relaciona `id_unidade` com `unidade`.`id_unidade`

## Relacionamentos e Cardinalidade
- N:1 com `unidade` - Muitos locais pertencem a uma unidade
- N:1 com `tipo_local` - Muitos locais têm o mesmo tipo
- N:1 com `saas_entidade` - Muitos locais pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: `local_capacidade`, `local_dispositivo`, `local_fila`, `local_runtime`, `local_turno`
- Esta tabela depende de: `unidade`, `tipo_local`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Locais são cadastrados classificando por tipo (HOSPITAL, ENFERMARIA, LABORATORIO, etc.)
2. Cada local pode ter capacidade máxima (via local_capacidade)
3. Locais podem ter dispositivos associados (via local_dispositivo)
4. Filas de senha podem estar associadas a um local (via local_fila)
5. Configurações de runtime são específicas por local (via local_runtime)
6. Horários de funcionamento variam por local (via local_turno)
7. Usado para roteamento de pacientes e alocação de recursos
8. Base para relatórios de produtividade por local