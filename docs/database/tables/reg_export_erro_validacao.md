# reg_export_erro_validacao

Objetivo: Registrar erros de validação ocorridos durante o processo de exportação de dados, com severidade e detalhes do erro.

Descrição: Tabela que armazena os erros encontrados durante a validação de itens ou arquivos de exportação, permitindo classificação por severidade (INFO, WARN, ERRO, FATAL) e rastreamento do campo e mensagem de erro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_export_erro | bigint | NOT NULL | - | Chave primária da tabela, identificador único do erro de validação |
| id_export_item | bigint | YES | NULL | Referência ao id do item de exportação que gerou o erro |
| id_export_arquivo | bigint | YES | NULL | Referência ao id do arquivo de exportação que gerou o erro |
| severidade | enum('INFO','WARN','ERRO','FATAL') | NOT NULL | 'ERRO' | Severidade do erro: INFO, WARN, ERRO ou FATAL |
| codigo | varchar(60) | YES | NULL | Código identificador do tipo de erro |
| campo | varchar(120) | YES | NULL | Nome do campo que gerou o erro de validação |
| mensagem | varchar(500) | NOT NULL | - | Mensagem detalhada descrevendo o erro ocorrido |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro do erro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o erro ocorreu |

## Chaves
- Primária: id_export_erro
- Únicas: -
- Estrangeiras: fk_reg_erro_arquivo (id_export_arquivo → reg_export_arquivo.id_export_arquivo) - vincula o erro ao arquivo; fk_reg_erro_item (id_export_item → reg_export_item.id_export_item) - vincula o erro ao item

## Índices
- PRIMARY KEY (id_export_erro)
- KEY idx_reg_erro_item (id_export_item)
- KEY idx_reg_erro_arquivo (id_export_arquivo)
- KEY idx_reg_erro_data (criado_em)

## Constraints
- CONSTRAINT fk_reg_erro_arquivo FOREIGN KEY (id_export_arquivo) REFERENCES reg_export_arquivo (id_export_arquivo)
- CONSTRAINT fk_reg_erro_item FOREIGN KEY (id_export_item) REFERENCES reg_export_item (id_export_item)

## Relacionamentos e Cardinalidade
- N:1 com reg_export_item (um item pode ter vários erros)
- N:1 com reg_export_arquivo (um arquivo pode ter vários erros)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: reg_export_item, reg_export_arquivo

## Fluxo de utilização dentro do sistema
- Registrado automaticamente quando há falha na validação de dados de exportação
- Permite classificação por severidade para priorização de correções
- Rastreia campo específico que gerou o erro
- Integrado ao processo de exportação em lote