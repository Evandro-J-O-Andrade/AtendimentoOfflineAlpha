# gasoterapia_consumo_evento

Objetivo: Registrar eventos do consumo de gasoterapia.

Descrição: Tabela de auditoria que armazena os eventos ocorridos no consumo de gases medicinais, como início, encerramento, alterações de parâmetros. Mantém histórico das mudanças no consumo.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_evento | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada |
| id_consumo | bigint | NOT NULL | - | Referência ao consumo de gasoterapia ao qual o evento pertence |
| evento | varchar(50) | NOT NULL | - | Tipo de evento ocorrido (ex: INICIO, ENCERRAMENTO, AJUSTE) |
| detalhe | text | DEFAULT NULL | - | Detalhes do evento |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário que realizou o evento |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que realizou o evento |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_evento
- Únicas: -
- Estrangeiras: fk_gce_consumo (id_consumo → gasoterapia_consumo.id)

## Índices
- idx_gce_consumo (id_consumo)
- idx_gce_sessao (id_sessao_usuario)

## Constraints
- CONSTRAINT fk_gce_consumo FOREIGN KEY (id_consumo) REFERENCES gasoterapia_consumo (id)

## Relacionamentos e Cardinalidade
- gasoterapia_consumo_evento.id_consumo → gasoterapia_consumo (id): N:1 (vários eventos podem referenciar o mesmo consumo)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: gasoterapia_consumo

## Fluxo de utilização dentro do sistema
1. A cada mudança no consumo de gasoterapia, um evento é registrado
2. evento define o tipo de ação (INICIO, ENCERRAMENTO, AJUSTE)
3. detalhe fornece informações sobre o que mudou
4. id_usuario e id_sessao_usuario rastreiam a ação
5. Histórico é mantido para auditoria completa