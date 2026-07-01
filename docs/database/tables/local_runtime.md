# local_runtime

Objetivo: Configurar capacidades de runtime específicas de cada local (sala, setor, unidade).
Descrição: Tabela que define quais funcionalidades de runtime estão habilitadas em cada local - como aceitação de senhas, geração de filas, exibição de painel, TTS e tipos de atendimento permitidos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_local_runtime` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da configuração de runtime |
| `id_local` | bigint | NOT NULL | - | Referência ao local |
| `aceita_senha` | tinyint | NULL | '0' | Indica se local aceita emissão de senhas (1) ou não (0) |
| `gera_fila` | tinyint | NULL | '0' | Indica se local gera fila de espera (1) ou não (0) |
| `exibe_painel` | tinyint | NULL | '0' | Indica se local exibe painel de senhas (1) ou não (0) |
| `emite_tts` | tinyint | NULL | '0' | Indica se local emite TTS (text-to-speech) (1) ou não (0) |
| `permite_triagem` | tinyint | NULL | '0' | Indica se local permite triagem (1) ou não (0) |
| `permite_consulta` | tinyint | NULL | '0' | Indica se local permite consulta médica (1) ou não (0) |
| `permite_procedimento` | tinyint | NULL | '0' | Indica se local permite procedimentos (1) ou não (0) |
| `dispositivo_tipo` | varchar(40) | NULL | NULL | Tipo de dispositivo principal do local (ex: TOTEM, WORKSTATION) |
| `criado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de criação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_local_runtime`
- Únicas: -
- Estrangeiras: 
  - `fk_runtime_local` (`id_local`) → `local` (`id_local`) - Vincula configuração ao local

## Índices
- `idx_runtime_local` (KEY) - Índice em `id_local`

## Constraints
- `fk_runtime_local` FOREIGN KEY - Relaciona `id_local` com `local`.`id_local`

## Relacionamentos e Cardinalidade
- 1:1 com `local` - Cada local tem uma configuração de runtime
- N:1 com `saas_entidade` - Muitas configurações pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `local`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Configuração é definida durante setup do local
2. Sistema verifica flags para determinar funcionalidades disponíveis
3. `aceita_senha=1` permite emissão de senhas no local
4. `gera_fila=1` ativa fila de espera no local
5. `exibe_painel=1` mostra painel de chamadas no local
6. `emite_tts=1` ativa announce de senhas via áudio
7. Usado para validação de fluxo de atendimento
8. Permite diferentes perfis de locais (triagem, consulta, laboratório)