# caixa

Objetivo: Controlar o estado de abertura/fechamento de caixas de atendimento/operação.
Descrição: Tabela que gerencia o ciclo de vida do caixa do sistema, registrando abertura e fechamento com responsáveis e local de operação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_caixa | bigint | NOT NULL | - | Identificador único do caixa, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o caixa está localizado. |
| id_local_operacional | bigint | NOT NULL | - | Referência ao local operacional onde o caixa está vinculado. |
| status | enum('ABERTO','FECHADO') | NOT NULL | 'FECHADO' | Estado atual do caixa: aberto ou fechado. |
| aberto_em | datetime | Nullable | - | Data e hora em que o caixa foi aberto. |
| fechado_em | datetime | Nullable | - | Data e hora em que o caixa foi fechado. |
| aberto_por | bigint | Nullable | - | Referência ao usuário que abriu o caixa. |
| fechado_por | bigint | Nullable | - | Referência ao usuário que fechou o caixa. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o caixa pertence. |

## Chaves
- Primária: id_caixa
- Únicas: nenhuma
- Estrangeiras:
  - fk_caixa_aberto_por: aberto_por → usuario (id_usuario)
  - fk_caixa_fechado_por: fechado_por → usuario (id_usuario)
  - fk_caixa_localop: id_local_operacional → local_operacional (id_local_operacional)

## Índices
- PRIMARY KEY (id_caixa)
- KEY idx_caixa_status (status)
- KEY fk_caixa_unidade (id_unidade)
- KEY fk_caixa_localop (id_local_operacional)
- KEY fk_caixa_aberto_por (aberto_por)
- KEY fk_caixa_fechado_por (fechado_por)

## Constraints
- PRIMARY KEY: id_caixa
- FOREIGN KEY: fk_caixa_aberto_por (aberto_por) REFERENCES usuario (id_usuario)
- FOREIGN KEY: fk_caixa_fechado_por (fechado_por) REFERENCES usuario (id_usuario)
- FOREIGN KEY: fk_caixa_localop (id_local_operacional) REFERENCES local_operacional (id_local_operacional)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade)
- N:1 com local_operacional (id_local_operacional)
- N:1 com usuario (aberto_por) - opcional
- N:1 com usuario (fechado_por) - opcional
- N:1 com saas_entidade (id_entidade)
- 1:N com caixa_evento (id_caixa) - um caixa pode ter muitos eventos

## Dependências
- Tabelas que dependem desta: caixa_evento
- Dependência desta tabela: unidade, usuario, local_operacional, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado ao abrir um novo caixa no início do expediente
- Atualizado ao fechar o caixa ao final do expediente
- Apenas um caixa pode estar aberto por unidade/local por vez (validado na aplicação)
- Eventos de caixa registrados em caixa_evento para auditoria