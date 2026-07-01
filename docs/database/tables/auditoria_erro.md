# auditoria_erro

Objetivo: Registrar todos os erros ocorridos durante as operações do sistema para análise e depuração.
Descrição: Tabela de auditoria que captura e persiste informações sobre erros do sistema, incluindo rotina, código SQLSTATE, errno, mensagem completa e contexto da falha.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_auditoria_erro | bigint | NOT NULL | - | Identificador único do registro de erro, chave primária auto incrementada. |
| id_sessao_usuario | bigint | Nullable | - | Referência à sessão do usuário em que o erro ocorreu (pode ser nulo). |
| rotina | varchar(128) | Nullable | - | Nome da rotina/procedimento onde o erro ocorreu. |
| sqlstate | varchar(10) | Nullable | - | Código SQLSTATE que identifica o tipo de erro. |
| errno | int | Nullable | - | Código numérico do erro específico. |
| mensagem | text | Nullable | - | Mensagem completa do erro ocorrido. |
| contexto | text | Nullable | - | Contexto adicional sobre a operação que falhou. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro de erro. |
| id_entidade | bigint unsigned | Nullable | - | Referência à entidade (organização) à qual o erro pertence (pode ser nulo). |

## Chaves
- Primária: id_auditoria_erro
- Únicas: nenhuma
- Estrangeiras: nenhuma

## Índices
- PRIMARY KEY (id_auditoria_erro)
- KEY idx_aud_erro_criado (criado_em)
- KEY idx_aud_erro_rotina (rotina)
- KEY idx_aud_erro_sessao (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id_auditoria_erro

## Relacionamentos e Cardinalidade
- N:1 com sessao_usuario (id_sessao_usuario) - opcional

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: sessao_usuario (opcional)

## Fluxo de utilização dentro do sistema
- Registrada automaticamente quando ocorre falha em procedimentos do sistema
- Usada para diagnóstico e debugging de problemas
- Permite correlacionar erros com sessões de usuários
- Base para análise de causa raiz de falhas no sistema