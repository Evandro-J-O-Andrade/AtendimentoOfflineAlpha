# fluxo_transicao_matriz

Objetivo: Armazenar a matriz de transições de fluxo por domínio.

Descrição: Tabela que define as transições de fluxo padronizadas por domínio (como ASSISTENCIAL), contendo as ações previstas, estados de origem e destino, perfis e parâmetros de execução. Diferente de fluxo_transicao, esta é uma matriz canônica de transições.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fluxo_transicao | bigint | NOT NULL | - | Identificador único da transição na matriz, chave primária auto incrementada |
| dominio_fluxo | varchar(40) | NOT NULL | - | Domínio do fluxo (ex: ASSISTENCIAL) |
| acao | varchar(100) | NOT NULL | - | Ação que dispara a transição (ex: ABRIR_ATENDIMENTO) |
| estado_origem | varchar(40) | NOT NULL | - | Estado de origem da transição |
| estado_destino | varchar(40) | NOT NULL | - | Estado de destino da transição |
| id_perfil | bigint | DEFAULT NULL | - | Referência ao perfil de usuário necessário para a transição |
| tipo_local | varchar(40) | DEFAULT NULL | - | Tipo de local onde a transição pode ocorrer |
| exige_painel | tinyint | DEFAULT | '0' | Indicador se a transição exige painel de atendimento (0=não, 1=sim) |
| exige_sessao_ativa | tinyint | DEFAULT | '1' | Indicador se exige sessão ativa (0=não, 1=sim) |
| prioridade | int | DEFAULT | '0' | Prioridade da transição para ordenação |
| ativo | tinyint | DEFAULT | '1' | Indicador se a transição está ativa |
| criado_em | datetime(6) | NOT NULL DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_fluxo_transicao
- Únicas: -
- Estrangeiras: -

## Índices
- idx_fluxo (dominio_fluxo, estado_origem, estado_destino)
- idx_acao (acao)
- idx_ativo (ativo)

## Constraints
- -

## Relacionamentos e Cardinalidade
- fluxo_transicao_matriz.id_perfil → perfil (id_perfil): N:1 (várias transições podem referenciar o mesmo perfil)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: perfil

## Fluxo de utilização dentro do sistema
1. Matriz define transições padrão para cada domínio de fluxo
2. acao representa a operação que pode ser executada (ABRIR_ATENDIMENTO)
3. estado_origem/estado_destino definem o flip-flop de estados
4. id_perfil restringe quem pode executar a transição
5. exige_painel indica se a transição requer painel ativo
6. exige_sessao_ativa força verificação de sessão válida