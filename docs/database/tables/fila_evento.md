# fila_evento

Objetivo: Registrar eventos ocorridos nas senhas da fila de atendimento.

Descrição: Tabela que armazena o histórico de eventos relacionados às senhas de atendimento, como geração, chamada, não atendido, reentrada e abertura de FFA. Utilizada para auditoria e rastreamento do fluxo das senhas na fila.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do evento, chave primária auto incrementada |
| id_fila | bigint | NOT NULL | - | Referência à senha da fila (fila_senha) à qual o evento está associado |
| evento | enum('GERADA','CHAMADA','NAO_ATENDIDO','REENTRADA','ABERTURA_FFA','ENCAMINHAMENTO') | NOT NULL | - | Tipo de evento: gerada, chamada, não atendido, reentrada, abertura de FFA ou encaminhamento |
| id_usuario | bigint | DEFAULT NULL | - | Referência ao usuário que realizou o evento (quem chamou, reentrada, etc) |
| id_local | bigint | DEFAULT NULL | - | Referência ao local onde o evento ocorreu |
| detalhe | text | DEFAULT NULL | - | Detalhes complementares sobre o evento |
| criado_em | datetime | DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro do evento |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fila_evento_ibfk_1 (id_fila → fila_senha.id)

## Índices
- id_fila (id_fila)

## Constraints
- CONSTRAINT fila_evento_ibfk_1 FOREIGN KEY (id_fila) REFERENCES fila_senha (id)

## Relacionamentos e Cardinalidade
- fila_evento.id_fila → fila_senha (id): N:1 (vários eventos podem referenciar a mesma senha)
- fila_evento.id_usuario → usuario (id_usuario): N:1 (vários eventos podem ser realizados pelo mesmo usuário)
- fila_evento.id_local → local (id_local): N:1 (vários eventos podem ocorrer no mesmo local)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: fila_senha, usuario, local

## Fluxo de utilização dentro do sistema
1. Senha é gerada na fila e evento "GERADA" é registrado
2. Senha é chamada: evento "CHAMADA" é criado com id_usuario e id_local
3. Se não atendida: evento "NAO_ATENDIDO" é registrado
4. Se reentrada: evento "REENTRADA" é criado
5. Quando abre FFA: evento "ABERTURA_FFA" vincula à senha
6. Para encaminhamentos: evento "ENCAMINHAMENTO" é registrado