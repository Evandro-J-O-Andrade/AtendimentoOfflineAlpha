# kernel_ledger

Objetivo: Manter um ledger (livro-razão) imutável de todas as transações e ações realizadas no sistema para auditoria e rastreabilidade.
Descrição: Tabela central do kernel que registra todas as transações, ações e eventos significativos ocorridos no sistema em formato imutável. Cada transação possui um UUID único, payload JSON com detalhes, status de processamento e métricas de duração. Serve como fonte de verdade para auditoria completa.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_transacao` | varchar(36) | NOT NULL | - | Identificador UUID único da transação (não é AUTO_INCREMENT para garantir unicidade global) |
| `id_sessao` | bigint | NULL | - | Identificador da sessão de usuário que realizou a transação |
| `id_usuario` | bigint | NOT NULL | - | Identificador do usuário que realizou a transação |
| `id_perfil` | bigint | NOT NULL | - | Identificador do perfil do usuário no momento da transação |
| `acao` | varchar(100) | NOT NULL | - | Nome da ação realizada (ex: INSERT, UPDATE, DELETE, EXECUTAR) |
| `contexto` | varchar(60) | NULL | 'DEFAULT' | Contexto da ação (ex: ATENDIMENTO, PACIENTE, LABORATORIO) |
| `payload` | json | NULL | NULL | Payload JSON contendo os dados da transação para auditoria |
| `status` | varchar(20) | NOT NULL | - | Status da transação (ex: SUCESSO, ERRO, PENDENTE) |
| `duracao_ms` | int | NULL | NULL | Duração da operação em milissegundos |
| `mensagem` | text | NULL | NULL | Mensagem de erro ou informação adicional |
| `id_tenant` | bigint | NULL | '1' | Identificador do tenant (organização cliente) |
| `registrado_em` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp de registro da transação |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do registro |

## Chaves
- Primária: `id_transacao` (varchar(36) - UUID)
- Únicas: -
- Estrangeiras: -

## Índices
- `idx_usuario` (KEY) - Índice composto em `id_usuario` e `registrado_em` para busca por usuário
- `idx_acao` (KEY) - Índice composto em `acao` e `registrado_em` para análise de ações
- `idx_contexto` (KEY) - Índice composto em `contexto` e `registrado_em` para filtros por contexto
- `idx_status` (KEY) - Índice composto em `status` e `registrado_em` para acompanhamento de status
- `idx_tenant` (KEY) - Índice composto em `id_tenant` e `registrado_em` para análise por tenant

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `usuario` - Muitas transações podem ter sido realizadas pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitas transações podem estar associadas a uma sessão
- N:1 com `perfil` - Muitas transações podem ter sido feitas com o mesmo perfil
- N:1 com `tenant` - Muitas transações podem pertencer a um tenant
- N:1 com `saas_entidade` - Muitas transações pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `usuario`, `sessao_usuario`, `perfil`, `tenant`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Antes de cada operação crítica, uma transação é aberta na tabela
2. O UUID é gerado para identificar unicamente a transação globalmente
3. O payload JSON contém os dados de entrada e saída para auditoria completa
4. Após a operação, o status e duração são atualizados
5. Em caso de erro, a mensagem contém detalhes do problema
6. Usado para replay de operações em caso de falhas
7. Servem como base para auditoria de compliance (ex: LGPD)
8. Permite rastrear histórico completo de todas as mudanças no sistema