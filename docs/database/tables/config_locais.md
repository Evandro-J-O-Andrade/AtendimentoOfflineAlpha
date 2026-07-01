# config_locais

Objetivo: Configurar locais operacionais disponíveis por unidade para atendimento.
Descrição: Tabela que define locais operacionais (recepção, triagem, consultório, exame, medicação) vinculados a unidades para roteamento de atendimentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Identificador único do local, chave primária auto incrementada. |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o local está configurado. |
| nome | varchar(100) | NOT NULL | - | Nome do local operacional. |
| tipo | enum('RECEPCAO','TRIAGEM','CONSULTORIO','EXAME','MEDICACAO') | Nullable | - | Tipo: recepção, triagem, consultório, exame ou medicação. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o local está ativo no sistema. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização). |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_config_locais_unidade: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id)
- KEY fk_config_locais_unidade (id_unidade)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_config_locais_unidade (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (id_unidade) - muitos locais podem pertencer a uma unidade
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: unidade, saas_entidade

## Fluxo de utilização dentro do sistema
- Configurado durante setup da unidade
- Locais ativos são exibidos para seleção em atendimentos
- Tipo define capacidade e função do local
- Usado no fluxo de triagem para direcionamento
- Integra-se com painel de filas para exibição de senhas