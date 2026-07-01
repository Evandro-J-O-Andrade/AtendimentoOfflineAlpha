# usuario_sistema_acl_evento

Objetivo: Registrar eventos de controle de acesso (ACL) relacionados a usuários e sistemas para auditoria de permissões.
Descrição: Tabela de log de eventos de controle de acesso que armazena tentativas e concessões de acesso a sistemas por usuários. Registra o evento ACL executado, o resultado (sucesso ou falha), origem do dispositivo e IP. Serve para auditoria de segurança, detecção de acessos indevidos e conformidade com políticas de controle de acesso.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_acl_evento | bigint | NO | AUTO_INCREMENT | Chave primária única que identifica o evento de controle de acesso |
| id_usuario | bigint | NO | NULL | Identificador do usuário que executou ou tentou executar a ação ACL |
| id_sistema | bigint | NO | NULL | Identificador do sistema no qual o evento ACL ocorreu |
| id_perfil | bigint | NO | NULL | Identificador do perfil que estava sendo utilizado no evento |
| evento | varchar(50) | NO | NULL | Nome ou código do evento de controle de acesso executado |
| sucesso | tinyint | YES | '1' | Flag que indica se a operação ACL foi bem-sucedida (1) ou falhou (0) |
| origem_dispositivo | varchar(100) | YES | NULL | Identificação do dispositivo ou origem do evento ACL |
| origem_ip | varchar(50) | YES | NULL | Endereço IP de origem da requisição do evento ACL |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data e hora de criação do evento ACL |
| id_entidade | bigint unsigned | NO | NULL | Identificador da entidade SaaS à qual este evento pertence |

## Chaves
- Primária: id_acl_evento
- Únicas: Nenhuma
- Estrangeiras: Nenhuma constraint FK explícita declarada na criação da tabela

## Índices
- idx_acl_usuario (id_usuario)
- idx_acl_evento_data (criado_em)

## Constraints
- Nenhuma constraint explícita declarada (as relações com usuario, sistema, perfil podem estar em nível de aplicação)

## Relacionamentos e Cardinalidade
- N:1 com usuario (muitos eventos ACL pertencem a um usuário)
- N:1 com sistema (muitos eventos pertencem a um sistema)
- N:1 com perfil (muitos eventos usam um perfil)

## Dependências
- Depende de: usuario, sistema, perfil, saas_entidade (relações implícitas)
- Dependências reversas: Nenhuma tabela principal depende diretamente desta

## Fluxo de utilização dentro do sistema
- Toda vez que o sistema realiza uma verificação de ACL (permissão de acesso a funcionalidade), um registro é inserido
- Usado para auditoria de quem acessou o quê e quando no sistema
- Permite detectar tentativas de acesso não autorizado a funcionalidades restritas
- Consultado em relatórios de conformidade e segurança
- Ajuda a identificar padrões de uso suspeitos ou excesso de privilégios
