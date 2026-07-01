# farm_atendimento_externo

Objetivo: Tabela do sistema

Descrição: Registra atendimentos de farmácia para pacientes externos, com dados do médico prescritor, receita, status e vínculo com atendimento.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_atendimento_ext | bigint AUTO_INCREMENT | NO | — | Identificador do atendimento |
| id_gpat | bigint | NO | — | Identificador do GPAT |
| origem | varchar(120) | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| nome_paciente | varchar(255) | NO | — | Nome completo do paciente |
| nome_medico | varchar(255) | NO | — | Nome do médico responsável |
| conselho_medico | varchar(10) DEFAULT | YES | NULL | Conselho profissional do médico |
| numero_conselho | varchar(30) DEFAULT | YES | NULL | Número sequencial do documento |
| uf_conselho | char(2) DEFAULT | YES | NULL | UF do conselho profissional |
| data_receita | date DEFAULT | YES | NULL | Data da receita médica |
| dias_tratamento | int DEFAULT | YES | NULL | Quantidade de dias de tratamento |
| status | enum('ABERTO','FINALIZADO','CANCELADO') | NO | 'ABERTO' | Status atual conforme enumeração definida |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| atualizado_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| id_atendimento | bigint unsigned | NO | — | Identificador do atendimento |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_atendimento_ext
- Estrangeira (fk_farm_atendimento_externo_atendimento): coluna id_atendimento -> tabela atendimento(id_atendimento): Referencia a tabela atendimento (coluna id_atendimento) para garantir integridade referencial
- Estrangeira (fk_farm_atendimento_externo_entidade): coluna id_entidade -> tabela saas_entidade(id_entidade): Referencia a tabela saas_entidade (coluna id_entidade) para garantir integridade referencial

## Indices

- ix_fext_gpat (id_gpat)
- ix_fext_status (status)
- fk_farm_atendimento_externo_atendimento (id_atendimento)
- idx_farm_ext_ent (id_entidade)

## Constraints

- FOREIGN KEY fk_farm_atendimento_externo_atendimento: id_atendimento references atendimento(id_atendimento)
- FOREIGN KEY fk_farm_atendimento_externo_entidade: id_entidade references saas_entidade(id_entidade)
- PRIMARY KEY (id_atendimento_ext)

## Relacionamentos e Cardinalidade

- farm_atendimento_externo (1) -> atendimento (1): campo id_atendimento
- farm_atendimento_externo (1) -> saas_entidade (1): campo id_entidade

## Dependencias

- Depende de:
  - atendimento
  - saas_entidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
