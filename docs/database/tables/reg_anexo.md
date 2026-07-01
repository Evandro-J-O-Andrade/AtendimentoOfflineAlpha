# reg_anexo

Objetivo: Armazenar arquivos anexos e documentos diversos no sistema, com controle de tipo, hash de integridade e armazenamento.

Descrição: Tabela que gerencia o armazenamento de anexos no sistema, permitindo anexar arquivos a diferentes entidades (prontuários, chamados, documentos), com controle de integridade via SHA256 e armazenamento em blob ou URI.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_anexo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do anexo |
| entidade_ref | varchar(80) | NOT NULL | - | Nome da entidade referenciada (ex: prontuario, chamado, documento) |
| id_ref | bigint | NOT NULL | - | Id do registro da entidade referenciada |
| categoria | enum('SINAN','CAT','DOCUMENTO','PRONTUARIO','OUTRO') | NOT NULL | 'OUTRO' | Categoria do anexo: SINAN, CAT, DOCUMENTO, PRONTUARIO ou OUTRO |
| nome_arquivo | varchar(200) | NOT NULL | - | Nome original do arquivo anexado |
| mime_type | varchar(120) | YES | NULL | Tipo MIME do arquivo para identificação do formato |
| tamanho_bytes | bigint | YES | NULL | Tamanho do arquivo em bytes |
| sha256 | char(64) | YES | NULL | Hash SHA256 para verificação de integridade do arquivo |
| storage_uri | varchar(255) | YES | NULL | URI de armazenamento se o arquivo está em storage externo |
| conteudo_blob | longblob | YES | NULL | Conteúdo binário do arquivo se armazenado internamente |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que fez upload |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que fez upload do anexo |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do anexo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o anexo foi armazenado |

## Chaves
- Primária: id_anexo
- Únicas: -
- Estrangeiras: fk_reg_anexo_usuario (id_usuario → usuario.id_usuario) - identifica o usuário que fez upload

## Índices
- PRIMARY KEY (id_anexo)
- KEY idx_reg_anexo_ref (entidade_ref, id_ref)
- KEY idx_reg_anexo_sha (sha256)
- KEY idx_reg_anexo_sessao (id_sessao_usuario)
- KEY idx_reg_anexo_usuario (id_usuario)

## Constraints
- CONSTRAINT fk_reg_anexo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com usuario (um usuário pode fazer upload de vários anexos)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: usuario

## Fluxo de utilização dentro do sistema
- Criado quando um arquivo é anexado a um registro do sistema
- Permite armazenamento interno (blob) ou externo (URI) dos arquivos
- Hash SHA256 garante integridade do arquivo
- Categoria permite classificação para relatórios específicos