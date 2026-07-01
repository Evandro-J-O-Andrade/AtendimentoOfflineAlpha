# ffa

Objetivo: Fluxo de Atendimento Ambulatorial (FFA)

Descrição: Fluxo de Atendimento Ambulatorial (FFA) representando o atendimento completo do paciente na unidade, com estados clínicos, contexto de fluxo, versão de ledger e trilha de abertura.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_ffa | bigint unsigned AUTO_INCREMENT | NO | — | Identificador do fluxo de atendimento ambulatorial |
| id_unidade | bigint unsigned | NO | — | Identificador da unidade de saúde |
| id_paciente | bigint unsigned | NO | — | Identificador único de paciente |
| estado_clinico | enum('AGUARDANDO_TRIAGEM','EM_TRIAGEM','AGUARDANDO_ATENDIMENTO','EM_ATENDIMENTO','OBSERVACAO','MEDICACAO','EXAMES','ALTA','EVASAO','TRANSFERENCIA','INTERNACAO','FINALIZADO') COLLATE utf8mb4_unicode_ci | NO | 'AGUARDANDO_TRIAGEM' | Estado clínico atual do atendimento |
| contexto_fluxo | json DEFAULT | YES | NULL | Contexto do fluxo de atendimento em formato JSON |
| versao_ledger | bigint unsigned | YES | '1' | Versão do ledger de eventos do FFA |
| id_sessao_usuario_abertura | bigint unsigned DEFAULT | YES | NULL | Identificador da sessão do usuário |
| criado_em | datetime(6) | NO | CURRENT_TIMESTAMP(6) | Data e hora do registro |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data e hora do registro |
| fechado_em | datetime(6) DEFAULT | YES | NULL | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_ffa
- Estrangeira (fk_ffa_entidade): coluna id_entidade -> tabela saas_entidade(id_entidade): Referencia a tabela saas_entidade (coluna id_entidade) para garantir integridade referencial
- Estrangeira (fk_ffa_unidade): coluna id_unidade -> tabela unidade(id_unidade): Referencia a tabela unidade (coluna id_unidade) para garantir integridade referencial

## Indices

- idx_ffa_paciente (id_paciente)
- idx_ffa_estado (estado_clinico)
- fk_ffa_unidade (id_unidade)
- idx_ffa_entidade_unidade (id_entidade, id_unidade)

## Constraints

- FOREIGN KEY fk_ffa_entidade: id_entidade references saas_entidade(id_entidade)
- FOREIGN KEY fk_ffa_unidade: id_unidade references unidade(id_unidade)
- PRIMARY KEY (id_ffa)

## Relacionamentos e Cardinalidade

- ffa (1) -> saas_entidade (1): campo id_entidade
- ffa (1) -> unidade (1): campo id_unidade

## Dependencias

- Depende de:
  - saas_entidade
  - unidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Representa o atendimento do paciente na unidade desde a abertura até o fechamento.
- Transit por estados clínicos (triagem, atendimento, exames, alta, etc.).
- Centraliza contexto, eventos, evoluções, diagnósticos e itens adicionais.
- É o hub central do módulo ambulatorial, vinculando todas as outras tabelas FFA.
