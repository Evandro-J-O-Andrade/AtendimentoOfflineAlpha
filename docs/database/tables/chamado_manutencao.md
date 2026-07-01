# chamado_manutencao

Objetivo: Registrar chamados específicos de manutenção predial e equipamentos.
Descrição: Tabela que gerencia chamados de manutenção com tipos específicos (elétrica, hidráulica, ar-condicionado, equipamento, estrutural, TI) e status detalhado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_chamado | bigint | NOT NULL | - | Identificador único do chamado, chave primária auto incrementada. |
| id_setor | int | NOT NULL | - | Referência ao setor onde a manutenção é necessária. |
| origem | enum('PA','INTERNACAO','AMBULATORIO','ADMINISTRATIVO') | NOT NULL | - | Origem do chamado: pronto atendimento, internação, ambulatório ou administrativo. |
| tipo_problema | enum('ELETRICO','HIDRAULICO','AR_CONDICIONADO','EQUIPAMENTO','ESTRUTURAL','TI','OUTRO') | NOT NULL | - | Tipo de problema: elétrico, hidráulico, ar-condicionado, equipamento, estrutural, TI ou outro. |
| descricao | text | NOT NULL | - | Descrição detalhada do problema de manutenção. |
| prioridade | enum('BAIXA','MEDIA','ALTA','CRITICA') | Nullable | 'MEDIA' | Nível de prioridade: baixa, média, alta ou crítica. |
| status | enum('ABERTO','EM_ATENDIMENTO','AGUARDANDO_PECA','RESOLVIDO','CANCELADO') | Nullable | 'ABERTO' | Status: aberto, em atendimento, aguardando peça, resolvido ou cancelado. |
| aberto_por | bigint | NOT NULL | - | Referência ao usuário que abriu o chamado. |
| aberto_em | datetime | Nullable | CURRENT_TIMESTAMP | Timestamp de abertura do chamado. |
| fechado_em | datetime | Nullable | - | Timestamp de fechamento do chamado. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o chamado pertence. |

## Chaves
- Primária: id_chamado
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_chamado)

## Constraints
- PRIMARY KEY: id_chamado

## Relacionamentos e Cardinalidade
- N:1 com setor (id_setor) - inferido
- N:1 com usuario (aberto_por) - inferido
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: setor, usuario, saas_entidade (inferido)

## Fluxo de utilização dentro do sistema
- Aberto para solicitações de manutenção predial e de equipamentos
- Originado de diferentes áreas: PA, internação, ambulatório ou administrativo
- Tipos de problema ajudam na direcionamento ao responsável técnico
- Status aguardando peça suporta o fluxo de espera por componentes
- Integrado com setor para localização precisa do problema