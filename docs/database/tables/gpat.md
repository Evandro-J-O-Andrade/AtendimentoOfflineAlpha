# gpat

Objetivo: Gerenciar o GPAT (Grupo de Prescrição e Administração de Terapia).

Descrição: Tabela que representa um grupo de prescrição terapêutica, vinculando-se a um FFA e código universal. Controla o ciclo de vida de um protocolo terapêutico com código GPAT e barcode.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gpat | bigint | NOT NULL | - | Identificador único do GPAT, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio FFA ao qual o GPAT pertence |
| id_codigo_universal | bigint | NOT NULL | - | Referência ao código universal associado ao GPAT |
| codigo_gpat | varchar(50) | NOT NULL | - | Código identificador do GPAT |
| barcode_gpat | varchar(60) | NOT NULL | - | Código de barras para identificação do GPAT |
| origem | enum('AUTO','MANUAL') | NOT NULL | 'AUTO' | Origem da criação: automática ou manual |
| observacao | varchar(255) | DEFAULT NULL | - | Observações sobre o GPAT |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do GPAT |
| atualizado_em | datetime | DEFAULT NULL | - | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gpat
- Únicas: uk_gpat_ffa (id_ffa); uk_gpat_codigo (codigo_gpat); uk_gpat_codigo_universal (id_codigo_universal) |
- Estrangeiras: -

## Índices
- -

## Constraints
- UNIQUE KEY uk_gpat_ffa (id_ffa)
- UNIQUE KEY uk_gpat_codigo (codigo_gpat)
- UNIQUE KEY uk_gpat_codigo_universal (id_codigo_universal)

## Relacionamentos e Cardinalidade
- gpat.id_ffa → ffa (id_ffa): 1:1 (cada FFA pode ter um GPAT associado)
- gpat.id_codigo_universal → codigo_universal (id_codigo_universal): N:1 (vários GPATs podem referenciar o mesmo código universal)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: ffa, codigo_universal

## Fluxo de utilização dentro do sistema
1. GPAT é criado automaticamente ou manualmente para um FFA
2. codigo_gpat identifica unicamente o protocolo
3. barcode_gpat permite leitura via scanner
4. uk_gpat_ffa garante que cada FFA tenha apenas um GPAT
5. Observações complementam informações sobre o protocolo