# md_arquivo_fonte

Objetivo: Gerenciar arquivos de dados fonte para importação de tabelas auxiliares (CID10, CNES, SIGTAP, SIGPAT).
Descrição: Tabela que controla os arquivos de dados fonte utilizados para atualização de tabelas auxiliares do sistema, incluindo competência, origem, hash de integridade e status de processamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_md_arquivo_fonte` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do arquivo fonte |
| `tipo` | enum('CID10','CNES','SIGTAP','SIGPAT','OUTRO') | NOT NULL | - | Tipo de dado do arquivo (CID10, CNES, SIGTAP, SIGPAT, OUTRO) |
| `competencia` | char(6) | NULL | NULL | Competência da versão (ex: "202401" para jan/2024) |
| `origem` | varchar(120) | NULL | NULL | URL ou origem do arquivo |
| `descricao` | varchar(255) | NULL | NULL | Descrição do arquivo |
| `url_origem` | varchar(255) | NULL | NULL | URL direta para download do arquivo |
| `nome_arquivo` | varchar(200) | NULL | NULL | Nome do arquivo baixado |
| `tamanho_bytes` | bigint | NULL | NULL | Tamanho do arquivo em bytes |
| `sha256` | char(64) | NULL | NULL | Hash SHA256 para verificação de integridade |
| `baixado_em` | datetime | NULL | NULL | Timestamp do download do arquivo |
| `processado_em` | datetime | NULL | NULL | Timestamp do processamento do arquivo |
| `status` | enum('PENDENTE','BAIXADO','PROCESSADO','ERRO') | NOT NULL | 'PENDENTE' | Status do processamento do arquivo |
| `mensagem_erro` | varchar(500) | NULL | NULL | Mensagem de erro se ocorrer falha |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_md_arquivo_fonte`
- Únicas: -
- Estrangeiras: 
  - `fk_md_fonte_competencia` (`competencia`) → `md_competencia` (`competencia`) - Vincula arquivo à competência

## Índices
- `idx_md_fonte_tipo_comp` (KEY) - Índice composto em `tipo` e `competencia`
- `idx_md_fonte_status` (KEY) - Índice em `status`
- `idx_md_fonte_sha` (KEY) - Índice em `sha256`
- `fk_md_fonte_competencia` (KEY) - Índice em `competencia`

## Constraints
- `fk_md_fonte_competencia` FOREIGN KEY - Relaciona `competencia` com `md_competencia`.`competencia`

## Relacionamentos e Cardinalidade
- N:1 com `md_competencia` - Muitos arquivos podem ter a mesma competência
- N:1 com `saas_entidade` - Muitos arquivos pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: `md_arquivo_fonte_evento`
- Esta tabela depende de: `md_competencia`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Sistema verifica periodicamente por novas versões de arquivos fonte
2. Arquivo é baixado e hash SHA256 é calculado para verificação
3. Status PENDENTE indica aguardando processamento
4. BAIXADO indica arquivo baixado com sucesso
5. PROCESSADO indica arquivo lido e dados importados
6. ERRO indica falha no download ou processamento
7. A competência permite manter múltiplas versões históricas
8. Usado para atualização de tabelas CID10, CNES, SIGTAP e SIGPAT
9. Integração com Ministério da Saúde para atualização automática