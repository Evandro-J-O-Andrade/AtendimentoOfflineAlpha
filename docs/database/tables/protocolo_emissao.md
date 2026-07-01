# protocolo_emissao

Objetivo: Registrar protocolos de documentos emitidos como senhas, guias e outros documentos oficiais, com chave única e vínculo com pacientes e atendimentos.

Descrição: Tabela que controla a emissão de documentos protocolados como senhas, guias e outros documentos oficiais, permitindo rastremento de usuários, pacientes e fichas de atendimento associadas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_emissao | bigint | NOT NULL | - | Chave primária da tabela, identificador único da emissão do protocolo |
| tipo | varchar(30) | NOT NULL | - | Tipo do documento emitido (ex: SENHA, GUIA, LAUDO) |
| chave | varchar(80) | NOT NULL | - | Chave identificadora do protocolo para referência cruzada |
| codigo | varchar(50) | NOT NULL | - | Código único do documento protocolado |
| ano | int | YES | NULL | Ano de referência do protocolo |
| data_ref | date | YES | NULL | Data de referência do protocolo |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que emitiu o protocolo |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que emitiu o protocolo |
| id_paciente | bigint | YES | NULL | Referência ao id do paciente associado ao protocolo |
| id_ffa | bigint | YES | NULL | Referência ao id da ficha de atendimento assistido |
| id_senha | bigint | YES | NULL | Referência ao id da senha de atendimento associada |
| id_cliente | bigint | YES | NULL | Referência ao id do cliente/convênio |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação da emissão do protocolo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o protocolo foi emitido |

## Chaves
- Primária: id_emissao
- Únicas: uk_protocolo_emissao_codigo (codigo)
- Estrangeiras: fk_prot_em_cliente (id_cliente → cliente.id_cliente) - vincula o protocolo ao cliente; fk_prot_em_paciente (id_paciente → paciente.id) - vincula o protocolo ao paciente; fk_prot_em_usuario (id_usuario → usuario.id_usuario) - identifica o usuário que emitiu o protocolo

## Índices
- PRIMARY KEY (id_emissao)
- UNIQUE KEY uk_protocolo_emissao_codigo (codigo)
- KEY idx_prot_tipo_data (tipo, ano, data_ref, criado_em)
- KEY idx_prot_paciente (id_paciente)
- KEY idx_prot_ffa (id_ffa)
- KEY idx_prot_senha (id_senha)
- KEY idx_prot_cliente (id_cliente)
- KEY idx_prot_sessao (id_sessao_usuario)
- KEY fk_prot_em_usuario (id_usuario)

## Constraints
- CONSTRAINT fk_prot_em_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
- CONSTRAINT fk_prot_em_paciente FOREIGN KEY (id_paciente) REFERENCES paciente (id)
- CONSTRAINT fk_prot_em_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com cliente (um cliente pode ter vários protocolos emitidos)
- N:1 com paciente (um paciente pode ter vários protocolos)
- N:1 com ffa (uma FFA pode ter vários protocolos)
- N:1 com senha (uma senha pode ter vários protocolos)
- N:1 com usuario (um usuário pode emitir vários protocolos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: cliente, paciente, usuario

## Fluxo de utilização dentro do sistema
- Criado quando um documento protocolado é emitido
- Usado para rastrear documentos como senhas, guias e laudos
- Permite filtragem por tipo, data e cliente
- Vinculado a múltiplas entidades para contexto