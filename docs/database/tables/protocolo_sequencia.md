# protocolo_sequencia

Objetivo: Gerenciar sequências numéricas para geração de protocolos de documentos, garantindo numeração única e sequencial.

Descrição: Tabela que mantém o controle de sequências numéricas para geração de números de protocolo automáticos, permitindo que cada tipo de documento tenha sua sequência independente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| chave | varchar(80) | NOT NULL | - | Chave identificadora do tipo de sequência (ex: SENHA, GUIA) |
| ultimo_numero | int | NOT NULL | '0' | Último número utilizado na sequência para geração do próximo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro da sequência |
| atualizado_em | datetime | - | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização da sequência |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde a sequência é utilizada |

## Chaves
- Primária: chave
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (chave)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com tabelas que utilizem protocolos numerados

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Atualizado automaticamente quando um novo protocolo é emitido
- Garante numeração sequencial única para cada tipo de documento
- Vinculado a entidade para separação de sequências por organização
- Usado pelo módulo de emissão de documentos oficiais