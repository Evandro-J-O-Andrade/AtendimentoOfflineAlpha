# log_leitura_prontuario

Objetivo: Registrar acessos de leitura ao prontuário eletrônico para controle de privacidade e auditoria.
Descrição: Tabela específica para log de leitura de prontuários, capturando motivo do acesso quando informado pelo usuário, complementando o log_acesso_prontuario.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do log |
| `id_atendimento` | bigint | NOT NULL | - | Atendimento cujo prontuário foi lido |
| `id_usuario` | bigint | NOT NULL | - | Usuário que leu o prontuário |
| `data_hora` | datetime | NULL | CURRENT_TIMESTAMP | Timestamp da leitura |
| `motivo_acesso` | varchar(255) | NULL | NULL | Motivo declarado pelo usuário para acesso |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id`
- Únicas: -
- Estrangeiras: -

## Índices
- Não possui índices adicionais

## Constraints
- Não possui constraints de FOREIGN KEY

## Relacionamentos e Cardinalidade
- N:1 com `atendimento` - Muitas leituras podem ter sido do mesmo atendimento
- N:1 com `usuario` - Muitas leituras podem ter sido feitas pelo mesmo usuário
- N:1 com `saas_entidade` - Muitos logs pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `atendimento`, `usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Quando usuário acessa prontuário, pode ser solicitado o motivo
2. O motivo é armazenado para justificativa de acesso
3. Usado para auditoria LGPD - motivos de acesso a dados sensíveis
4. Permite relatórios de acesso por motivo
5. Usado para compliance com regulamentação de saúde
6. Base para investigações de uso inadequado de dados
7. Integração com sistema de alertas de privacidade