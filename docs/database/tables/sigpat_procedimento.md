# sigpat_procedimento

**Objetivo:** Procedimentos do sistema SIGPAT

**Descrição:** A tabela `sigpat_procedimento` armazena dados relacionados a procedimentos do sistema sigpat. Contém 13 colunas, com chave primária em `id_sigpat`. Possui restrições de unicidade em: codigo.

## Colunas

| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_sigpat | BIGINT | Não | NULL | Campo numérico inteiro |
| codigo | VARCHAR(20) | Não | NULL | Código de identificação do item |
| descricao | VARCHAR(255) | Não | NULL | Descrição textual do item |
| tipo | ENUM('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') | Não | NULL | Classificação ou tipo do registro |
| grupo | VARCHAR(100) | Sim | NULL | Campo de texto de comprimento variável |
| subgrupo | VARCHAR(100) | Sim | NULL | Campo de texto de comprimento variável |
| ativo | TINYINT(1) | Sim | '1' | Indica se o registro está ativo (1) ou inativo (0) |
| setor_execucao | ENUM('RX','LABORATORIO','ECG','MEDICACAO','AMBULATORIO','OUTRO') | Não | 'OUTRO' | Campo de enumeração com valores predefinidos |
| gera_faturamento | TINYINT(1) | Sim | '1' | Dados de faturamento |
| exige_coleta | TINYINT(1) | Sim | '0' | Campo numérico inteiro |
| criado_em | TIMESTAMP | Sim | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | TIMESTAMP | Sim | CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Data e hora da última atualização do registro |
| id_entidade | BIGINT | Não | NULL | Identificador da entidade SaaS/multi-tenant proprietária do registro |

## Chaves

- **Primária:** `id_sigpat`
- **Únicas:**
  - uk_sigpat_codigo: `codigo`

## Índices

- Nenhum índice secundário além da chave primária.

## Constraints

- UNIQUE KEY `uk_sigpat_codigo` em (`codigo`)
- PRIMARY KEY em (`id_sigpat`)

## Relacionamentos e Cardinalidade

- Nenhum relacionamento de chave estrangeira direto identificado no DDL.

## Dependências

- **Referenciado por:** Tabelas que possuem chave estrangeira apontando para `sigpat_procedimento` (verificar manualmente)

## Fluxo de utilização dentro do sistema

Armazena dados auxiliares para integração com sistemas públicos de saúde (SIGTAP, TUSS, CNES, CID-10) e regras de faturamento/conveniência.
