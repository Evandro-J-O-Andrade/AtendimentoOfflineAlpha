# fluxo_status

Objetivo: Catalogar os status possíveis do fluxo assistencial.

Descrição: Tabela que armazena os status que compõem o fluxo de atendimento assistencial, classificados por tipo (inicial, operacional, intermediário ou final). Utilizada como referência para navegação entre estados no workflow.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fluxo_status | bigint | NOT NULL | - | Identificador único do status, chave primária auto incrementada |
| codigo | varchar(60) | NOT NULL | - | Código único do status (ex: INICIO, AGUARDANDO_TRIAGEM) |
| descricao | varchar(150) | NOT NULL | - | Descrição detalhada do status |
| tipo | enum('INICIAL','OPERACIONAL','INTERMEDIARIO','FINAL') | NOT NULL | - | Tipo de status: inicial (entrada), operacional (durante), intermediário (transição) ou final (saída) |
| ativo | tinyint(1) | NOT NULL | '1' | Indicador se o status está ativo |
| criado_em | datetime(6) | NOT NULL DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_fluxo_status
- Únicas: uk_fluxo_status_codigo (codigo) - garante código único
- Estrangeiras: -

## Índices
- -

## Constraints
- UNIQUE KEY uk_fluxo_status_codigo (codigo)

## Relacionamentos e Cardinalidade
- fluxo_status é referenciada por fluxo_transicao (id_status_origem, id_status_destino)

## Dependências
- Tabelas que dependem desta: fluxo_transicao
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Status são cadastrados com código único e descrição
2. Tipo classifica a posição no fluxo (INICIAL, OPERACIONAL, INTERMEDIARIO, FINAL)
3. fluxo_transicao referencia dois status: origem e destino
4. Exemplos: INICIO (INICIAL) → AGUARDANDO_TRIAGEM (OPERACIONAL) → EM_TRIAGEM (OPERACIONAL) → ALTA (FINAL/INTERMEDIARIO)