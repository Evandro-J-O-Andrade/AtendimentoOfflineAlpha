# qualidade_eventos_adversos

Objetivo: Registrar eventos adversos ocorridos durante atendimentos para monitoramento de qualidade e segurança do paciente.

Descrição: Tabela que documenta eventos adversos relacionados à qualidade do atendimento e segurança do paciente, como quedas, erros de medicação, infecções em sitios, lesões por pressão e outros eventos monitorados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Chave primária da tabela, identificador único do evento adverso |
| id_atendimento | bigint | NOT NULL | - | Referência ao id do atendimento onde o evento adverso ocorreu |
| tipo_evento | enum('QUEDA','ERRO_MEDICACAO','INFECCAO_SITIO','LESÃO_PRESSAO','OUTROS') | YES | NULL | Tipo do evento adverso: QUEDA, ERRO_MEDICACAO, INFECCAO_SITIO, LESÃO_PRESSAO ou OUTROS |
| gravidade | enum('LEVE','MODERADA','GRAVE','SENTINELA') | YES | NULL | Gravidade do evento: LEVE, MODERADA, GRAVE ou SENTINELA (evento sentinelas são situações que quase resultaram em dano grave) |
| descricao | text | YES | NULL | Descrição detalhada do evento adverso |
| data_evento | datetime | - | CURRENT_TIMESTAMP | Data e hora do evento adverso |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o evento ocorreu |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter vários eventos adversos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: atendimento

## Fluxo de utilização dentro do sistema
- Registrado quando ocorre um evento adverso durante atendimento
- Permite análise de padrões e implementação de ações corretivas
- Eventos sentinelas são monitorados com prioridade
- Integrado ao sistema de qualidade e segurança do paciente