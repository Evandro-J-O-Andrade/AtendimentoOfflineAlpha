# reg_export_arquivo

Objetivo: Armazenar os arquivos gerados durante lotes de exportação de dados, com controle de formato, hash e armazenamento.

Descrição: Tabela que representa os arquivos individuais gerados durante processos de exportação em lote, permitindo rastrear cada arquivo, seu formato, tamanho e local de armazenamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_export_arquivo | bigint | NOT NULL | - | Chave primária da tabela, identificador único do arquivo de exportação |
| id_export_lote | bigint | NOT NULL | - | Referência ao id do lote de exportação ao qual o arquivo pertence |
| formato | enum('XML','PDF','JSON','CSV','ZIP','OUTRO') | NOT NULL | - | Formato do arquivo exportado: XML, PDF, JSON, CSV, ZIP ou OUTRO |
| mime_type | varchar(120) | YES | NULL | Tipo MIME do arquivo para identificação do formato |
| nome_arquivo | varchar(200) | NOT NULL | - | Nome do arquivo gerado |
| tamanho_bytes | bigint | YES | NULL | Tamanho do arquivo em bytes |
| sha256 | char(64) | YES | NULL | Hash SHA256 para verificação de integridade do arquivo |
| storage_uri | varchar(255) | YES | NULL | URI de armazenamento se o arquivo está em storage externo |
| conteudo_blob | longblob | YES | NULL | Conteúdo binário do arquivo se armazenado internamente |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do arquivo |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o arquivo foi gerado |

## Chaves
- Primária: id_export_arquivo
- Únicas: -
- Estrangeiras: fk_reg_arq_lote (id_export_lote → reg_export_lote.id_export_lote) - vincula o arquivo ao lote de exportação

## Índices
- PRIMARY KEY (id_export_arquivo)
- KEY idx_reg_arq_lote (id_export_lote)
- KEY idx_reg_arq_sha (sha256)

## Constraints
- CONSTRAINT fk_reg_arq_lote FOREIGN KEY (id_export_lote) REFERENCES reg_export_lote (id_export_lote)

## Relacionamentos e Cardinalidade
- N:1 com reg_export_lote (um lote pode ter vários arquivos)

## Dependências
- Tabelas que dependem desta: reg_export_erro_validacao
| Esta tabela depende de: reg_export_lote

## Fluxo de utilização dentro do sistema
- Criado automaticamente quando um lote de exportação gera arquivos
- Permite armazenamento interno ou referência a storage externo
- Hash SHA256 garante integridade dos arquivos exportados
- Formato padronizado facilita integração com sistemas externos