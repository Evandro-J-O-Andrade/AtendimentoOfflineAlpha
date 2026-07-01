# ffa_evolucao

Objetivo: Registro de evoluções clínicas por profissional

Descrição: Evoluções textuais associadas a FFA, com tipo, módulo, local operacional, IP, user-agent e hash de integridade para auditoria.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evolucao | bigint AUTO_INCREMENT | NO | — | Identificador único de evolucao |
| id_ffa | bigint | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_sessao_usuario | bigint | NO | — | Identificador da sessão do usuário |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| texto | longtext | NO | — | Campo do registro |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | Data e hora do registro |
| tipo | varchar(30) | NO | 'EVOLUCAO' | Endereço IP de origem da requisição |
| modulo | varchar(60) DEFAULT | YES | NULL | Módulo do sistema onde a evolução foi registrada |
| id_local_operacional | bigint DEFAULT | YES | NULL | Identificador do local |
| ip | varchar(60) DEFAULT | YES | NULL | Endereço IP de origem da requisição |
| user_agent | varchar(255) DEFAULT | YES | NULL | User-Agent do navegador ou aplicativo |
| hash_integridade | varchar(64) DEFAULT | YES | NULL | Hash SHA-256 para verificação de integridade |
| atualizado_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evolucao
- Estrangeira (fk_evo_usuario): coluna id_usuario -> tabela usuario(id_usuario): Referencia a tabela usuario (coluna id_usuario) para garantir integridade referencial

## Indices

- idx_evo_ffa (id_ffa)
- idx_evo_sessao (id_sessao_usuario)
- idx_evo_usuario (id_usuario)

## Constraints

- FOREIGN KEY fk_evo_usuario: id_usuario references usuario(id_usuario)
- PRIMARY KEY (id_evolucao)

## Relacionamentos e Cardinalidade

- ffa_evolucao (1) -> usuario (1): campo id_usuario

## Dependencias

- Depende de:
  - usuario
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Registra anotações textuais (evoluções) sobre o atendimento.
- Associada diretamente ao FFA para histórico completo.
- Permite integridade via hash e rastreabilidade por IP/user-agent.
- Consultada em relatórios de evolução e prontuário eletrônico.
