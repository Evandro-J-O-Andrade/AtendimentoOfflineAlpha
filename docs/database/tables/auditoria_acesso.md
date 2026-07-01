# auditoria_acesso

Objetivo: Registrar e auditar todos os acessos a recursos sensíveis do sistema por usuários autenticados.
Descrição: Tabela de auditoria que registra cada acesso a recursos do sistema, incluindo tipo de ação (READ, SEARCH, EXPORT, etc.), recursos acessados, IP de origem e user agent, para fins de compliance e segurança.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_auditoria_acesso | bigint | NOT NULL | - | Identificador único do registro de auditoria, chave primária auto incrementada. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou o acesso. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário que realizou o acesso. |
| recurso | varchar(120) | NOT NULL | - | Nome ou identificador do recurso ao qual foi feito o acesso. |
| acao | enum('READ','SEARCH','EXPORT','PRINT','DOWNLOAD','VIEW') | NOT NULL | 'READ' | Tipo de ação realizada: leitura, busca, exportação, impressão, download ou visualização. |
| detalhe | text | Nullable | - | Detalhes adicionais sobre a operação realizada. |
| ip | varchar(60) | Nullable | - | Endereço IP de origem do acesso. |
| user_agent | varchar(255) | Nullable | - | User agent do navegador/dispositivo utilizado no acesso. |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro de auditoria. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_auditoria_acesso
- Únicas: nenhuma
- Estrangeiras:
  - fk_aud_acesso_sessao: id_sessao_usuario → sessao_usuario (id_sessao_usuario)

## Índices
- PRIMARY KEY (id_auditoria_acesso)
- KEY idx_aud_acesso_sessao (id_sessao_usuario)
- KEY idx_aud_acesso_usuario (id_usuario)
- KEY idx_aud_acesso_recurso (recurso)
- KEY idx_aud_acesso_data (criado_em)

## Constraints
- PRIMARY KEY: id_auditoria_acesso
- FOREIGN KEY: fk_aud_acesso_sessao (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com usuario (id_usuario)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: sessao_usuario

## Fluxo de utilização dentro do sistema
- Registrada automaticamente sempre que um usuário acessa recursos do sistema
- Usada para compliance e auditoria de acesso a dados sensíveis
- Monitoramento de atividades suspeitas ou não autorizadas
- Base para relatórios de segurança e conformidade regulatória