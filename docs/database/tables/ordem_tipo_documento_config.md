# ordem_tipo_documento_config

Objetivo: Configurar o mapeamento entre tipos de ordem assistencial e tipos de documentos gerados.
Descrição: Tabela que define quais tipos de documentos podem ser gerados a partir de cada tipo de ordem assistencial. Permite configurar se a geração é apenas para medicamentos controlados, não controlados, ou ambos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| tipo_ordem | varchar(50) | NOT NULL | - | Tipo da ordem assistencial (ex: MEDICACAO, EXAME, RECEITA) |
| tipo_documento | varchar(60) | NOT NULL | - | Tipo do documento a ser gerado (ex: MEDICACAO_INTERNA, RECEITA_CONTROLADO) |
| somente_controlado | tinyint(1) | NOT NULL | '0' | Flag indicando se o documento deve ser gerado apenas para medicamentos controlados |
| somente_nao_controlado | tinyint(1) | NOT NULL | '0' | Flag indicando se o documento deve ser gerado apenas para medicamentos não controlados |
| ativo | tinyint(1) | NOT NULL | '1' | Flag de status: se a configuração está ativa |
| id_entidade | bigint unsigned | YES | NULL | ID da entidade/tenant à qual a configuração pertence (NULL = global) |

## Chaves
- Primária: (tipo_ordem, tipo_documento)
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_ordem_doc_tipo: tipo_documento → documento_tipo_config (codigo)

## Índices
- PRIMARY KEY (tipo_ordem, tipo_documento)
- KEY fk_ordem_doc_tipo (tipo_documento)

## Constraints
- PRIMARY KEY: (tipo_ordem, tipo_documento)
- FOREIGN KEY: fk_ordem_doc_tipo

## Relacionamentos e Cardinalidade
- N:1 com documento_tipo_config: Muitas configurações de ordem podem mapear para um tipo de documento

## Dependências
- Esta tabela depende de: documento_tipo_config
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada ao finalizar uma ordem assistencial para determinar quais documentos devem ser gerados automaticamente. Por exemplo, ao encerrar uma ordem do tipo MEDICACAO, o sistema consulta esta tabela para saber que deve gerar um documento MEDICACAO_INTERNA. Permite configurar regras de negócio para geração automática de documentos.