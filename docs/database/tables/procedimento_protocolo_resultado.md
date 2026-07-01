# procedimento_protocolo_resultado

Objetivo: Armazenar os resultados dos procedimentos médicos como exames e raio-x, com versionamento e controle de histórico.

Descrição: Tabela que registra os resultados obtidos após a execução de protocolos de procedimentos, permitindo versionamento para atualizações de resultados e vinculação com resultados anteriores.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_resultado | bigint | NOT NULL | - | Chave primária da tabela, identificador único do resultado |
| id_protocolo | bigint | NOT NULL | - | Referência ao id do protocolo de procedimento ao qual o resultado pertence |
| categoria | varchar(30) | NOT NULL | - | Categoria do resultado (ex: LABORATORIAL, IMAGEM, etc.) |
| conteudo | longtext | YES | NULL | Conteúdo do resultado em formato texto ou estruturado |
| versao | int | NOT NULL | '1' | Versão do resultado, permitindo atualizações |
| id_resultado_anterior | bigint | YES | NULL | Referência ao id do resultado anterior na versão anterior |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do resultado |
| id_sessao_usuario | bigint | YES | NULL | Referência ao id da sessão do usuário que lançou o resultado |
| id_usuario | bigint | YES | NULL | Referência ao id do usuário que lançou o resultado |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o resultado foi lançado |

## Chaves
- Primária: id_resultado
- Únicas: uk_pp_res (id_protocolo, categoria, versao)
- Estrangeiras: fk_pp_res_prev (id_resultado_anterior → procedimento_protocolo_resultado.id_resultado) - vincula a versão atual à anterior; fk_pp_res_proto (id_protocolo → procedimento_protocolo.id_protocolo) - vincula o resultado ao protocolo; fk_pp_res_user (id_usuario → usuario.id_usuario) - identifica o usuário que lançou o resultado

## Índices
- PRIMARY KEY (id_resultado)
- UNIQUE KEY uk_pp_res (id_protocolo, categoria, versao)
- KEY idx_pp_res_proto (id_protocolo, criado_em)
- KEY idx_pp_res_cat (categoria, criado_em)
- KEY fk_pp_res_prev (id_resultado_anterior)
- KEY fk_pp_res_sessao (id_sessao_usuario)
- KEY fk_pp_res_user (id_usuario)

## Constraints
- CONSTRAINT fk_pp_res_prev FOREIGN KEY (id_resultado_anterior) REFERENCES procedimento_protocolo_resultado (id_resultado)
- CONSTRAINT fk_pp_res_proto FOREIGN KEY (id_protocolo) REFERENCES procedimento_protocolo (id_protocolo)
- CONSTRAINT fk_pp_res_user FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com procedimento_protocolo (um protocolo pode ter vários resultados em categorias diferentes)
- 1:1 com procedimento_protocolo_resultado (auto-referência para versionamento)
- N:1 com usuario (um usuário pode lançar vários resultados)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: procedimento_protocolo, usuario

## Fluxo de utilização dentro do sistema
- Criado quando um resultado é lançado após a execução do protocolo
- Permite versionamento para correções ou atualizações de resultados
- Cada categoria de resultado tem sua versão independente
- Utilizado para armazenar laudos e resultados de exames