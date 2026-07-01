# reg_auditoria_acesso_sensivel

Objetivo: Registrar auditoria de acesso a informações sensíveis no sistema, como visualização, exportação e impressão de prontuários.

Descrição: Tabela que mantém registro de auditoria quando há acesso a informações sensíveis no sistema, permitindo rastrear quem acessou, quando, de onde, e por qual motivo, com diferentes tipos de ações (VISUALIZAR, EXPORTAR, IMPRIMIR, ANEXAR, ALTERAR).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_acesso | bigint | NOT NULL | - | Chave primária da tabela, identificador único do registro de acesso |
| ocorrido_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora do acesso ao recurso sensível |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que realizou o acesso |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que realizou o acesso |
| entidade_ref | varchar(80) | NOT NULL | - | Nome da entidade acessada (ex: prontuario, atendimento) |
| id_ref | bigint | NOT NULL | - | Id do registro da entidade acessada |
| acao | enum('VISUALIZAR','EXPORTAR','IMPRIMIR','ANEXAR','ALTERAR') | NOT NULL | 'VISUALIZAR' | Tipo de ação realizada: VISUALIZAR, EXPORTAR, IMPRIMIR, ANEXAR ou ALTERAR |
| motivo | varchar(255) | YES | NULL | Motivo justificando o acesso à informação sensível |
| ip_origem | varchar(60) | YES | NULL | Endereço IP de origem do acesso |
| user_agent | varchar(255) | YES | NULL | User agent do navegador/dispositivo utilizado no acesso |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o acesso ocorreu |

## Chaves
- Primária: id_acesso
- Únicas: -
- Estrangeiras: fk_reg_acesso_usuario (id_usuario → usuario.id_usuario) - identifica o usuário que realizou o acesso

## Índices
- PRIMARY KEY (id_acesso)
- KEY idx_reg_acesso_dt (ocorrido_em)
- KEY idx_reg_acesso_ref (entidade_ref, id_ref)
- KEY idx_reg_acesso_usuario (id_usuario)
- KEY idx_reg_acesso_sessao (id_sessao_usuario)

## Constraints
- CONSTRAINT fk_reg_acesso_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode ter vários acessos a recursos sensíveis)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: usuario

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando há acesso a recursos sensíveis
- Permite auditoria completa de acesso a prontuários e informações médicas
- IP e user agent permitem rastrear origem e dispositivo do acesso
- Motivo obrigatório para justificar acesso não rotineiro